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
        -- addi tests
        0  => x"20080005",  -- addi $t0, $zero, 5
        1  => x"20090003",  -- addi $t1, $zero, 3

        -- R-type tests
        2  => x"01095020",  -- add  $t2, $t0, $t1
        3  => x"01095022",  -- sub  $t2, $t0, $t1
        4  => x"01095024",  -- and  $t2, $t0, $t1
        5  => x"01095025",  -- or   $t2, $t0, $t1
        6  => x"00095080",   -- sll $t2, $t1, 2

        -- Memory instructions
        7  => x"AD0A0000",  -- sw   $t2, 0($t0)
        8  => x"8D0B0000",  -- lw   $t3, 0($t0)

        -- Branch
        9  => x"11090001",  -- beq  $t0, $t1, +1 (skip next)

        -- Jump
        10 => x"0800000A",  -- j    to address 0x0000000A

        others => (others => '0')
    );

    signal word_addr : unsigned(7 downto 0); -- enough for 256 words

begin

    -- PC is byte-addressed; instructions are word-aligned
    word_addr <= unsigned(ReadAddress(9 downto 2)); -- divide by 4

    Instruction <= IM(to_integer(word_addr));

end rom;
