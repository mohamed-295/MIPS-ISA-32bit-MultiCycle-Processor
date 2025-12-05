library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionMem is
    port (
        ReadAddress      : in  std_logic_vector(31 downto 0); -- PC input
        Instruction      : out std_logic_vector(31 downto 0)  -- instruction
    );
end InstructionMem;

architecture rom of InstructionMem is

    -- 256 words x 32-bit (you can increase size)
    type mem_array is array (0 to 255) of std_logic_vector(31 downto 0);

    constant IM : mem_array := (
	-- ==========================================
        
	-- 1. Initialization
        
	-- ==========================================
        
	0  => x"2008000A",  -- addi $t0, $zero, 10
        
	1  => x"2009000A",  -- addi $t1, $zero, 10         
	2  => x"200A0005",  -- addi $t2, $zero, 5
        
	3  => x"200B0000",  -- addi $t3, $zero, 0 (Base Address)

         
	-- ==========================================
        
	-- 2. Control Hazard Test (The Branch)
        
	-- ==========================================
        
	-- beq $t0, $t1, 4 (Offset = 4 words)
        
	-- 3 NOPs to prevent Control Hazard       
	4  => x"11090004",  
        
        
	-- === Branch Delay Slots (Software Stall) ===
        
	-- 3 NOPs to make the ALU gets it's time to calculate       
	5  => x"00000000", -- NOP 1
        
	6  => x"00000000", -- NOP 2
        
	7  => x"00000000", -- NOP 3
        
        
	-- === TRAP ZONE (should be skipped) ===
        
	-- if it works $s7 will be 0 if not working will be 99        
	8  => x"20170063", -- addi $s7, $zero, 99

        
	-- ==========================================
        
	-- 3. Data Hazard Test (Forwarding Priority 1 - EX)
        
	-- ==========================================
        
	-- Target of Branch line 9 
        
	-- add $t4, $t0, $t2  -> (10 + 5 = 15)
        
	9  => x"010A6020",  
        
	-- sub $t5, $t4, $t2  -> Needs Forwarding from EX
        
	10 => x"018A6822",

        
	-- ==========================================
        
	-- 4. Data Hazard Test (Forwarding Priority 2 - MEM)
        
	-- ==========================================
        
	-- add $t6, $t0, $t2
        
	11 => x"010A7020",
        
	-- and $t7, $t0, $t2 (Dummy)
        
	12 => x"010A7824",
        
	-- or  $s0, $t6, $t2 -> Needs Forwarding from WB
        
	13 => x"01CA8025",

        
	-- ==========================================
        
	-- 5. Load-Use Hazard Test (Software Stall)
        
	-- ==========================================
       
	-- sw $t0, 0($t3)
        
	14 => x"AD680000",
        
	-- lw $s1, 0($t3)
        
	15 => x"8D710000",
        
	-- NOP (Load Delay Slot)
        
	16 => x"00000000",
        
	-- add $s2, $s1, $t0 -> Forwarding from WB
        
	17 => x"02289020",
	others => (others => '0')
    );

    signal word_addr : unsigned(7 downto 0); -- enough for 256 words

begin

    -- PC is byte-addressed; instructions are word-aligned
    word_addr <= unsigned(ReadAddress(9 downto 2)); -- divide by 4

    Instruction <= IM(to_integer(word_addr));

end rom;
