library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX4_32_tb is
end MUX4_32_tb;

architecture sim of MUX4_32_tb is
  -- Test signals
  signal input_1_tb : std_logic_vector(31 downto 0);
  signal input_2_tb : std_logic_vector(31 downto 0);
  signal input_3_tb : std_logic_vector(31 downto 0);
  signal input_4_tb : std_logic_vector(31 downto 0);
  signal mux_sel_tb : std_logic_vector(1 downto 0);
  signal output_tb  : std_logic_vector(31 downto 0);

begin

  xoxo: entity MUX4_32
    port map (
      input_1 => input_1_tb,
      input_2 => input_2_tb,
      input_3 => input_3_tb,
      input_4 => input_4_tb,
      mux_sel => mux_sel_tb,
      output  => output_tb
    );

  process
  begin
    -- Set input values
    input_1_tb <= X"11111111";
    input_2_tb <= X"22222222";
    input_3_tb <= X"33333333";
    input_4_tb <= X"44444444";

    -- Test each select input
    mux_sel_tb <= "00";
    wait for 10 ns;

    mux_sel_tb <= "01";
    wait for 10 ns;

    mux_sel_tb <= "10";
    wait for 10 ns;

    mux_sel_tb <= "11";
    wait for 10 ns;

    wait;
  end process;

end sim;
