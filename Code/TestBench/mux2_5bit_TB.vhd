library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX2_5_tb is
end MUX2_5_tb;

architecture sim of MUX2_5_tb is

  -- Test signals
  signal input_1_tb : std_logic_vector(4 downto 0);
  signal input_2_tb : std_logic_vector(4 downto 0);
  signal mux_sel_tb : std_logic;
  signal output_tb  : std_logic_vector(4 downto 0);

begin

  xoxo: entity MUX2_5
    port map (
      input_1 => input_1_tb,
      input_2 => input_2_tb,
      mux_sel => mux_sel_tb,
      output  => output_tb
    );

 process
  begin
    -- Initialize inputs
    input_1_tb <= "00001";
    input_2_tb <= "11110";

    -- Test case 1: Select input_1
    mux_sel_tb <= '0';
    wait for 10 ns;

    -- Test case 2: Select input_2
    mux_sel_tb <= '1';
    wait for 10 ns;

    -- Edge case: Change inputs while selecting input_2
    input_1_tb <= "10101";
    input_2_tb <= "01010";
    wait for 10 ns;

    mux_sel_tb <= '0';
    wait for 10 ns;

    wait;
  end process;

end sim;
