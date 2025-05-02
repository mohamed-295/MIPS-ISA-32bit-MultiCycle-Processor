library ieee;
use ieee.std_logic_1164.all;

entity ProgramCounter is
	port ( 	clk 	: in std_logic;
			en  	: in std_logic;
		 	reset 	: in std_logic;
			input 	: in std_logic_vector(31 downto 0);
			output 	: out std_logic_vector(31 downto 0)); 
end entity ;

architecture behavioral of ProgramCounter is 

begin
	
	process(clk)
	begin
		if reset = '0' then
			output <= (others =>'0');
		elsif (rising_edge(clk) and (en = '1'))then
			output <= input;
		end if;
	end process; 
	
end architecture ;
	
		