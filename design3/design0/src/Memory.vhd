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
        -- lw $R0,47($R20)
        0 => "10001110", 1 => "10000000", 2 => "00000000", 3 => "00101111",

        -- addi $R1,$R3,50
        4 => "00100000", 5 => "01100001", 6 => "00000000", 7 => "00110010",

        -- addi $R2,$R3,48
        8 => "00100000", 9 => "01100010", 10 => "00000000", 11 => "00110000",

        -- add $R2,$R2,$R0
        12 => "00000000", 13 => "01000000", 14 => "00010000", 15 => "00100000",

        -- beq $R1,$R2,1
        16 => "00010000", 17 => "00100010", 18 => "00000000", 19 => "00000001",

        -- j 3
        20 => "00001000", 21 => "00000000", 22 => "00000000", 23 => "00000011",

        -- add $R0,$R1,$R2
        24 => "00000000", 25 => "00100010", 26 => "00000000", 27 => "00100000",

        -- lw $R10,47($R20)
        28 => "10001110", 29 => "10001010", 30 => "00000000", 31 => "00101111",

        -- data
        50 => "00000001",

        others => (others => '0')
    );
begin
	-- Write process: stores each byte of the word 
	process(clk,reset)
	begin
		if reset = '1' then
			memory <= (others => (others => '0'));
		elsif (rising_edge(clk) and (mem_write='1')) then
			memory(to_integer(unsigned(address))) 		<= write_data(31 downto 24);
			memory(to_integer(unsigned(address)+1)) 	<= write_data(23 downto 16);
			memory(to_integer(unsigned(address)+2)) 	<= write_data(15 downto 8);
			memory(to_integer(unsigned(address)+3)) 	<= write_data(7 downto 0);
		end if;
	end process;
	-- Read combinational logic 
	process(memory, address, mem_read)
    begin
        if mem_read = '1' then
            mem_data <= memory(to_integer(unsigned(address)))     &
                        memory(to_integer(unsigned(address) + 1)) &
                        memory(to_integer(unsigned(address) + 2)) &
                        memory(to_integer(unsigned(address) + 3));
        
        end if;
    end process;
	
end architecture ;
	