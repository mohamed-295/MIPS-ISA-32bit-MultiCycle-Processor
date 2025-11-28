library ieee;
use ieee.std_logic_1164.all;

entity Instruction_register is
    Port ( 	clk 		: in std_logic;
			reset		: in std_logic;
			ir_write	: in std_logic;
			ir_in 		: in std_logic_vector(31 downto 0);
			
			ir_out	   	: out std_logic_vector(31 downto 0));
end entity ;

architecture behavioral of Instruction_register is
	signal ir : std_logic_vector (31 downto 0);
begin
	
	process(clk,reset)
	begin
		if reset = '0' then
			ir<= (others =>'0');
		elsif (rising_edge(clk) and (ir_write='1')) then
			ir <= ir_in;
		end if;
	end process;
	ir_out <=ir;
end architecture ;
	