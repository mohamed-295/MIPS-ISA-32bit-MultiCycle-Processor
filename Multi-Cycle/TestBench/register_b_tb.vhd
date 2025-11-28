library ieee;
use ieee.std_logic_1164.all;

entity register_b_tb is
end entity;

architecture behavior of register_b_tb is

	signal clk_tb      : std_logic := '0';
	signal reset_tb    : std_logic := '0';
    signal data_in_tb  : std_logic_vector(31 downto 0) := (others => '0');
    signal data_out_tb : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

begin

    DUT: entity register_b
        port map (
			clk      => clk_tb,
			reset	 => reset_tb,
            data_in  => data_in_tb,
            data_out => data_out_tb
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
        wait for 20 ns;
		
		data_in_tb <= x"AAAA5555";
		reset_tb <='0';
        wait for clk_period;
		reset_tb <='1';
		
		assert data_out_tb = x"00000000"
        report "Error: Output mismatch after writing 00000000"
        severity error;
		
        data_in_tb <= x"AAAA5555";
        wait for clk_period;

        assert data_out_tb = x"AAAA5555"
        report "Error: Output mismatch after writing AAAA5555"
        severity error;

        data_in_tb <= x"12345678";
        wait for clk_period;

        assert data_out_tb = x"12345678"
        report "Error: Output mismatch after writing 12345678"
        severity error;

        report "register_b_tb completed successfully." severity note;
        wait;
    end process;

end architecture;
