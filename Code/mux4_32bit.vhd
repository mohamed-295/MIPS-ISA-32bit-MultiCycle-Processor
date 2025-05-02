library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX4_32 is
	port(
	input_1 : in std_logic_vector(31 downto 0);
	input_2 : in std_logic_vector(31 downto 0);
	input_3 : in std_logic_vector(31 downto 0);
	input_4 : in std_logic_vector(31 downto 0);
	mux_sel : in std_logic_vector(1 downto 0);
	output : out std_logic_vector(31 downto 0)
	);
end MUX4_32;

architecture behavior of MUX4_32 is
begin
	with mux_sel select
	output <= input_1 when "00",
	          input_2 when "01",
	          input_3 when "10",
	          input_4 when others;
end behavior;