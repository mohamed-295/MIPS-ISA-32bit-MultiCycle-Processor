library ieee;
use ieee.std_logic_1164.all;

entity TestBench is  
end entity TestBench;

architecture sim of TestBench is
  signal clk   : std_logic :='0';
  signal reset : std_logic :='1';
  constant clk_period : time := 10 ns;
  

  component Top_Level is  
    port (
      clk   : in std_logic;
      reset : in std_logic
    );
  end component;
  
begin

  UUT: Top_Level  
    port map (
      clk   => clk,
      reset => reset
    );


  
  clock_process : process
  begin
    while true loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
  end process;	 
  
  -- Reset logic
  reset_process : process
  begin
     reset <= '1';
        wait for 40 ns;
        reset <= '0';

        wait for 2000 ns;
        wait;
  end process;


end sim;
