library ieee;
use ieee.std_logic_1164.all;

entity MDR_tb is
end entity;

architecture behavior of MDR_tb is

    -- Signals to connect to MDR
    signal clk_tb      : std_logic := '0';
    signal reset_tb    : std_logic := '0';
    signal MDR_in_tb   : std_logic_vector(31 downto 0) := (others => '0');
    signal MDR_out_tb  : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- Instantiate the MDR
    DUT: entity MDR
        port map (
            clk      => clk_tb,
            reset    => reset_tb,
            MDR_in   => MDR_in_tb,
            MDR_out  => MDR_out_tb
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
        -- Wait for system to stabilize
        wait for 20 ns;

        -- Apply reset
        reset_tb <= '0';
        wait for clk_period;
        reset_tb <= '1';

        -- Apply input value and check after clock edge
        MDR_in_tb <= x"DEADBEEF";
        wait for clk_period;

        assert MDR_out_tb = x"DEADBEEF"
        report "Error: MDR output mismatch after writing DEADBEEF"
        severity error;

        -- Apply another value
        MDR_in_tb <= x"12345678";
        wait for clk_period;

        assert MDR_out_tb = x"12345678"
        report "Error: MDR output mismatch after writing 12345678"
        severity error;

        -- Apply reset again
        reset_tb <= '0';
        wait for clk_period;
        reset_tb <= '1';

        assert MDR_out_tb = x"00000000"
        report "Error: MDR not cleared after reset"
        severity error;

        report "Simulation completed successfully. All tests passed." severity note;
        wait;
    end process;

end architecture;
