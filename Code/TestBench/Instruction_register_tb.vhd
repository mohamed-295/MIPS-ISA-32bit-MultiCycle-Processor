library ieee;
use ieee.std_logic_1164.all;

entity Instruction_register_tb is
end entity;

architecture behavior of Instruction_register_tb is

    -- Signals to connect to DUT
    signal clk_tb       : std_logic := '0';
    signal reset_tb     : std_logic := '0';
    signal ir_write_tb  : std_logic := '0';
    signal ir_in_tb     : std_logic_vector(31 downto 0) := (others => '0');
    signal ir_out_tb    : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- DUT instantiation
    DUT: entity Instruction_register
        port map (
            clk      => clk_tb,
            reset    => reset_tb,
            ir_write => ir_write_tb,
            ir_in    => ir_in_tb,
            ir_out   => ir_out_tb
        );

    -- Clock generation
    clk_process: process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Wait for initial setup
        wait for 20 ns;

        -- Test 1: Apply reset
        reset_tb <= '0';
        wait for clk_period;
        reset_tb <= '1';
        wait for clk_period;

        assert ir_out_tb = x"00000000"
            report "Reset failed: IR not cleared to 0." severity error;

        -- Test 2: Write instruction 1
        ir_in_tb <= x"AAAAAAAA";
        ir_write_tb <= '1';
        wait for clk_period;

        assert ir_out_tb = x"AAAAAAAA"
            report "IR did not capture AAAAAAAA correctly!" severity error;

        -- Test 3: Write instruction 2 (while still writing)
        ir_in_tb <= x"12345678";
        wait for clk_period;

        assert ir_out_tb = x"12345678"
            report "IR did not capture 12345678 correctly!" severity error;

        -- Test 4: Disable write, change input
        ir_write_tb <= '0';
        ir_in_tb <= x"FFFFFFFF";
        wait for clk_period;

        assert ir_out_tb = x"12345678"
            report "IR changed when ir_write was low!" severity error;

        -- Test 5: Apply reset again
        reset_tb <= '0';
        wait for clk_period;
        reset_tb <= '1';
        wait for clk_period;

        assert ir_out_tb = x"00000000"
            report "IR not cleared after second reset!" severity error;
		
		report " Simulation completed successfully. All tests passed." severity note;
        wait;
    end process;

end architecture;
