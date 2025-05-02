library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX3_32_tb is
end MUX3_32_tb;

architecture sim of MUX3_32_tb is

  -- Test signals
  signal input_1_tb : std_logic_vector(31 downto 0);
  signal input_2_tb : std_logic_vector(31 downto 0);
  signal input_3_tb : std_logic_vector(31 downto 0);
  signal mux_sel_tb : std_logic_vector(1 downto 0);
  signal output_tb  : std_logic_vector(31 downto 0);

begin

  xoxo: entity MUX3_32
    port map (
      input_1 => input_1_tb,
      input_2 => input_2_tb,
      input_3 => input_3_tb,
      mux_sel => mux_sel_tb,
      output  => output_tb
    );
process
  begin

    input_1_tb <= X"AAAAAAAA";
    input_2_tb <= X"55555555";
    input_3_tb <= X"FFFFFFFF";

    -- Select input_1
    mux_sel_tb <= "00";
    wait for 10 ns;

    -- Select input_2
    mux_sel_tb <= "01";
    wait for 10 ns;

    -- Select input_3
    mux_sel_tb <= "10";
    wait for 10 ns;

    -- Invalid selector (should output all 0s)
    mux_sel_tb <= "11";
    wait for 10 ns;

    wait;
  end process;

end sim;
