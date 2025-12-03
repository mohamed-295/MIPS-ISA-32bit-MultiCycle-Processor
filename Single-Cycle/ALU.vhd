library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;	
use ieee.numeric_std.all;


  --> ALU Operation Codes <--
--------------------------------
-- add (default) 		| 010 |
-- subtract    			| 110 |
-- and         			| 000 |
-- or          			| 001 |
-- shift_left  			| 111 |
--------------------------------


entity ALU is
	port(
		A: in std_logic_vector(31 downto 0);
	   	B: in std_logic_vector(31 downto 0);	  
		control: in std_logic_vector(2 downto 0);
		result: out std_logic_vector(31 downto 0);
		zero: out std_logic
	);
end entity;

architecture ALU_ARCH of ALU is
	signal temp_buf: std_logic_vector(31 downto 0):= (others => '0');
    signal A_int : std_logic_vector(31 downto 0) := (others => '0');
    signal B_int : std_logic_vector(31 downto 0) := (others => '0');

begin

    A_int <= A;
    B_int <= B;

    process(A_int, B_int, control)
    begin
	
	  case control is
 
	    when "010" =>  -- ADD
	
	      temp_buf <= std_logic_vector(unsigned(A_int) + unsigned(B_int));
	
	    when "110" =>  -- SUB
		
	      temp_buf <= std_logic_vector(unsigned(A_int) - unsigned(B_int));
	
	    when "000" =>  -- AND
				
	      temp_buf <= A_int and B_int;

	    when "001" =>  -- OR
		
	      temp_buf <= A_int or B_int;
	
	    when "111" =>  -- SHIFT LEFT LOGICAL (assume shift amount in B(4 downto 0))
		
	      temp_buf <= std_logic_vector(shift_left(unsigned(A_int), to_integer(unsigned(B_int(4 downto 0)))));

	    when others =>
	
	      temp_buf <= (others => '0');
		
	 end case;

   end process;


 result <= temp_buf;

 zero <= '1' when temp_buf = x"00000000" else '0';
	

end architecture;
