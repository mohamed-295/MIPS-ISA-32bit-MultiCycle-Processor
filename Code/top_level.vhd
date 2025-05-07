library ieee;
use ieee.std_logic_1164.all;

------start entity--------	   
entity top_level is 
	port(CLk, reset_neg : in std_logic);
end top_level;		   


----start architicture----
architecture behavior of top_level is 	 

--components			 

component ALU is
    Port (
        A     : in  STD_LOGIC_VECTOR(31 downto 0);
        B     : in  STD_LOGIC_VECTOR(31 downto 0);
        ALUControl : in  STD_LOGIC_VECTOR(2 downto 0); -- 3 bits for operations
        Result     : buffer STD_LOGIC_VECTOR(31 downto 0);
        Zero       : out STD_LOGIC
    );
end component;
----------------------------------
component aluout is 
	port (	clk		: in std_logic;
			reset	: in std_logic;
			data_in	: in std_logic_vector(31 downto 0);
			data_out: out std_logic_vector(31 downto 0));
end component ;	
---------------------------------------
component ControlUnit is 
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
end component;	
---------------------------------------
component ALUControl is 
	port( 
	-- inputs
	instruc_15to0: IN std_logic_vector (15 downto 0);	
	ALUOp:IN std_logic_vector (1 downto 0);
	-- outputs 
	ALUopcode: OUT std_logic_vector (2 downto 0)
	);
end component;	  
----------------------------------------- 
component ControlFSM is 
	port( 
	-- inputs
	clk, rst: IN std_logic;
	opcode: IN std_logic_vector (5 downto 0);
	
	-- outputs(Control signals)
	PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst: OUT std_logic;
	PCSource, ALUSrcB, ALUOp: OUT std_logic_vector (1 downto 0)
	);
end component;	 
-----------------------------------------
component Instruction_register is
    Port ( 	clk 		: in std_logic;
			reset		: in std_logic;
			ir_write	: in std_logic;
			ir_in 		: in std_logic_vector(31 downto 0);
			
			ir_out	   	: out std_logic_vector(31 downto 0));
end component ;	
-----------------------------------------
component MDR is
	port ( 	clk 	: in	std_logic;
			reset 	: in	std_logic;
			MDR_in	: in 	std_logic_vector(31 downto 0);
			MDR_out : out 	std_logic_vector(31 downto 0));
end component ;	   
-----------------------------------------
component Memory is
	port (	clk 		: in std_logic;
			reset		: in std_logic;
			mem_write	: in std_logic;	 
			mem_read	: in std_logic;
			address		: in std_logic_vector(31 downto 0);
			write_data 	: in std_logic_vector(31 downto 0);
			
			mem_data	: out std_logic_vector(31 downto 0));
end component ;	
------------------------------------------
component MUX2 is
	generic  (n: integer := 32);
	port(
	input_1 : in std_logic_vector(n-1 downto 0);
	input_2 : in std_logic_vector(n-1 downto 0);
	mux_sel : in std_logic;
	output : out std_logic_vector(n-1 downto 0)
	);
end component; 
-------------------------------------------
component MUX3_32 is
	port(
	input_1 : in std_logic_vector(31 downto 0);
	input_2 : in std_logic_vector(31 downto 0);
	input_3 : in std_logic_vector(31 downto 0);
	mux_sel : in std_logic_vector(1 downto 0);
	output : out std_logic_vector(31 downto 0)
	);
end component;
-------------------------------------------
component MUX4_32 is
	port(
	input_1 : in std_logic_vector(31 downto 0);
	input_2 : in std_logic_vector(31 downto 0);
	input_3 : in std_logic_vector(31 downto 0);
	input_4 : in std_logic_vector(31 downto 0);
	mux_sel : in std_logic_vector(1 downto 0);
	output : out std_logic_vector(31 downto 0)
	);
end component;
-------------------------------------------
component ProgramCounter is
	port ( 	clk 	: in std_logic;
			en  	: in std_logic;
		 	reset 	: in std_logic;
			input 	: in std_logic_vector(31 downto 0);
			output 	: out std_logic_vector(31 downto 0)); 
end component ;	
-------------------------------------------
component register_a is 
	port (	clk		: in std_logic;
			reset 	: in std_logic;
			data_in	: in std_logic_vector(31 downto 0);
			data_out: out std_logic_vector(31 downto 0));
end component ;
--------------------------------------------
component register_b is 
	port (	clk		: in std_logic;
			reset	: in std_logic;
			data_in	: in std_logic_vector(31 downto 0);
			data_out: out std_logic_vector(31 downto 0));
end component ;
--------------------------------------------
component Register_file is
	port (	clk		: in std_logic;
			reset	: in std_logic;
	
			write_reg	: in std_logic_vector(4 downto 0);
			address_1	: in std_logic_vector(4 downto 0);
			address_2 	: in std_logic_vector(4 downto 0);
			
			reg_write  	: in std_logic;
			write_data 	: in std_logic_vector(31 downto 0);
			
			reg1_data 	: out std_logic_vector(31 downto 0);
			reg2_data 	: out std_logic_vector(31 downto 0));
end component ;		  
--------------------------------------------
component sign_ext is
	port (
	sign_input : in std_logic_vector(15 downto 0);
	sign_output : out std_logic_vector(31 downto 0)
	);
end component;
--------------------------------------------
component shiftleft2_28 is
  port(
        input  : in std_logic_vector(25 downto 0);
        output : out std_logic_vector(27 downto 0) );
end component;	   
--------------------------------------------
entity shiftleft2_32 is
	port (
	input: in STD_LOGIC_VECTOR(31 downto 0);
	output: out STD_LOGIC_VECTOR(31 downto 0)
	);
end component;


-- signals ( todo )	 


begin

-- connections ( todo )


end behavior;