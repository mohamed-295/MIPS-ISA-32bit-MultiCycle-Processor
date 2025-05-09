library ieee;
use ieee.std_logic_1164.all;

entity MDR is
	port ( 	clk 	: in	std_logic;
			reset 	: in	std_logic;
			MDR_in	: in 	std_logic_vector(31 downto 0);
			MDR_out : out 	std_logic_vector(31 downto 0));
end entity ;

architecture behavioral of MDR is

signal mem_data : std_logic_vector (31 downto 0);

begin
	
	process (clk,MDR_in)
		begin
			if reset = '0' then
				mem_data <= (others => '0');
			elsif rising_edge(clk) then
				mem_data <= MDR_in;
			end if;

		end process;
	MDR_out <= mem_data;
end architecture ;
	
				
		