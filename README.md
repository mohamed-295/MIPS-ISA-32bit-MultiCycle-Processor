# MIPS 32-bit Multi-Cycle Processor

This repository contains the VHDL implementation and testbenches for the core datapath components of a MIPS 32-bit multi-cycle processor. This project is a collaborative effort to design and verify a processor that executes instructions over multiple clock cycles, optimizing the use of functional units.

## Overview

In a multi-cycle MIPS architecture, each instruction is executed over several clock cycles. This approach allows for the reuse of components and a more efficient datapath design. The current implementation focuses on key datapath modules, with ongoing development to integrate additional components and control logic.

## Implemented Components

### Program Counter (PC)
- **Purpose**: Holds the address of the current instruction.
- **Features**:
  - Supports reset
  - Conditional update via enable signal
  - Load external value

### Instruction Register (IR)
- **Purpose**: Stores the fetched instruction from memory.

### Memory
- **Type**: Combined instruction and data memory
- **Features**:
  - 32-bit addressable
  - Read and write operations
  - Preloaded with example instructions and data

### Memory Data Register (MDR)
- **Purpose**: Holds data read from memory before it is used.

### Register File
- **Structure**: 32 general-purpose 32-bit registers
- **Operations**:
  - Read two registers simultaneously
  - Write to one register
  - Write controlled by a `reg_write` signal

### Register A / Register B / ALUOut
- **Type**: 32-bit Register
- **Purpose**: Temporary storage for values used in the execution phase.
- **Signals**:
  - `clk`: Clock input
  - `reset`: Synchronous reset
  - `d`: Input data
  - `q`: Output data

## Simulation & Testbenches

Each module includes a dedicated testbench with:

- Clock generation
- Reset functionality
- Stimulus for all input signals
- Assertions to validate output correctness

### Example Test Cases

- **Writing and Reading Different Values at Different Memory Locations:**
  - Test the ability to write data to specific memory addresses and read it back correctly.
  
- **Ensuring Register File Returns Correct Data After Write:**
  - Verify that data written to a register can be accurately read from the same register.
  
- **Verifying Instruction Register Captures Correct Instruction:**
  - Ensure that the instruction register correctly stores and outputs the fetched instruction.

## Files

### VHDL Files

| File                        | Description                          |
|-----------------------------|--------------------------------------|
| `ProgramCounter.vhd`        | PC implementation                    |
| `Instruction_register.vhd`  | Instruction Register module          |
| `Memory.vhd`                | Combined instruction/data memory     |
| `MDR.vhd`                   | Memory Data Register module          |
| `Register_file.vhd`         | 32-register file                     |
| `register_a.vhd`            | Register A module                    |
| `register_b.vhd`            | Register B module                    |
| `aluout.vhd`                | ALUOut register module               |

### Testbenches

| File                        | Description                          |
|-----------------------------|--------------------------------------|
| `TestBench/ProgramCounter_tb.vhd` | Testbench for Program Counter  |
| `TestBench/Instruction_register_tb.vhd` | Testbench for Instruction Register |
| `TestBench/Memory_tb.vhd`   | Testbench for Memory module          |
| `TestBench/MDR_tb.vhd`      | Testbench for Memory Data Register   |
| `TestBench/Register_file_tb.vhd` | Testbench for Register File    |
| `TestBench/register_a_tb.vhd` | Testbench for Register A          |
| `TestBench/register_b_tb.vhd` | Testbench for Register B          |
| `TestBench/aluout_tb.vhd`   | Testbench for ALUOut register        |
