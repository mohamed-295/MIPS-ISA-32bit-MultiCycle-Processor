library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU_tb is
end ALU_tb;

architecture sim of ALU_tb is
    -- Testbench Signals
    signal A, B        : STD_LOGIC_VECTOR(31 downto 0);
    signal ALUControl  : STD_LOGIC_VECTOR(2 downto 0);
    signal Result      : STD_LOGIC_VECTOR(31 downto 0);
    signal Zero        : STD_LOGIC;

begin
    xoxo: entity alu 
		port map (
        A => A,
        B => B,
        ALUControl => ALUControl,
        Result => Result,
        Zero => Zero
    );

    process
    begin
        -- Test ADD
        A <= X"0000000A"; B <= X"00000005"; ALUControl <= "010";
        wait for 10 ns;

        -- Test SUB
        A <= X"0000000A"; B <= X"00000005"; ALUControl <= "110";
        wait for 10 ns;

        -- Test AND
        A <= X"FFFFFFFF"; B <= X"0000FFFF"; ALUControl <= "000";
        wait for 10 ns;

        -- Test OR
        A <= X"0000F0F0"; B <= X"00FF00FF"; ALUControl <= "001";
        wait for 10 ns;

        -- Test SLT where A < B
        A <= X"00000001"; B <= X"00000005"; ALUControl <= "111";
        wait for 10 ns;

        -- Test SLT where A > B
        A <= X"00000009"; B <= X"00000005"; ALUControl <= "111";
        wait for 10 ns;
		
		-- Test Zero flag
        A <= X"00000002"; B <= X"00000002"; ALUControl <= "110"; -- A - B = 0
        wait for 10 ns;
		
        wait;
    end process;

end sim;
