library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX2 is
	generic  (n: integer := 32);
	port(
	input_1 : in std_logic_vector(n-1 downto 0);
	input_2 : in std_logic_vector(n-1 downto 0);
	mux_sel : in std_logic;
	output : out std_logic_vector(n-1 downto 0)
	);
end MUX2;

architecture behavior of MUX2 is
begin
	output <= input_2 when mux_sel = '1' else input_1;
end behavior;