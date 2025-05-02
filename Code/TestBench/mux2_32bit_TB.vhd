library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX2_32_tb is
end MUX2_32_tb;

architecture sim of MUX2_32_tb is

  -- Test signals
  signal input_1_tb : std_logic_vector(31 downto 0);
  signal input_2_tb : std_logic_vector(31 downto 0);
  signal mux_sel_tb : std_logic;
  signal output_tb  : std_logic_vector(31 downto 0);

begin

  xoxo: entity MUX2_32
    port map (
      input_1 => input_1_tb,
      input_2 => input_2_tb,
      mux_sel => mux_sel_tb,
      output  => output_tb
    );
process
  begin
    -- Test 1: Select input_1
    input_1_tb <= X"AAAAAAAA";
    input_2_tb <= X"55555555";
    mux_sel_tb <= '0';
    wait for 10 ns;

    -- Test 2: Select input_2
    mux_sel_tb <= '1';
    wait for 10 ns;

    -- Test 3: Both inputs change
    input_1_tb <= X"12345678";
    input_2_tb <= X"87654321";
    mux_sel_tb <= '0';
    wait for 10 ns;

    mux_sel_tb <= '1';
    wait for 10 ns;

    wait;
  end process;

end sim;
