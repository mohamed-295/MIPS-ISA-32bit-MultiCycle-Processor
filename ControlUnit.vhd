LIBRARY IEEE;
use ieee.std_logic_1164.all;

Entity ControlUnit is 
	port( 
	-- inputs
	clk, rst, zero: IN std_logic;
	opcode: IN std_logic_vector (5 downto 0);	
	instruc_15to0: IN std_logic_vector (15 downto 0);
	-- outputs
	ALUopcode: OUT std_logic_vector (2 downto 0);
	IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst: OUT std_logic;
	PCSource, ALUSrcB: OUT std_logic_vector (1 downto 0);  
	PC_enable: OUT std_logic
	);									 
End entity;	 

Architecture Behavioral of ControlUnit is

component ControlFSM 
	port(
	clk, rst: IN std_logic;  
	opcode: IN std_logic_vector (5 downto 0);
	PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst: Out std_logic;
	PCSource, ALUSrcB, ALUOp: out std_logic_vector (1 downto 0)
	);
End component;

component ALUControl 
	port(
	instruc_15to0: IN std_logic_vector (15 downto 0);	
	ALUOp:IN std_logic_vector (1 downto 0);
	ALUopcode: OUT std_logic_vector (2 downto 0)
	);
End component;

signal ALUOp_internal: std_logic_vector (1 downto 0); 	 
signal PCWrite_internal, PCWriteCond_internal: std_logic;

begin
	
	U1: ControlFSM
	port map(
		clk => clk,
		rst => rst,
		opcode => opcode,
		RegDst => RegDst,
		RegWrite => RegWrite, 
		ALUSrcA => ALUSrcA,
		MemRead => MemRead,
		MemWrite => MemWrite,
		MemtoReg => MemtoReg,
		IorD => IorD,
		IRWrite => IRWrite,
		PCWrite => PCWrite_internal,
		PCWriteCond => PCWriteCond_internal,
		ALUOp => ALUOp_internal,
		ALUSrcB => ALUSrcB,
		PCSource => PCSource
	);	
	
	U2: ALUControl
	port map(  
		instruc_15to0 => instruc_15to0,
		ALUOp => ALUOp_internal,
		ALUopcode => ALUopcode
	);
	
	PC_enable <= PCWrite_internal or ( PCWriteCond_internal and zero );
	
end architecture;
	