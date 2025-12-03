library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataMemory is
  port( -- inputs
        CLK       : in std_logic;
        address   : in std_logic_vector(31 downto 0);
        MemWrite  : in std_logic;
        MemRead   : in std_logic;
        WriteData : in std_logic_vector(31 downto 0);

        -- output
        ReadData   : out std_logic_vector(31 downto 0) );
end DataMemory;

architecture Behavioral of DataMemory is	
  type mem_type is array (0 to 255) of std_logic_vector(7 downto 0);
  signal mem: mem_type := (

    -- R-type instructions (opcode 000000) --

    -- add $3, $1, $2    (opcode: 0x00221820)
    -- $3 = $1 + $2
    0 => "00000000", -- opcode = 0 (R-type), rs = $1
    1 => "00100010", -- rt = $2
    2 => "00011000", -- rd = $3, shamt = 0
    3 => "00100000", -- funct = 0x20 (ADD)

    -- add $2, $2, $0    (opcode: 0x00401020)
    -- $2 = $2 + $0 (nop operation)
    12 => "00000000", -- opcode = 0 (R-type), rs = $2
    13 => "01000000", -- rt = $0
    14 => "00010000", -- rd = $2, shamt = 0
    15 => "00100000", -- funct = 0x20 (ADD)

    -- sub $0, $1, $2    (opcode: 0x00220022)
    -- $0 = $1 - $2 (discarded)
    24 => "00000000", -- opcode = 0 (R-type), rs = $1
    25 => "00100010", -- rt = $2
    26 => "00000000", -- rd = $0, shamt = 0
    27 => "00100010", -- funct = 0x22 (SUB)

    -- and $5, $6, $7    (opcode: 0x00C73824)
    -- $5 = $6 AND $7
    40 => "00000000",
    41 => "11000111",
    42 => "00101000",
    43 => "00100100",

    -- or $8, $9, $10    (opcode: 0x012A4025)
    -- $8 = $9 OR $10
    44 => "00000001",
    45 => "00101010",
    46 => "01000000",
    47 => "00100101",

    -- slt $11, $12, $13 (opcode: 0x018D582A)
    -- $11 = ($12 < $13) ? 1 : 0
    48 => "00000001",
    49 => "10001101",
    50 => "01011000",
    51 => "00101010",
    -- I-type instructions --

    -- addi $1, $3, 50    (opcode: 0x20610032)
    -- $1 = $3 + 50
    4 => "00100000", -- opcode = 0x08 (ADDI), rs = $3
    5 => "01100001", -- rt = $1
    6 => "00000000", -- immediate high byte
    7 => "00110010", -- immediate low byte (50)

    -- addi $2, $3, 48    (opcode: 0x20620030)
    -- $2 = $3 + 48
    8 => "00100000", -- opcode = 0x08 (ADDI), rs = $3
    9 => "01100010", -- rt = $2
    10 => "00000000", -- immediate high byte
    11 => "00110000", -- immediate low byte (48)

    -- addi $4, $3, 10    (opcode: 0x2064000A)
    -- $4 = $3 + 10
    36 => "00100000", -- opcode = 0x08 (ADDI), rs = $3
    37 => "01100100", -- rt = $4
    38 => "00000000", -- immediate high byte
    39 => "00001010", -- immediate low byte (10)

    -- Memory operations --

    -- lw $10, 47($20)   (opcode: 0x8E8A002F)
    -- $10 = MEM[$20 + 47]
    28 => "10001110", -- opcode = 0x23 (LW), rs = $20
    29 => "10001010", -- rt = $10
    30 => "00000000", -- offset high byte
    31 => "00101111", -- offset low byte (47)

    -- sw $11, 47($20)   (opcode: 0xAE8B002F)
    -- MEM[$20 + 47] = $11
    32 => "10101110", -- opcode = 0x2B (SW), rs = $20
    33 => "10001011", -- rt = $11
    34 => "00000000", -- offset high byte
    35 => "00101111", -- offset low byte (47)

    -- Control flow instructions --

    -- beq $1, $2, 1     (opcode: 0x10220001)
    -- if ($1 == $2) PC += 4 + (1<<2)
    16 => "00010000", -- opcode = 0x04 (BEQ), rs = $1
    17 => "00100010", -- rt = $2
    18 => "00000000", -- offset high byte
    19 => "00000001", -- offset low byte (1)

    -- j 7               (opcode: 0x08000007)
    -- PC = (PC & 0xF0000000) | (7 << 2)
    20 => "00001000", -- opcode = 0x02 (J)
    21 => "00000000", -- target address part 1
    22 => "00000000", -- target address part 2
    23 => "00000111", -- target address part 3 (7)

    -- Additional instructions (continued in same format) --
    -- lui $16, 1000      (opcode: 0x3C1003E8)
    56 => "00111100", -- opcode = 0x0F (LUI)
    57 => "00000000", -- rt = $16
    58 => "00010000", -- immediate high byte (3)
    59 => "00000000", -- immediate low byte (E8)

    -- jal 1000           (opcode: 0x0C0003E8)
    64 => "00001100", -- opcode = 0x03 (JAL)
    65 => "00000000", -- target address part 1
    66 => "00000000", -- target address part 2
    67 => "00111111", -- target address part 3 (3E8)

    -- Data section --
    136 => "11011110", -- Data: 0xDE
    137 => "10101101", -- Data: 0xAD
    138 => "10111110", -- Data: 0xBE
    139 => "11101111", -- Data: 0xEF

    OTHERS => "00000000" -- Default for unused locations
		
);

begin

  process(CLK)
  variable addr : integer;
begin
  if rising_edge(CLK) then
    if MemWrite = '1' then
      addr := to_integer(unsigned(address));
      if addr <= 60 then  -- prevent overflow when writing 4 bytes
        mem(addr)     <= WriteData(31 downto 24);
        mem(addr + 1) <= WriteData(23 downto 16);
        mem(addr + 2) <= WriteData(15 downto 8);
        mem(addr + 3) <= WriteData(7  downto 0);
      end if;
    end if;
  end if;
end process;

-- Combinational read (with bound checking)
ReadData <=
  mem(to_integer(unsigned(address)))     &
  mem(to_integer(unsigned(address)) + 1) &
  mem(to_integer(unsigned(address)) + 2) &
  mem(to_integer(unsigned(address)) + 3) when
    (MemRead = '1' and to_integer(unsigned(address)) <= 60)
else (others => '0');
end architecture ;
