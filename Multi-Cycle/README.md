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

### ALU (Arithmetic Logic Unit)
- **Purpose**: Performs arithmetic and logic operations
- **Operations**:
  - Addition (010)
  - Subtraction (110)
  - AND (000)
  - OR (001)
  - SLT (Set Less Than) (111)
  - Shift Left Logical (011)
  - Shift Right Logical (100)
- **Features**:
  - Zero flag output for branch operations

### Control Unit
- **Purpose**: Generates control signals based on opcode and current state
- **Components**:
  - **Control FSM**: Implements the multi-cycle state machine with 11 states
  - **ALU Control**: Generates ALU operation codes
- **Features**:
  - Supports R-type, load word, store word, branch equal, and jump instructions
  - Multi-cycle execution with distinct states for each phase

### Multiplexers
- **Types**:
  - 2-input generic MUX (MUX2)
  - 3-input 32-bit MUX (MUX3_32)
  - 4-input 32-bit MUX (MUX4_32)
- **Purpose**: Route data through the datapath based on control signals

### Sign Extension
- **Purpose**: Extends 16-bit immediate values to 32-bit

### Shift Left Units
- **Types**:
  - 26-bit to 28-bit for jump addresses (shift2_28)
  - 32-bit for branch offsets (shift2_32bit)
- **Purpose**: Performs left shifts for address calculations

## Top-Level Integration

### Top-Level Module
- **Purpose**: Integrates all datapath components and control unit
- **Features**:
  - Complete processor implementation with all necessary interconnections
  - Supports the full instruction set through the multi-cycle datapath
  - Signals for datapath control and monitoring

### Data Path Implementation
- The top-level module connects all components using the following key signals:
  - `pc_out`: Output from the Program Counter
  - `alu_result_out`: Result from the ALU operations
  - `instruction_register_out`: Current instruction being executed
  - Control signals (`i_or_d`, `mem_read`, `mem_write`, etc.)

### System Simulation
- **Top-Level Testbench**
  - Provides a complete processor simulation environment
  - Includes clock generation (10ns period)
  - Implements reset sequence for initialization
  - Runs full instruction sequences to verify processor functionality

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

- **ALU Operations Testing:**
  - Verify that all ALU operations produce correct results and the Zero flag functions properly.

- **Control Unit State Machine Verification:**
  - Test all instruction types to ensure proper state transitions and control signal generation.

- **Full System Testing:**
  - Verify correct execution of complete instruction sequences
  - Validate proper datapath signal routing through all execution phases
  - Confirm proper memory access and register file operations

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
| `alu.vhd`                   | ALU implementation                   |
| `ControlUnit.vhd`           | Top-level control unit               |
| `ControlUnit_FSM.vhd`       | Control finite state machine         |
| `ControlUnit_ALUControl.vhd`| ALU control decoder                  |
| `mux2.vhd`                  | Generic 2-input multiplexer          |
| `mux3_32bit.vhd`            | 3-input 32-bit multiplexer           |
| `mux4_32bit.vhd`            | 4-input 32-bit multiplexer           |
| `s_extension.vhd`           | Sign extension module                |
| `shift2_28.vhd`             | 26-to-28-bit left shift unit         |
| `shift2_32bit.vhd`          | 32-bit left shift unit               |
| `top_level.vhd`             | Complete processor integration       |

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
| `TestBench/alu_TB.vhd`      | Testbench for ALU                    |
| `TestBench/ControlUnit_TB.vhd` | Testbench for Control Unit        |
| `TestBench/ControlUnit_FSM_TB.vhd` | Testbench for Control FSM     |
| `TestBench/ControlUnit_ALUControl_TB.vhd` | Testbench for ALU Control |
| `TestBench/mux2_TB.vhd`     | Testbench for 2-input MUX            |
| `TestBench/mux3_32bit_TB.vhd` | Testbench for 3-input 32-bit MUX   |
| `TestBench/mux4_32bit_TB.vhd` | Testbench for 4-input 32-bit MUX   |
| `TestBench/s_extension_TB.vhd` | Testbench for sign extension      |
| `TestBench/shift2_28_TB.vhd` | Testbench for 28-bit shift unit     |
| `TestBench/shift2_32_TB.vhd` | Testbench for 32-bit shift unit     |
| `TestBench/top_level_tb.vhd` | Testbench for complete processor    |