
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_ControlUnit IS
END tb_ControlUnit;

ARCHITECTURE sim OF tb_ControlUnit IS

    -- Component Declaration
    COMPONENT ControlUnit
        PORT(
            clk, rst, zero: IN std_logic;
            opcode: IN std_logic_vector (5 downto 0);    
            instruc_15to0: IN std_logic_vector (15 downto 0);
            ALUopcode: OUT std_logic_vector (2 downto 0);
            IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst: OUT std_logic;
            PCSource, ALUSrcB: OUT std_logic_vector (1 downto 0);  
            PC_enable: OUT std_logic
        );
    END COMPONENT;

    -- Signals to connect to the Unit Under Test (UUT)
    SIGNAL clk_tb     : std_logic := '0';
    SIGNAL rst_tb     : std_logic := '1';
    SIGNAL zero_tb    : std_logic := '0';
    SIGNAL opcode_tb  : std_logic_vector(5 downto 0) := (others => '0');
    SIGNAL instr_tb   : std_logic_vector(15 downto 0) := (others => '0');

    SIGNAL ALUopcode_tb       : std_logic_vector(2 downto 0);
    SIGNAL IorD_tb            : std_logic;
    SIGNAL MemRead_tb         : std_logic;
    SIGNAL MemWrite_tb        : std_logic;
    SIGNAL MemtoReg_tb        : std_logic;
    SIGNAL IRWrite_tb         : std_logic;
    SIGNAL ALUSrcA_tb         : std_logic;
    SIGNAL RegWrite_tb        : std_logic;
    SIGNAL RegDst_tb          : std_logic;
    SIGNAL PCSource_tb        : std_logic_vector(1 downto 0);
    SIGNAL ALUSrcB_tb         : std_logic_vector(1 downto 0);
    SIGNAL PC_enable_tb       : std_logic;	   
	CONSTANT clk_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: ControlUnit
        PORT MAP (
            clk => clk_tb,
            rst => rst_tb,
            zero => zero_tb,
            opcode => opcode_tb,
            instruc_15to0 => instr_tb,
            ALUopcode => ALUopcode_tb,
            IorD => IorD_tb,
            MemRead => MemRead_tb,
            MemWrite => MemWrite_tb,
            MemtoReg => MemtoReg_tb,
            IRWrite => IRWrite_tb,
            ALUSrcA => ALUSrcA_tb,
            RegWrite => RegWrite_tb,
            RegDst => RegDst_tb,
            PCSource => PCSource_tb,
            ALUSrcB => ALUSrcB_tb,
            PC_enable => PC_enable_tb
        );

    -- Clock process
    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            clk_tb <= '0';
            WAIT FOR clk_period / 2;
            clk_tb <= '1';
            WAIT FOR clk_period / 2;
        END LOOP;
    END PROCESS;

    -- Stimulus process
    stim_proc: process
    begin
        -- Apply reset
        rst_tb <= '0';
        WAIT FOR clk_period * 2;
        rst_tb <= '1';

        -- Test LOADWORD
        opcode_tb <= "100011"; -- lw 
		zero_tb <= '0';
        WAIT FOR clk_period * 6;

        -- Test STOREWORD
        opcode_tb <= "101011"; -- sw 
		instr_tb <= x"0000"; --dummy value
		zero_tb <= '0';
        WAIT FOR clk_period * 6;

        -- Test RTYPE (R-format)
        opcode_tb <= "000000";	   
        instr_tb <= x"0020";
		zero_tb <= '0';
        WAIT FOR clk_period * 5;

        -- Test BEQ
        opcode_tb <= "000100"; 
		instr_tb <= x"0000"; --dummy value
		zero_tb <= '1';
        WAIT FOR clk_period * 4;

        -- Test JUMP
        opcode_tb <= "000010"; 
		instr_tb <= x"0000"; --dummy value
		zero_tb <= '0';
        WAIT FOR clk_period * 3;
		
        WAIT FOR clk_period * 5;
    end process;

END architecture;
