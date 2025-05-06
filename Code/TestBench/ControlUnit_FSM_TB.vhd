LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ControlFSM_tb IS
END ENTITY;

ARCHITECTURE sim OF ControlFSM_tb IS

-- Component Declaration
COMPONENT ControlFSM IS
    PORT(
        clk, rst: IN std_logic;
        opcode: IN std_logic_vector (5 downto 0);	
        PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst: OUT std_logic;
        PCSource, ALUSrcB, ALUOp: OUT std_logic_vector (1 downto 0)
    );
END COMPONENT;

-- Testbench signals
SIGNAL clk, rst: std_logic := '0';
SIGNAL opcode: std_logic_vector(5 DOWNTO 0);
								   
-- Control signals
SIGNAL PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst: std_logic;
SIGNAL PCSource, ALUSrcB, ALUOp: std_logic_vector (1 downto 0);

SIGNAL all_ctrl : std_logic_vector(15 DOWNTO 0);

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
    
    ----------------------------------------------------------------------------
    -- Test LOADWORD ("100011")
    ----------------------------------------------------------------------------
    opcode <= "100011";

    WAIT FOR clk_period; -- InstructionDecode
    assert all_ctrl = "0000000000001100" report "LOADWORD: InstructionDecode failed" severity error;

    WAIT FOR clk_period; -- MemAddressComputation
    assert all_ctrl = "0000000100001000" report "LOADWORD: MemAddressComputation failed" severity error;

    WAIT FOR clk_period; -- MemAccessLoad
    assert all_ctrl = "0011000100001000" report "LOADWORD: MemAccessLoad failed" severity error;

    WAIT FOR clk_period; -- MemReadCompletion
    assert all_ctrl = "0000010110001000" report "LOADWORD: MemReadCompletion failed" severity error;

    WAIT FOR clk_period; -- InstructionFetch
    assert all_ctrl = "0101001000000100" report "LOADWORD: Return to InstructionFetch failed" severity error;

    ----------------------------------------------------------------------------
    -- Test STOREWORD ("101011")
    ----------------------------------------------------------------------------
    opcode <= "101011";

    WAIT FOR clk_period;
    assert all_ctrl = "0000000000001100" report "STOREWORD: InstructionDecode failed" severity error;

    WAIT FOR clk_period;
    assert all_ctrl = "0000000100001000" report "STOREWORD: MemAddressComputation failed" severity error;

    WAIT FOR clk_period;
    assert all_ctrl = "0010100100001000" report "STOREWORD: MemAccessStore failed" severity error;

    WAIT FOR clk_period;
    assert all_ctrl = "0101001000000100" report "STOREWORD: Return to InstructionFetch failed" severity error;

    ----------------------------------------------------------------------------
    -- Test RTYPE ("000000")
    ----------------------------------------------------------------------------
    opcode <= "000000";

    WAIT FOR clk_period;
    assert all_ctrl = "0000000000001100" report "RTYPE: InstructionDecode failed" severity error;

    WAIT FOR clk_period;
    assert all_ctrl = "0000000100000010" report "RTYPE: Execute_R failed" severity error;

    WAIT FOR clk_period;
    assert all_ctrl = "0000000111000010" report "RTYPE: R_Completion failed" severity error;

    WAIT FOR clk_period;
    assert all_ctrl = "0101001000000100" report "RTYPE: Return to InstructionFetch failed" severity error;

    ----------------------------------------------------------------------------
    -- Test BEQ ("000100")
    ----------------------------------------------------------------------------
    opcode <= "000100";

    WAIT FOR clk_period;
    assert all_ctrl = "0000000000001100" report "BEQ: InstructionDecode failed" severity error;

    WAIT FOR clk_period;
    assert all_ctrl = "1000000100010001" report "BEQ: BranchCompletion failed" severity error;

    WAIT FOR clk_period;
    assert all_ctrl = "0101001000000100" report "BEQ: Return to InstructionFetch failed" severity error;

    ----------------------------------------------------------------------------
    -- Test JUMP ("000010")
    ----------------------------------------------------------------------------
    opcode <= "000010";

    WAIT FOR clk_period;
    assert all_ctrl = "0000000000001100" report "JUMP: InstructionDecode failed" severity error;

    WAIT FOR clk_period;
    assert all_ctrl = "0100000000101100" report "JUMP: JumpCompletion failed" severity error;

    WAIT FOR clk_period;
    assert all_ctrl = "0101001000000100" report "JUMP: Return to InstructionFetch failed" severity error;

    WAIT FOR clk_period * 2;
    report "All test cases passed successfully." severity note;
    WAIT;
END PROCESS;


END ARCHITECTURE;
