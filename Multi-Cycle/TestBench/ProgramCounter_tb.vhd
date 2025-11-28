library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ProgramCounter_tb is
end entity;

architecture behavior of ProgramCounter_tb is

    -- Signals to connect to DUT
    signal clk_tb    : std_logic := '0';
    signal en_tb     : std_logic := '0';
    signal reset_tb  : std_logic := '0';
    signal input_tb  : std_logic_vector(31 downto 0) := (others => '0');
    signal output_tb : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- Direct entity instantiation
    DUT: entity ProgramCounter
        port map (
            clk    => clk_tb,
            en     => en_tb,
            reset  => reset_tb,
            input  => input_tb,
            output => output_tb
        );

    -- Clock generation process
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
        -- Initial reset
        wait for 20 ns;
        reset_tb <= '0';
        wait for clk_period;
        reset_tb <= '1';

        -- Enable write, input 1
        en_tb <= '1';
        input_tb <= x"12345678";
        wait for clk_period;

        -- Enable write, input 2
        input_tb <= x"87654321";
        wait for clk_period;

        -- Disable write
        en_tb <= '0';
        input_tb <= x"FFFFFFFF"; -- Should not affect output
        wait for clk_period;

        -- Apply reset again
        reset_tb <= '0';
        wait for clk_period;
        reset_tb <= '1';

        wait;
    end process;

end architecture;
