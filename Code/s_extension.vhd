library ieee;
use ieee.std_logic_1164.all;
entity sign_ext is
	port (
	sign_input : in std_logic_vector(15 downto 0);
	sign_output : out std_logic_vector(31 downto 0)
	);
end sign_ext;

architecture behavior of sign_ext is 
begin
sign_output <= (X"FFFF" & sign_input) when sign_input(15) = '1' else (X"0000" & sign_input);
end behavior;
	