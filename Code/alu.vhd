library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    Port (
        A     : in  STD_LOGIC_VECTOR(31 downto 0);
        B     : in  STD_LOGIC_VECTOR(31 downto 0);
        ALUControl : in  STD_LOGIC_VECTOR(2 downto 0); -- 3 bits for operations
        Result     : buffer STD_LOGIC_VECTOR(31 downto 0);
        Zero       : out STD_LOGIC
    );
end ALU;

architecture behavior of ALU is
signal temp : std_logic_vector(31 downto 0);
begin
    process(A, B, ALUControl)
    begin
        case ALUControl is
            when "010" => -- ADD0
                temp <= A + B;
            when "110" => -- SUB
                temp <= A - B;
            when "000" => -- AND
                temp <= A and B;
            when "001" => -- OR
                temp <= A or B;
            when "111" => -- SLT (set on less than)
                if (A < B) then
                    temp <= (others => '0');
                    temp(0) <= '1';
                else
                    temp <= (others => '0');
                end if;
			 when "011" => -- Shift Left (Logical)
                temp <= A(30 downto 0) & '0';

            when "100" => -- Shift Right (Logical)
                temp <= '0' & A(31 downto 1);
            when others =>
                temp <= (others => '0');
        end case;

        if temp = X"00000000" then
            Zero <= '1';
        else
            Zero <= '0';
        end if;

    end process; 
	result <= temp;
end behavior;
