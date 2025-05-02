LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ControlFSM_tb IS
END ENTITY;

ARCHITECTURE sim OF ControlFSM_tb IS

	-- Component Declaration
    COMPONENT ControlFSM IS
        PORT(
            clk, rst: IN std_ulogic;
            opcode: IN std_ulogic_vector (5 downto 0);	
            PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst: OUT std_ulogic;
            PCSource, ALUSrcB, ALUOp: OUT std_ulogic_vector (1 downto 0)
        );
    END COMPONENT;

    -- Testbench signals
    SIGNAL clk, rst: std_ulogic := '0';
    SIGNAL opcode: std_ulogic_vector(5 DOWNTO 0);
									   
    -- Control signals
    SIGNAL PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst: std_ulogic;
    SIGNAL PCSource, ALUSrcB, ALUOp: std_ulogic_vector (1 downto 0);

    SIGNAL all_ctrl : std_ulogic_vector(15 DOWNTO 0);

    CONSTANT clk_period : time := 10 ns;

BEGIN

    uut: ControlFSM
        PORT MAP (
            clk => clk,
            rst => rst,
            opcode => opcode,
            PCWriteCond => PCWriteCond,
            PCWrite => PCWrite,
            IorD => IorD,
            MemRead => MemRead,
            MemWrite => MemWrite,
            MemtoReg => MemtoReg,
            IRWrite => IRWrite,
            ALUSrcA => ALUSrcA,
            RegWrite => RegWrite,
            RegDst => RegDst,
            PCSource => PCSource,
            ALUSrcB => ALUSrcB,
            ALUOp => ALUOp
        );

    all_ctrl <= PCWriteCond & PCWrite & IorD & MemRead & MemWrite & MemtoReg & IRWrite & ALUSrcA & RegWrite & RegDst
                & PCSource & ALUSrcB & ALUOp;

    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            clk <= '0';
            WAIT FOR clk_period / 2;
            clk <= '1';
            WAIT FOR clk_period / 2;
        END LOOP;
    END PROCESS;

    stim_proc: PROCESS
    BEGIN
        -- Apply reset
        rst <= '0';
        WAIT FOR clk_period * 2;
        rst <= '1';

        -- Test LOADWORD
        opcode <= "100011"; -- lw
        WAIT FOR clk_period * 6;

        -- Test STOREWORD
        opcode <= "101011"; -- sw
        WAIT FOR clk_period * 6;

        -- Test RTYPE (R-format)
        opcode <= "000000";
        WAIT FOR clk_period * 5;

        -- Test BEQ
        opcode <= "000100";
        WAIT FOR clk_period * 4;

        -- Test JUMP
        opcode <= "000010";
        WAIT FOR clk_period * 3;
		
        WAIT FOR clk_period * 5;   
    END PROCESS;

END ARCHITECTURE;
