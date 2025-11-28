library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register_file_tb is
end entity;

architecture behavior of Register_file_tb is

    -- Signals to connect to DUT
    signal clk_tb         : std_logic := '0';
    signal reset_tb       : std_logic := '0';
    signal write_reg_tb   : std_logic_vector(4 downto 0) := (others => '0');
    signal address_1_tb   : std_logic_vector(4 downto 0) := (others => '0');
    signal address_2_tb   : std_logic_vector(4 downto 0) := (others => '0');
    signal reg_write_tb   : std_logic := '0';
    signal write_data_tb  : std_logic_vector(31 downto 0) := (others => '0');
    signal reg1_data_tb   : std_logic_vector(31 downto 0);
    signal reg2_data_tb   : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- DUT instantiation
    DUT: entity Register_file
        port map (
            clk        => clk_tb,
            reset      => reset_tb,
            write_reg  => write_reg_tb,
            address_1  => address_1_tb,
            address_2  => address_2_tb,
            reg_write  => reg_write_tb,
            write_data => write_data_tb,
            reg1_data  => reg1_data_tb,
            reg2_data  => reg2_data_tb
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

        -- Reset
        reset_tb <= '0';
        write_reg_tb <= "00001";
        wait for clk_period;
        reset_tb <= '1';

        -- Write 0xAAAA5555 into register 1
        write_reg_tb <= "00001";
        write_data_tb <= x"AAAA5555";
        reg_write_tb <= '1';
        wait for clk_period;

        -- Stop writing
        reg_write_tb <= '0';
        write_data_tb <= x"FFFFFFFF";

        -- Read from register 1 -> reg1_data
        address_1_tb <= "00001";
        wait for clk_period;

        assert reg1_data_tb = x"AAAA5555"
        report " Error: Register 1 read incorrect"
        severity error;

        -- Write 0x12345678 into register 2
        write_reg_tb <= "00010";
        write_data_tb <= x"12345678";
        reg_write_tb <= '1';
        wait for clk_period;
        reg_write_tb <= '0';

        -- Read from register 2 -> reg2_data
        address_2_tb <= "00010";
        wait for clk_period;

        assert reg2_data_tb = x"12345678"
        report " Error: Register 2 read incorrect"
        severity error;
		
		
		-- Attempt to write 0xFFFFFFFF into register 0
        write_reg_tb <= "00000";      -- Address 0
        write_data_tb <= x"FFFFFFFF"; -- Data to write
        reg_write_tb <= '1';
        wait for clk_period;
        reg_write_tb <= '0';

        -- Read back from register 0 -> reg1_data
        address_1_tb <= "00000";
        wait for clk_period;

        assert reg1_data_tb = x"00000000"
        report "Error: Register 0 was modified! It should always be zero."
        severity error;

        -- Final note
        report " Simulation completed successfully. All tests passed." severity note;

        wait;
    end process;

end architecture;
