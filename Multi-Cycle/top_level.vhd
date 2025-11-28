library ieee;
use ieee.std_logic_1164.all;

------start entity--------	   
entity top_level is 
	port(
		clk, reset : in std_logic
	);
end top_level;		   


----start architicture----
architecture behavior of top_level is 	 

--components			 

component ALU is
    Port (
        A     	   : in  STD_LOGIC_VECTOR(31 downto 0);
        B          : in  STD_LOGIC_VECTOR(31 downto 0);
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
component shiftleft2_32 is
	port (
	input: in STD_LOGIC_VECTOR(31 downto 0);
	output: out STD_LOGIC_VECTOR(31 downto 0)
	);
end component;


------------ signals ------------

-- 32_bit signals 
signal 	pc_out  : std_logic_vector(31 downto 0) := (others =>'0');
signal  
	    mux_to_address,
	    mem_data_out,
	    memory_data_register_out,
		instruction_register_out,
		mux_to_write_data,
		read_data_1_to_A,
		read_data_2_to_B,
		A_to_mux,
		B_to_mux,
		sign_extend_out,
		shift_32_to_mux,
		mux_to_alu,
		mux_4_to_alu,
		alu_result_out,
		alu_out_to_mux,
		jumb_address,
		mux_to_pc  : std_logic_vector(31 downto 0);	
		
-- 1_bit signals		
signal  alu_zero,
		alu_src_a,
		reg_write,
		reg_dst,
		i_or_d,
		mem_read,
		mem_write,
		mem_to_reg,
		ir_write,
		pc_en	   : std_logic;

-- 2_bit signals
signal  pc_source,
		alu_src_b,
		alu_op	   : std_logic_vector(1 downto 0);

-- 4_bit signals
signal alu_control_to_alu : std_logic_vector(2 downto 0);

-- 5_bit signals
signal mux_to_write_register : std_logic_vector(4 downto 0);

constant pc_increment : std_logic_vector(31 downto 0) := "00000000000000000000000000000100";
					 

begin

-- connections ( todo )
jumb_address(31 downto 28) <= pc_out(31 downto 28);

---------- ALU -----------
logic_unit : ALU 
	port map (
	A 			=> mux_to_alu,
	B 			=> mux_4_to_alu,
	ALUControl 	=> alu_control_to_alu,
	Result   	=> alu_result_out,
    Zero       	=> alu_zero
	);
---------- ALU Out Register -----------
alu_out_reg : aluout 
	port map (
	clk			=> clk,
	reset		=> reset,
	data_in		=> alu_result_out,
	data_out	=> alu_out_to_mux
	);
-------- Control unit (Control_FSM & ALU_control) ------
control_unit : ControlUnit
	port map (
	clk 			=> clk,
	zero			=> alu_zero,
	rst				=> reset,
	opcode			=> instruction_register_out(31 downto 26),
	instruc_15to0	=> instruction_register_out(15 downto 0),
	ALUopcode		=> alu_control_to_alu,
	IorD			=> i_or_d,
	MemRead			=> mem_read,
	MemWrite		=> mem_write,
	MemtoReg		=> mem_to_reg,
	IRWrite			=> ir_write,
	ALUSrcA			=> alu_src_a,
	RegWrite		=> reg_write,
	RegDst			=> reg_dst,
	PCSource		=> pc_source,
	ALUSrcB			=> alu_src_b,
	PC_enable		=> pc_en
	);
------------ Instruction register ------------	
ir : Instruction_register
	port map (
	clk 		=> clk,
	reset		=> reset,
	ir_write	=> ir_write,
	ir_in 		=> mem_data_out,
	ir_out	   	=> instruction_register_out
	);
------------------ Memory --------------------
mem: Memory 
	port map (
	clk 		=> clk,
	reset		=> reset,
	mem_write	=> mem_write,	 
	mem_read	=> mem_read,
	address		=> mux_to_address,
	write_data 	=> B_to_mux,
	mem_data	=> mem_data_out
	);
-------- MDR ( Memory Data Register ) -------
mem_data_register : MDR
	port map (
	clk 	=> clk,
	reset 	=> reset,
	MDR_in	=>  mem_data_out,
	MDR_out =>memory_data_register_out
	);
---------- mux 1 -> 6 ( to do ) -------------
mux_1 : MUX2
	generic map( n=>32)
	port map(
	input_1 => pc_out,
	input_2 => alu_out_to_mux,
	mux_sel => i_or_d,
	output 	=> mux_to_address
	);
	
mux_2 : MUX2
	generic map( n=>5)
	port map(
	input_1 => instruction_register_out(20 downto 16),
	input_2 => instruction_register_out(15 downto 11),
	mux_sel => reg_dst,
	output  => mux_to_write_register
	);

mux_3 : MUX2
	generic map( n=>32)
	port map (
	input_1 => alu_out_to_mux,
	input_2 => memory_data_register_out,
	mux_sel => mem_to_reg,
	output  => mux_to_write_data
	);

mux_4 : MUX2
	generic map( n=>32)
	port map (
	input_1 => pc_out,
	input_2	=> A_to_mux,
	mux_sel	=> alu_src_a,
	output	=> mux_to_alu
	);

mux_5 : MUX4_32
	port map (
	input_1 => B_to_mux,
	input_2 => pc_increment,
	input_3 => sign_extend_out,
	input_4 => shift_32_to_mux,
	mux_sel => alu_src_b,
	output  => mux_4_to_alu
	);
	
mux_6 : MUX3_32 
	port map(
	input_1 => alu_result_out,
	input_2 => alu_out_to_mux,
	input_3 => jumb_address,
	mux_sel => pc_source,
	output  => mux_to_pc
	);	
	
---------- PC ( Program Counter ) -----------
pc : ProgramCounter
	port map (
	clk 	=> clk,
	en  	=> pc_en,
	reset 	=> reset,
	input 	=> mux_to_pc,
	output 	=> pc_out
	); 

---------------- Registers ------------------
reg_file : Register_file
	port map (
	clk			=> clk,
	reset		=> '1',
	write_reg	=> mux_to_write_register,
	address_1	=> instruction_register_out(25 downto 21),
	address_2 	=> instruction_register_out(20 downto 16),
	reg_write  	=> reg_write,
	write_data 	=> mux_to_write_data,
	reg1_data 	=> read_data_1_to_A,
	reg2_data 	=> read_data_2_to_B
	);
	
reg_a : register_a  
	port map(
	clk		=> clk,
	reset 	=> reset,
	data_in	=> read_data_1_to_A,
	data_out=> A_to_mux
	);
	
reg_b : register_b  
	port map(
	clk		=> clk,
	reset 	=> reset,
	data_in	=> read_data_2_to_B,
	data_out=> B_to_mux
	);	
-------------- sign extend ------------------
sign_extend : sign_ext
	port map (
	sign_input  => instruction_register_out(15 downto 0),
	sign_output => sign_extend_out
	);

-------------- shift left 2 (32) -----------------
sl2_32 : shiftleft2_32
	port map (
	input  => sign_extend_out,
	output => shift_32_to_mux
	);

-------------- shift left 2 (28) -----------------
sl2_28 : shiftleft2_28 
 	port map(
 	input  => instruction_register_out(25 downto 0),
    output => jumb_address(27 downto 0)
	);
	
end behavior;