# MIPS 32-bit Multi-Cycle Processor

This repository contains the VHDL implementation and testbenches for the core datapath components of a MIPS 32-bit multi-cycle processor. This project is a collaborative effort to design and verify a processor that executes instructions over multiple clock cycles, optimizing the use of functional units.

## Overview

In a multi-cycle MIPS architecture, each instruction is executed over several clock cycles. This approach allows for the reuse of components and a more efficient datapath design. The current implementation focuses on key datapath modules, with ongoing development to integrate additional components and control logic.

## Implemented Components

### Register A / Register B / ALUOut
- **Type**: 32-bit Register
- **Purpose**: Temporary storage for values used in the execution phase.
- **Signals**:
  - `clk`: Clock input
  - `reset`: Synchronous reset
  - `d`: Input data
  - `q`: Output data

### Program Counter (PC)
- **Purpose**: Holds the address of the current instruction.
- **Features**:
  - Supports reset
  - Conditional update via enable signal
  - Load external value

### Instruction Register (IR)
- **Purpose**: Stores the fetched instruction from memory.

### Memory Data Register (MDR)
- **Purpose**: Holds data read from memory before it is used.

### Register File
- **Structure**: 32 general-purpose 32-bit registers
- **Operations**:
  - Read two registers simultaneously
  - Write to one register
  - Write controlled by a `reg_write` signal

## Simulation & Testbenches

Each module includes a dedicated testbench with:

- Clock generation
- Reset functionality
- Stimulus for all input signals
- Assertions to validate output correctness

### Sample Tests

#### Register File Test
```vhdl
-- Write data to register 1
write_reg_tb   <= "00001";
write_data_tb  <= x"AAAA5555";
reg_write_tb   <= '1';
wait for clk_period;
reg_write_tb   <= '0';

-- Read and assert
address_1_tb   <= "00001";
wait for clk_period;
assert reg1_data_tb = x"AAAA5555"
  report "Error: Register 1 read incorrect" severity error;
Example Test Cases
Writing and reading different values at different memory locations
Ensuring register file returns correct data after write
Verifying instruction register captures correct instruction
Files
File	Description
register_a.vhd	Register A module
register_b.vhd	Register B module
aluout.vhd	ALUOut register module
program_counter.vhd	PC implementation
instruction_register.vhd	Instruction Register module
memory_data_register.vhd	Memory Data Register module
register_file.vhd	32-register file
*_tb.vhd	Testbenches for each module