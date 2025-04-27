library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register_file is
	port (	clk		: in std_logic;
			reset	: in std_logic;
	
			write_reg	: in std_logic_vector(4 downto 0);
			address_1	: in std_logic_vector(4 downto 0);
			address_2 	: in std_logic_vector(4 downto 0);
			
			reg_write  	: in std_logic;
			write_data 	: in std_logic_vector(31 downto 0);
			
			reg1_data 	: out std_logic_vector(31 downto 0);
			reg2_data 	: out std_logic_vector(31 downto 0));
end entity ;

architecture behavioral of Register_file is
type reg_array is array (0 to 31 ) of std_logic_vector(31 downto 0);
signal reg : reg_array := (others => (others => '0'));


begin 
	process(clk)
	begin
		if reset = '1' then 
			reg <= (others => (others => '0'));
		elsif rising_edge(clk) then
			if reg_write ='1' and write_reg /= "00000" then	 --prevent writing at register 0
			reg(to_integer(unsigned(write_reg))) <= write_data;
			end if;
		end if;
	end process;
	
	reg1_data <=  reg(to_integer(unsigned(address_1)));
	reg2_data <=  reg(to_integer(unsigned(address_2)));
		
end architecture ;
  