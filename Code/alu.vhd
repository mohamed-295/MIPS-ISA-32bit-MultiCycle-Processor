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
begin
    process(A, B, ALUControl)
    begin
        case ALUControl is
            when "010" => -- ADD0
                Result <= A + B;
            when "110" => -- SUB
                Result <= A - B;
            when "000" => -- AND
                Result <= A and B;
            when "001" => -- OR
                Result <= A or B;
            when "111" => -- SLT (set on less than)
                if (A < B) then
                    Result <= (others => '0');
                    Result(0) <= '1';
                else
                    Result <= (others => '0');
                end if;

            when others =>
                Result <= (others => '0');
        end case;

        if Result = X"00000000" then
            Zero <= '1';
        else
            Zero <= '0';
        end if;
    end process;
end behavior;
