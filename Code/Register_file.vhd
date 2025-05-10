library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register_file is
	port (	clk		: in std_logic;
			reset	: in std_logic;
	
			write_reg	: in std_logic_vector(4 downto 0);
			address_1	: in std_logic_vector(4 downto 0);
			address_2 	: in std_logic_vector(4 downto 0);
			
			reg_write  	: in std_logic;
			write_data 	: in std_logic_vector(31 downto 0);
			
			reg1_data 	: out std_logic_vector(31 downto 0);
			reg2_data 	: out std_logic_vector(31 downto 0));
end entity ;

architecture behavioral of Register_file is
    -- Register array: 32 registers (32-bit each) 
    type reg_array is array (0 to 31) of std_logic_vector(31 downto 0);
    signal reg : reg_array := (
		0  => (others => '0'),                            -- $zero hardwired to 0
		1  => x"00000001",                                 -- $at
		2  => x"00000002",                                -- $v0
		3  => x"00000003",                                -- $v1
		4  => x"00000004",                                -- $a0
		5  => x"00000005",                                -- $a1
		6  => x"00000006",                                -- $a2
		7  => x"00000007",                                -- $a3
		8  => x"00000008",                                -- $t0
		9  => x"00000009",                                -- $t1
		10 => x"0000000A",                                -- $t2
		11 => x"0000000B",                                -- $t3
		12 => x"0000000C",                                -- $t4
		13 => x"0000000D",                                -- $t5
		14 => x"0000000E",                                -- $t6
		15 => x"0000000F",                                -- $t7
		16 => x"00000010",                                -- $s0
		17 => x"00000011",                                -- $s1
		18 => x"00000012",                                -- $s2
		19 => x"00000013",                                -- $s3
		20 => x"00000014",                                -- $s4
		21 => x"00000015",                                -- $s5
		22 => x"00000016",                                -- $s6
		23 => x"00000017",                                -- $s7
		24 => x"00000018",                                -- $t8
		25 => x"00000019",                                -- $t9
		26 => x"0000001A",                                -- $k0
		27 => x"0000001B",                                -- $k1
		28 => x"0000001C",                                -- $gp
		29 => x"0000001D",                                -- $sp
		30 => x"0000001E",                                -- $fp
		31 => x"0000001F"                                 -- $ra
);
begin 
    -- Synchronous write process (on rising edge of clk) 
    process(clk)
    begin
        if reset = '0' then 
            reg <= (others => (others => '0')); -- Reset all registers to 0 	 
        elsif rising_edge(clk) then
            if reg_write = '1' and write_reg /= "00000" then -- Prevent writing to register 0 
                reg(to_integer(unsigned(write_reg))) <= write_data;
            end if;
        end if;
    end process;
    
    -- Asynchronous read 
    reg1_data <= reg(to_integer(unsigned(address_1)));
    reg2_data <= reg(to_integer(unsigned(address_2)));
        
end architecture;

  