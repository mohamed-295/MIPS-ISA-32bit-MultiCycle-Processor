library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftleft2_32_tb is
end shiftleft2_32_tb;

architecture sim of shiftleft2_32_tb is

  signal input_tb  : std_logic_vector(31 downto 0);
  signal output_tb : std_logic_vector(31 downto 0);	
  begin
  xoxo: entity shiftleft2_32 port map (
      input  => input_tb,
      output => output_tb
    );

  process
  begin
    -- Test 1: All zeros
    input_tb <= (others => '0');
    wait for 10 ns;

    -- Test 2: All ones
    input_tb <= (others => '1');
    wait for 10 ns;

    -- Test 3: Alternating bits
    input_tb <= "10101010101010101010101010101010";
    wait for 10 ns;

    -- Test 4: MSB = 1, rest zero
    input_tb <= "10000000000000000000000000000000";
    wait for 10 ns;

    -- Test 5: LSB = 1, rest zero
    input_tb <= "00000000000000000000000000000001";
    wait for 10 ns;
    wait;
  end process;

end sim;