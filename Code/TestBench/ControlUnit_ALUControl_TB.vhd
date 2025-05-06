LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ALUControl_tb IS
END ALUControl_tb;

ARCHITECTURE sim OF ALUControl_tb IS

    COMPONENT ALUControl
        PORT (
            instruc_15to0 : IN std_logic_vector(15 DOWNTO 0);
            ALUOp         : IN std_logic_vector(1 DOWNTO 0);
            ALUopcode     : OUT std_logic_vector(2 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL instruc_15to0 : std_logic_vector(15 DOWNTO 0);
    SIGNAL ALUOp         : std_logic_vector(1 DOWNTO 0);
    SIGNAL ALUopcode     : std_logic_vector(2 DOWNTO 0);

BEGIN

    uut: ALUControl
        PORT MAP (
            instruc_15to0 => instruc_15to0,
            ALUOp         => ALUOp,
            ALUopcode     => ALUopcode
        );

    stim_proc: PROCESS
    BEGIN
        -- Test ALUOp = "00" (add)
        ALUOp <= "00";
        instruc_15to0 <= (others => '0');
        WAIT FOR 10 ns;
        assert ALUopcode = "010" report "FAIL: ALUOp=00 should produce ADD (010)" severity error;

        -- Test ALUOp = "01" (subtract)
        ALUOp <= "01";
        instruc_15to0 <= (others => '0');
        WAIT FOR 10 ns;
        assert ALUopcode = "110" report "FAIL: ALUOp=01 should produce SUB (110)" severity error;

        -- Test ALUOp = "10" (R-type ADD)
        ALUOp <= "10";
        instruc_15to0 <= x"0020";
        WAIT FOR 10 ns;
        assert ALUopcode = "010" report "FAIL: R-type ADD (100000) should produce (010)" severity error;

        -- R-type SUB (100010)
        instruc_15to0 <= x"0022";
        WAIT FOR 10 ns;
        assert ALUopcode = "110" report "FAIL: R-type SUB (100010) should produce (110)" severity error;

        -- R-type AND (100100)
        instruc_15to0 <= x"0024";
        WAIT FOR 10 ns;
        assert ALUopcode = "000" report "FAIL: R-type AND (100100) should produce (000)" severity error;

        -- R-type OR (100101)
        instruc_15to0 <= x"0025";
        WAIT FOR 10 ns;
        assert ALUopcode = "001" report "FAIL: R-type OR (100101) should produce (001)" severity error;

        -- R-type SLT (101010)
        instruc_15to0 <= x"002A";
        WAIT FOR 10 ns;
        assert ALUopcode = "111" report "FAIL: R-type SLT (101010) should produce (111)" severity error;

        -- Unknown R-type function (0x0033)
        instruc_15to0 <= x"0033";
        WAIT FOR 10 ns;
        assert ALUopcode = "000" report "FAIL: Unknown R-type funct should default to (000)" severity error;

        -- Unknown ALUOp ("11")
        ALUOp <= "11";
        instruc_15to0 <= x"0000";
        WAIT FOR 10 ns;
        assert ALUopcode = "000" report "FAIL: Unknown ALUOp should default to (000)" severity error;

        report "All test cases completed.." severity note;
        WAIT;
    END PROCESS;

END sim;
