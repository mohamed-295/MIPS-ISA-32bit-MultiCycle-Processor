LIBRARY IEEE;
use ieee.std_logic_1164.all;

Entity ControlFSM is 
	port( 
	-- inputs
	clk, rst: IN std_ulogic;
	opcode: IN std_ulogic_vector (5 downto 0);	
	-- outputs(Control signals)
	PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst: OUT std_ulogic;
	PCSource, ALUSrcB, ALUOp: OUT std_ulogic_vector (1 downto 0)
	);
End entity;


Architecture Behavioral of ControlFSM is   

--state defining
Type state_type is (
InstructionFetch,
InstructionDecode,
MemAddressComputation,
MemAccessLoad,
MemReadCompletion,
MemAccessStore,
Excute_R,
R_Completion,
BranchCompletion,
JumpCompletion,
ErrorState);
signal state,NxtState : state_type;	   

begin
	
	--state process
	Process(clk, rst)
	begin
		if rst = '0' then 
			state <= InstructionFetch;
		elsif RISING_EDGE(clk) then 
			state <= NxtState;
		end if;
	end Process;
	
	-- generating signals process
	Process(state, opcode)
	
	--signals arrangment (10 x 1 bit, 3 x 2 bits)
	--PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst, PCSource, ALUSrcB, ALUOp	
	Variable Control_signals: std_ulogic_vector (15 downto 0);
	
	--opcode constants
	Constant RTYPE: std_ulogic_vector (5 downto 0) := "000000";
	Constant LOADWORD: std_ulogic_vector (5 downto 0) := "100011";
	Constant STOREWORD: std_ulogic_vector (5 downto 0) := "101011";
	Constant BEQ: std_ulogic_vector (5 downto 0) := "000100";
	Constant JUMP: std_ulogic_vector (5 downto 0) := "000010";	
	
	begin 
		case state is 
			--Instruction Fetch
			when InstructionFetch  => 
			Control_signals := "0101001000000100"; 
			NxtState <= InstructionDecode;
			
			--Instruction Decode and Register Fetch	 
			when InstructionDecode  => 
			Control_signals := "0000000000001100"; 
			
			if opcode = LOADWORD or opcode = STOREWORD then
				NxtState <= MemAddressComputation;
			elsif opcode = RTYPE then
				NxtState <= Excute_R; 
			elsif opcode = BEQ then
				NxtState <= BranchCompletion; 
			elsif opcode = JUMP then
				NxtState <= JumpCompletion;	 
			else 
				NxtState <= ErrorState;
			end if;
			
			--Memory Address Computation
			when MemAddressComputation =>
			Control_signals := "0000000100001000"; 
			
			if opcode = LOADWORD then 
				NxtState <= MemAccessLoad;	
			elsif opcode = STOREWORD then
				NxtState <= MemAccessStore;
			else 
				NxtState <= ErrorState;	
			end if;
			
			--Memory Access Load word
			when MemAccessLoad =>
			Control_signals := "0011000100001000";	 
			NxtState <= MemReadCompletion;	 
			
			--Memory Read Completion
			when MemReadCompletion =>
			Control_signals := "0000010110001000";	 
			NxtState <= InstructionFetch;
			
			--Memory Access Store Word
			when MemAccessStore =>
			Control_signals := "0010100100001000";	 
			NxtState <= InstructionFetch;
			
			--Excution (R_type instructions)
			when Excute_R =>
			Control_signals := "0000000100000010";	 
			NxtState <= R_Completion;  
			
			--R_type Completion
			when R_Completion =>
			Control_signals := "0000000111000010";	 
			NxtState <= InstructionFetch;
			
			--Branch Completion
			when BranchCompletion =>
			Control_signals := "1000000100010001";	 
			NxtState <= InstructionFetch;	  
			
			--Jump Completion
			when JumpCompletion =>
			Control_signals := "0100000000101100";	 
			NxtState <= InstructionFetch;
			
			when others =>
			Control_signals := (others => 'X');	 
			NxtState <= ErrorState;	 
		end case;  
		
		PCWriteCond <= Control_signals(15);
		PCWrite <= Control_signals(14);
		IorD <= Control_signals(13);
		MemRead <= Control_signals(12);
		MemWrite <= Control_signals(11);
		MemtoReg <= Control_signals(10);
	    IRWrite <= Control_signals(9);
		ALUSrcA <= Control_signals(8);
		RegWrite <= Control_signals(7);
		RegDst <= Control_signals(6);
		PCSource <= Control_signals(5 downto 4);
		ALUSrcB	<= Control_signals(3 downto 2);
		ALUOp <= Control_signals(1 downto 0);
		
	end process;
end architecture;
		
			
		
		
		

