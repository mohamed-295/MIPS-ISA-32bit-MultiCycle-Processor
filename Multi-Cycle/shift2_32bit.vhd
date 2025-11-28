library IEEE; use IEEE.STD_LOGIC_1164.all;
entity shiftleft2_32 is
port(
input: in STD_LOGIC_VECTOR(31 downto 0);
output: out STD_LOGIC_VECTOR(31 downto 0));
end shiftleft2_32;
architecture behavior of shiftleft2_32 is
begin
output <= input(29 downto 0) & "00";
end behavior;