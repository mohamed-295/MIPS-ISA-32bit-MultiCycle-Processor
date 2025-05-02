library ieee;
use ieee.std_logic_1164.all;

entity sign_ext_tb is
end sign_ext_tb;

architecture sim of sign_ext_tb is
  -- Testbench signals
  signal sign_input_tb  : std_logic_vector(15 downto 0);
  signal sign_output_tb : std_logic_vector(31 downto 0);

begin

  xoxo: entity sign_ext
    port map (
      sign_input  => sign_input_tb,
      sign_output => sign_output_tb
    );
	
  process
  begin
    -- Test 1: Positive number (MSB = 0)
    sign_input_tb <= "0000000000001010";  -- 0x000A
    wait for 10 ns;

    -- Test 2: Negative number (MSB = 1)
    sign_input_tb <= "1000000000001010";  -- 0x800A
    wait for 10 ns;

    -- Test 3: All zeros
    sign_input_tb <= "0000000000000000";  -- 0x0000
    wait for 10 ns;

    -- Test 4: All ones
    sign_input_tb <= "1111111111111111";  -- 0xFFFF
    wait for 10 ns;

    -- Test 5: Only MSB is 1
    sign_input_tb <= "1000000000000000";  -- 0x8000
    wait for 10 ns;

    -- Test 6: Only LSB is 1
    sign_input_tb <= "0000000000000001";  -- 0x0001
    wait for 10 ns;

    wait;
  end process;

end sim;
