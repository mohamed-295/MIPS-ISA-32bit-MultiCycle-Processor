LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ALUControl_tb IS
END ALUControl_tb;

ARCHITECTURE sim OF ALUControl_tb IS

    -- Component Declaration
    COMPONENT ALUControl
        PORT (
            instruc_15to0 : IN std_ulogic_vector(15 DOWNTO 0);
            ALUOp         : IN std_ulogic_vector(1 DOWNTO 0);
            ALUopcode     : OUT std_ulogic_vector(2 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for connection
    SIGNAL instruc_15to0 : std_ulogic_vector(15 DOWNTO 0);
    SIGNAL ALUOp         : std_ulogic_vector(1 DOWNTO 0);
    SIGNAL ALUopcode     : std_ulogic_vector(2 DOWNTO 0);

BEGIN

    uut: ALUControl
        PORT MAP (
            instruc_15to0 => instruc_15to0,
            ALUOp         => ALUOp,
            ALUopcode     => ALUopcode
        );

    stim_proc: PROCESS
    BEGIN

        -- Test ALUOp = "00"(add)
        ALUOp <= "00";
        instruc_15to0 <= (others => '0');
        WAIT FOR 10 ns;

        -- Test ALUOp = "01"(subtract)
        ALUOp <= "01";
        instruc_15to0 <= (others => '0'); 
        WAIT FOR 10 ns;

        -- Test ALUOp = "10" (R-type), with funct = ADD (100000)
        ALUOp <= "10";
        instruc_15to0 <= x"0020";
        WAIT FOR 10 ns;

        -- Test R-type SUB (100010)
        instruc_15to0 <= x"0022";
        WAIT FOR 10 ns;

        -- Test R-type AND (100100)
        instruc_15to0 <= x"0024";
        WAIT FOR 10 ns;

        -- Test R-type OR (100101)
        instruc_15to0 <= x"0025";
        WAIT FOR 10 ns;

        -- Test R-type SLT (101010)
        instruc_15to0 <= x"002A";
        WAIT FOR 10 ns;

        -- Test unknown function code
        instruc_15to0 <= x"0033"; 
        WAIT FOR 10 ns;

        -- Test unknown ALUOp
        ALUOp <= "11";
        instruc_15to0 <= x"0000";
        WAIT FOR 10 ns;
		
        WAIT;
    END PROCESS;

END;
