library ieee;
use ieee.std_logic_1164.all;

entity register_a is 
	port (	clk		: in std_logic;
			reset 	: in std_logic;
			data_in	: in std_logic_vector(31 downto 0);
			data_out: out std_logic_vector(31 downto 0));
end entity ;


architecture behavioral	of register_a is

	signal reg_a : std_logic_vector(31 downto 0); 

begin 
	
	process(clk)
	begin
		if reset='1' then
			reg_a <= (others =>'0');
		elsif rising_edge(clk) then
            reg_a <= data_in;
        end if;
    end process;
    data_out <= reg_a;
	
end architecture ;
