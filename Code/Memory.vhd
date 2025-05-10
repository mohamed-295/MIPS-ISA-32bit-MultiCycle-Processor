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
    -- lw $s0, 128($zero)   => opcode: 100011, base: $zero(00000), rt: $s0(10000), offset: 128(0000 0000 1000 0000)
    0 => "10001100", 1 => "00010000", 2 => "00000000", 3 => "10000000",
    -- lw $s1, 132($zero)   => opcode: 100011, base: $zero(00000), rt: $s1(10001), offset: 132(0000 0000 1000 0100)
    4 => "10001100", 5 => "00010001", 6 => "00000000", 7 => "10000100",
    -- add $s2, $s0, $s1    => opcode: 000000, rs: $s0(10000), rt: $s1(10001), rd: $s2(10010), shamt: 00000, funct: 100000
    8 => "00000010", 9 => "00010001", 10 => "10010000", 11 => "00100000",
    -- sw $s2, 136($zero)   => opcode: 101011, base: $zero(00000), rt: $s2(10010), offset: 136(0000 0000 1000 1000)
    12 => "10101100", 13 => "00010010", 14 => "00000000", 15 => "10001000",
    -- sub $s3, $s1, $s0    => opcode: 000000, rs: $s1(10001), rt: $s0(10000), rd: $s3(10011), shamt: 00000, funct: 100010
    16 => "00000010", 17 => "00110000", 18 => "10011000", 19 => "00100010",
    -- sw $s3, 140($zero)   => opcode: 101011, base: $zero(00000), rt: $s3(10011), offset: 140(0000 0000 1000 1100)
    20 => "10101100", 21 => "00010011", 22 => "00000000", 23 => "10001100",
    -- and $s4, $s1, $s0    => opcode: 000000, rs: $s1(10001), rt: $s0(10000), rd: $s4(10100), shamt: 00000, funct: 100100
    24 => "00000010", 25 => "00110000", 26 => "10100000", 27 => "00100100",
    -- sw $s4, 144($zero)   => opcode: 101011, base: $zero(00000), rt: $s4(10100), offset: 144(0000 0000 1001 0000)
    28 => "10101100", 29 => "00010100", 30 => "00000000", 31 => "10010000",
    -- or $s5, $s1, $s0     => opcode: 000000, rs: $s1(10001), rt: $s0(10000), rd: $s5(10101), shamt: 00000, funct: 100101
    32 => "00000010", 33 => "00110000", 34 => "10101000", 35 => "00100101",
    -- sw $s5, 148($zero)   => opcode: 101011, base: $zero(00000), rt: $s5(10101), offset: 148(0000 0000 1001 0100)
    36 => "10101100", 37 => "00010101", 38 => "00000000", 39 => "10010100",
    -- slt $s6, $s1, $s0    => opcode: 000000, rs: $s1(10001), rt: $s0(10000), rd: $s6(10110), shamt: 00000, funct: 101010
    40 => "00000010", 41 => "00110000", 42 => "10110000", 43 => "00101010",
    -- sw $s6, 152($zero)   => opcode: 101011, base: $zero(00000), rt: $s6(10110), offset: 152(0000 0000 1001 1000)
    44 => "10101100", 45 => "00010110", 46 => "00000000", 47 => "10011000",
    -- beq $s0, $s4, 56     => opcode: 000100, rs: $s0(10000), rt: $s4(10100), offset: 56(0000 0000 0011 1000)
    48 => "00010010", 49 => "00010100", 50 => "00000000", 51 => "00111000",
    -- j 8                  => opcode: 000010, target: 8(0000 0000 0000 0000 0000 0000 0000 1000)
    52 => "00001000", 53 => "00000000", 54 => "00000000", 55 => "00001000",
    -- Data: used by lw/sw from address 128 onward
    128 => "00000001", 129 => "00000010", 130 => "00000011", 131 => "00000100", -- $s0 = 0x01020304
    132 => "00000101", 133 => "00000110", 134 => "00000111", 135 => "00001000", -- $s1 = 0x05060708
    136 => "00000000", 137 => "00000000", 138 => "00000000", 139 => "00000000", -- Empty space for $s2 result (add)
    140 => "00000000", 141 => "00000000", 142 => "00000000", 143 => "00000000", -- Empty space for $s3 result (sub)
    144 => "00000000", 145 => "00000000", 146 => "00000000", 147 => "00000000", -- Empty space for $s4 result (and)
    148 => "00000000", 149 => "00000000", 150 => "00000000", 151 => "00000000", -- Empty space for $s5 result (or)
    152 => "00000000", 153 => "00000000", 154 => "00000000", 155 => "00000000", -- Empty space for $s6 result (slt)
    others => (others => '0')
);


begin
	-- Write process: stores each byte of the word 
	process(clk,reset)
	begin
		--if reset = '0' then
			--memory <= (others => (others => '0'));
		if (rising_edge(clk) and (mem_write='1')) then
			memory(to_integer(unsigned(address))) 		<= write_data(31 downto 24);
			memory(to_integer(unsigned(address)+1)) 	<= write_data(23 downto 16);
			memory(to_integer(unsigned(address)+2)) 	<= write_data(15 downto 8);
			memory(to_integer(unsigned(address)+3)) 	<= write_data(7 downto 0);
		end if;
	end process;
	-- Read combinational logic 
	
            mem_data <= memory(to_integer(unsigned(address)))     &
                        memory(to_integer(unsigned(address) + 1)) &
                        memory(to_integer(unsigned(address) + 2)) &
                        memory(to_integer(unsigned(address) + 3))when mem_read = '1';
		
	
end architecture ;
	