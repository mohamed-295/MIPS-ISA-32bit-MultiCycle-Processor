library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftleft2_28 is
  port(
        input  : in std_logic_vector(25 downto 0);
        output : out std_logic_vector(27 downto 0) );
end shiftleft2_28;

architecture behavior of shiftleft2_28 is
begin
  output <= input & "00";
end behavior;