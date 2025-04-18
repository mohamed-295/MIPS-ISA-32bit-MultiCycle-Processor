library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory_tb is
end entity;

architecture behavior of Memory_tb is

    -- Signals for DUT
    signal clk_tb        : std_logic := '0';
    signal reset_tb      : std_logic := '0';
    signal mem_write_tb  : std_logic := '0';
    signal mem_read_tb   : std_logic := '0';
    signal address_tb    : std_logic_vector(31 downto 0) := (others => '0');
    signal write_data_tb : std_logic_vector(31 downto 0) := (others => '0');
    signal mem_data_tb   : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- DUT instantiation
    DUT: entity Memory
        port map (
            clk        => clk_tb,
            reset      => reset_tb,
            mem_write  => mem_write_tb,
            mem_read   => mem_read_tb,
            address    => address_tb,
            write_data => write_data_tb,
            mem_data   => mem_data_tb
        );

    -- Clock process
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

    -- Apply reset
    reset_tb <= '1';
    wait for clk_period;
    reset_tb <= '0';

    -- Write value to address 0
    address_tb <= x"00000000";
    write_data_tb <= x"DEADBEEF";
    mem_write_tb <= '1';
    wait for clk_period;

    -- Stop writing
    mem_write_tb <= '0';
    write_data_tb <= x"FFFFFFFF"; -- Should not be written
    wait for clk_period;

    -- Read back from address 0
    mem_read_tb <= '1';
    wait for clk_period;
    mem_read_tb <= '0';

    -- Check the read value from address 0
    assert mem_data_tb = x"DEADBEEF"
    report "? Error: Read from address 0x00000000 failed. Expected: DEADBEEF"
    severity error;

    -- Write to a different address
    address_tb <= x"00000004";
    write_data_tb <= x"12345678";
    mem_write_tb <= '1';
    wait for clk_period;
    mem_write_tb <= '0';

    -- Read back the second value
    mem_read_tb <= '1';
    wait for clk_period;
    mem_read_tb <= '0';

    -- Check the read value from address 0x00000004
    assert mem_data_tb = x"12345678"
    report "? Error: Read from address 0x00000004 failed. Expected: 12345678"
    severity error;

    report "? Simulation completed successfully. All tests passed." severity note;

    wait;
end process;


end architecture;
