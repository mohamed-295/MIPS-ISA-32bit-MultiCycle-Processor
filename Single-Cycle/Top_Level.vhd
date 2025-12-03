-- Top level

library ieee;
use ieee.std_logic_1164.all;

entity Top_Level is
	
    port( clk , reset : in std_logic );	 
	
end Top_Level;	

architecture Behavioral of Top_Level is 

-- components	  

component DataMemory 
	port(
	-- inputs
        CLK       : in std_logic;
        address   : in std_logic_vector(31 downto 0);
        MemWrite  : in std_logic;
        MemRead   : in std_logic;
        WriteData : in std_logic_vector(31 downto 0);

        -- output
        ReadData   : out std_logic_vector(31 downto 0) );
end component; 

component InstructionMem	
	port(
	ReadAddress :in std_logic_vector(31 downto 0);
	Instruction :out std_logic_vector(31 downto 0)
	);
end component; 

component PC
    
	Port (  
		clk : in STD_LOGIC;	  
		reset : in STD_LOGIC; 
		pc_in : in STD_LOGIC_VECTOR(31 downto 0);
		pc_out : out STD_LOGIC_VECTOR(31 downto 0)
    
	);

end component; 	  

component Reg_File 

	Port (	
	    clk : in STD_LOGIC;	
	    reset: in std_logic;
		RegWrite : in STD_LOGIC;-- from Control       
		write_reg : in STD_LOGIC_VECTOR(4 downto 0);
		write_data : in STD_LOGIC_VECTOR(31 downto 0);
		read_reg1 : in STD_LOGIC_VECTOR(4 downto 0);  
		read_reg2 : in STD_LOGIC_VECTOR(4 downto 0);  
		read_data1 : out STD_LOGIC_VECTOR(31 downto 0);
		read_data2 : out STD_LOGIC_VECTOR(31 downto 0) 
	); 
end component;


component ALU 
	port(
		A: in std_logic_vector(31 downto 0);
	   	B: in std_logic_vector(31 downto 0);	  
		control: in std_logic_vector(2 downto 0);
		result: out std_logic_vector(31 downto 0);
		zero: out std_logic
	);
end component;	 

component Add_ALU 
    port(
        A       : in  std_logic_vector(31 downto 0);
        B       : in  std_logic_vector(31 downto 0);
        result  : out std_logic_vector(31 downto 0)

    );
end component;

component ALUControl 
    port (
        ALUOp: in  std_logic_vector(1 downto 0);
        funct: in  std_logic_vector(5 downto 0);
        control: out std_logic_vector(2 downto 0)
    );
end component;

component MUX2x1_5bit 
	port(
		A,B: in std_logic_vector(4 downto 0);
		sel: in std_logic;
		num_out: out std_logic_vector(4 downto 0)
	);
end component;

component MUX2x1_32bit 
	port(
		A,B: in std_logic_vector(31 downto 0);
		sel: in std_logic;
		num_out: out std_logic_vector(31 downto 0)
	);
end component;


component SL2 
	port(
		num_in: in std_logic_vector(31 downto 0);
	   	num_out: out std_logic_vector(31 downto 0)
	);
end component; 

component SL2_Jump  
	port(
		num_in: in std_logic_vector(25 downto 0);
	   	num_out: out std_logic_vector(27 downto 0)
	);
end component;

component sign_ext 
	port(
		num_in: in std_logic_vector(15 downto 0);
	   	num_out: out std_logic_vector(31 downto 0)
	);
end component;	 

component MainControl 
	port(
    	Opcode   : in  STD_LOGIC_VECTOR (5 downto 0); 
        
        RegDst   : out STD_LOGIC;
		Jump     : out STD_LOGIC;
		Branch   : out STD_LOGIC;
		MemRead  : out STD_LOGIC;
		MemtoReg : out STD_LOGIC;
        MemWrite : out STD_LOGIC;
		ALUSrc   : out STD_LOGIC;
        RegWrite : out STD_LOGIC;
        ALUOp    : out STD_LOGIC_VECTOR (1 downto 0) 
		);
end component; 	  


-- constants   

  constant PC_increment : std_logic_vector(31 downto 0) := x"00000004";
  


-- signals:  

  
signal PC_out, MemDataOut, InstructionMemOut : std_logic_vector(31 downto 0);
signal ReadData1_To_ALU,ReadData2_To_MUX2 : std_logic_vector(31 downto 0) ;
signal SignExtendOut, Mux2ToAlu, AluResult,Mux3_out : std_logic_vector(31 downto 0) ;
signal ShiftLeftToAdd2,JumpAddress, PC_in ,Add1_out,Add2_out, Mux4_out : std_logic_vector(31 downto 0);

  
signal ZeroCarry, RegDst,Jump,Branch,MemRead,MemToReg,MemWrite,ALUsrc,RegWrite,ANDtoMUX : std_logic;


signal Mux1_out : std_logic_vector(4 downto 0);


signal ALUControltoALU : std_logic_vector(2 downto 0);


signal ALUOp : std_logic_vector(1 downto 0);

  begin
	  ANDtoMUX <= ZeroCarry and Branch;
      JumpAddress(31 downto 28) <= PC_out(31 downto 28);
	  PC_in <= JumpAddress
       when Jump = '1'
       else Add2_out
        when (Branch = '1' and ZeroCarry = '1')
        else Add1_out;

	  
	  
	  A_Logic_Unit : ALU                  port map(ReadData1_To_ALU, Mux2ToAlu, ALUControltoALU, AluResult, ZeroCarry);
      ALU_CONTROL  : ALUControl           port map(ALUOp, InstructionMemOut(5 downto 0), ALUControltoALU);	  
	  
      CTRL_UNIT    : MainControl          port map(InstructionMemOut(31 downto 26),RegDst,Jump,Branch,MemRead,MemtoReg,MemWrite ,ALUSrc, RegWrite,ALUOp );		   
	  
      INSTR_MEM    : InstructionMem       port map(PC_out, InstructionMemOut); 
	 
      MEM          : DataMemory           port map(clk,ALUResult,MemWrite,MemRead, ReadData2_To_MUX2,MemDataOut);	  
	  
      MUX_1        : MUX2x1_5bit          port map(InstructionMemOut(20 downto 16), InstructionMemOut(15 downto 11),RegDst,Mux1_out);
      MUX_2        : MUX2x1_32bit         port map(ReadData2_To_MUX2, SignExtendOut, ALUsrc, Mux2ToAlu);
      MUX_3        : MUX2x1_32bit         port map(AluResult,MemDataOut, MemToReg,Mux3_out);
      MUX_4        : MUX2x1_32bit         port map(Add1_out, Add2_out, ANDtoMUX, Mux4_out);
    
	  P_C          : PC                   port map(clk, reset, PC_in,  PC_out);	   
	  ADD_1        :Add_ALU			      port map(PC_out,PC_increment,Add1_out);
	  ADD_2        :Add_ALU				  port map(Add1_out,ShiftLeftToAdd2,Add2_out);
	  
      REG          : Reg_File             port map(clk, reset, RegWrite, Mux1_out,Mux3_out,
	                                               InstructionMemOut(25 downto 21), InstructionMemOut(20 downto 16),
	                                               ReadData1_To_ALU, ReadData2_To_MUX2);		
										   
      SE           : sign_ext             port map(InstructionMemOut(15 downto 0), SignExtendOut);
      SLL1         : SL2                  port map(SignExtendOut, ShiftLeftToAdd2);
      SLL2         : SL2_Jump             port map(InstructionMemOut(25 downto 0), JumpAddress(27 downto 0));
  end Behavioral;
  