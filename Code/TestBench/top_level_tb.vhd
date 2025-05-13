library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is
end entity;

architecture testbench of top_level_tb is

    -- Component under test
    component top_level is
        port (
            clk   : in std_logic;
            reset : in std_logic
        );
    end component;

    -- Testbench signals
    signal clk_tb   : std_logic := '0';
    signal reset_tb : std_logic := '1';

    -- Clock period
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the processor
    uut: top_level
        port map (
            clk   => clk_tb,
            reset => reset_tb
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk_tb <= '1';
            wait for clk_period / 2;
            clk_tb <= '0';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Reset and test process
    stim_proc : process
    begin
       -- -- Initial reset
        reset_tb <= '0';
        wait for 20 ns;
        reset_tb <= '1';

        -- Run simulation
        wait for 2500 ns;

        -- Optionally stop the simulation
        assert false report "Simulation completed" severity failure;
    end process;

end architecture;
