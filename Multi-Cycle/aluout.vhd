library ieee;
use ieee.std_logic_1164.all;

entity aluout is 
	port (	clk		: in std_logic;
			reset	: in std_logic;
			data_in	: in std_logic_vector(31 downto 0);
			data_out: out std_logic_vector(31 downto 0));
end entity ;


architecture behavioral	of aluout is

	signal reg_alu : std_logic_vector(31 downto 0); 

begin 
	
	process(clk,reset)
	begin
		if reset='0' then
			reg_alu <= (others =>'0');
		elsif rising_edge(clk) then
            reg_alu <= data_in;
        end if;
    end process;
    data_out <= reg_alu;
	
end architecture ;
