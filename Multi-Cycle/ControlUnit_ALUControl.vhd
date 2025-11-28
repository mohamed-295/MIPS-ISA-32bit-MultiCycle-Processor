LIBRARY IEEE;
use ieee.std_logic_1164.all;

Entity ALUControl is 
	port( 
	-- inputs
	instruc_15to0: IN std_logic_vector (15 downto 0);	
	ALUOp:IN std_logic_vector (1 downto 0);
	-- outputs 
	ALUopcode: OUT std_logic_vector (2 downto 0)
	);
End entity;	

Architecture Behavioral of ALUControl is
begin 
	process (instruc_15to0, ALUOp)	 
	
	--funct bits for different operations
	Constant ADD_C: std_logic_vector (5 downto 0) := "100000";
	Constant SUB_C: std_logic_vector (5 downto 0) := "100010";
	Constant AND_C: std_logic_vector (5 downto 0) := "100100";
	Constant OR_C: std_logic_vector (5 downto 0) := "100101";
	Constant SLT_C: std_logic_vector (5 downto 0) := "101010";
	Constant SLL_C: std_logic_vector (5 downto 0) := "000000";
	Constant SRL_C: std_logic_vector (5 downto 0) := "000010";
	
	begin
		case ALUop is 
			when "00" => ALUopcode <= "010"; --addition
			when "01" => ALUopcode <= "110"; --subtraction
			when "10" => --R_type instruction hence funct bits are determinant of operation	 
			case instruc_15to0 (5 downto 0) is
				when ADD_C => ALUopcode <= "010"; --Addition (two registers)
				when SUB_C => ALUopcode <= "110"; --Subtraction (two registers)
				when AND_C => ALUopcode <= "000"; --AND
				when OR_C => ALUopcode <= "001"; --OR
				when SLT_C => ALUopcode <= "111"; --SLT (set less than)
				when SLL_C => ALUopcode <= "011"; --SLL	(shift left logical)
				when SRL_C => ALUopcode <= "100"; --SRL (shift right logical)
				when others => ALUopcode <= "000"; 
			end case;
			when others => ALUopcode <= "000"; 
		end case;
	end process;
end architecture;
		
	
	
