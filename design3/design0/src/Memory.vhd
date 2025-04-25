library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory is
	port (	clk 		: in std_logic;
			reset		: in std_logic;
			mem_write	: in std_logic;	 
			mem_read	: in std_logic;
			address		: in std_logic_vector(31 downto 0);
			write_data 	: in std_logic_vector(31 downto 0);
			
			mem_data	: out std_logic_vector(31 downto 0));
end entity ;

architecture behavioral of Memory is
    type memory_array is array (0 to 1023) of STD_LOGIC_VECTOR(7 downto 0);
    signal memory : memory_array := (
    -- lw $s0, 128($zero)   => opcode: 100011, base: $zero, rt: $s0, offset: 128
    0 => "10001100", 1 => "00010000", 2 => "00000000", 3 => "10000000",

    -- lw $s1, 132($zero)   => opcode: 100011, base: $zero, rt: $s1, offset: 132
    4 => "10001100", 5 => "00010001", 6 => "00000000", 7 => "10000100",

    -- add $s2, $s0, $s1    => opcode: 000000, rs: $s0, rt: $s1, rd: $s2, shamt: 00000, funct: 100000
    8 => "00000010", 9 => "00010001", 10 => "10100000", 11 => "00100000",

    -- sw $s2, 136($zero)   => opcode: 101011, base: $zero, rt: $s2, offset: 136
    12 => "10101100", 13 => "00010100", 14 => "00000000", 15 => "10001000",

    -- sub $s3, $s1, $s0    => opcode: 000000, rs: $s1, rt: $s0, rd: $s3, shamt: 00000, funct: 100010
    16 => "00000010", 17 => "00100000", 18 => "11000000", 19 => "00100010",

    -- sw $s3, 140($zero)   => opcode: 101011, base: $zero, rt: $s3, offset: 140
    20 => "10101100", 21 => "00010110", 22 => "00000000", 23 => "10001100",

    -- and $s4, $s1, $s0    => opcode: 000000, rs: $s1, rt: $s0, rd: $s4, shamt: 00000, funct: 100100
    24 => "00000010", 25 => "00100000", 26 => "10000000", 27 => "00100100",

    -- sw $s4, 144($zero)   => opcode: 101011, base: $zero, rt: $s4, offset: 144
    28 => "10101100", 29 => "00011000", 30 => "00000000", 31 => "10010000",

    -- or $s5, $s1, $s0     => opcode: 000000, rs: $s1, rt: $s0, rd: $s5, shamt: 00000, funct: 100101
    32 => "00000010", 33 => "00100000", 34 => "10100000", 35 => "00100101",

    -- sw $s5, 148($zero)   => opcode: 101011, base: $zero, rt: $s5, offset: 148
    36 => "10101100", 37 => "00011010", 38 => "00000000", 39 => "10010100",

    -- slt $s6, $s1, $s0    => opcode: 000000, rs: $s1, rt: $s0, rd: $s6, shamt: 00000, funct: 101010
    40 => "00000010", 41 => "00100000", 42 => "11000000", 43 => "00101010",

    -- sw $s6, 152($zero)   => opcode: 101011, base: $zero, rt: $s6, offset: 152
    44 => "10101100", 45 => "00011100", 46 => "00000000", 47 => "10011000",

    -- beq $s0, $s4, 56     => opcode: 000100, rs: $s0, rt: $s4, offset: 56
    48 => "00010010", 49 => "00010100", 50 => "00000000", 51 => "00111000",

    -- j 8                  => opcode: 000010, target: 8
    52 => "00001000", 53 => "00000000", 54 => "00000000", 55 => "00001000",

    -- Data: used by lw/sw from address 128 onward
    128 => "00000001", 129 => "00000010", 130 => "00000011", 131 => "00000100", -- $s0 = 0x01020304
    132 => "00000101", 133 => "00000110", 134 => "00000111", 135 => "00001000", -- $s1 = 0x05060708
    136 => "00001001", 137 => "00001010", 138 => "00001011", 139 => "00001100",
    140 => "00001101", 141 => "00001110", 142 => "00001111", 143 => "00010000",
    144 => "00010001", 145 => "00010010", 146 => "00010011", 147 => "00010100",
    148 => "00010101", 149 => "00010110", 150 => "00010111", 151 => "00011000",
    152 => "00011001", 153 => "00011010", 154 => "00011011", 155 => "00011100",

    others => (others => '0')
);


begin
	-- Write process: stores each byte of the word 
	process(clk,reset)
	begin
		--if reset = '1' then
			--memory <= (others => (others => '0'));
		if (rising_edge(clk) and (mem_write='1')) then
			memory(to_integer(unsigned(address))) 		<= write_data(31 downto 24);
			memory(to_integer(unsigned(address)+1)) 	<= write_data(23 downto 16);
			memory(to_integer(unsigned(address)+2)) 	<= write_data(15 downto 8);
			memory(to_integer(unsigned(address)+3)) 	<= write_data(7 downto 0);
		end if;
	end process;
	-- Read combinational logic 
	process(clk, mem_read)
    begin
		if rising_edge(clk) then
        if mem_read = '1' then
            mem_data <= memory(to_integer(unsigned(address)))     &
                        memory(to_integer(unsigned(address) + 1)) &
                        memory(to_integer(unsigned(address) + 2)) &
                        memory(to_integer(unsigned(address) + 3));
		end if;
        
        end if;
    end process;
	
end architecture ;
	