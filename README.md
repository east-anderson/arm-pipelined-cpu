# 64-bit ARM Pipelined CPU

## Overview

This project is a 64-bit ARM-inspired pipelined CPU designed in SystemVerilog. The processor implements a 5-stage pipeline with instruction fetch, decode, execute, memory, and writeback behavior. The design includes forwarding and hazard-control logic to improve pipeline performance and maintain correct instruction execution.

This repository is intended as a public-facing class project showcase for the architecture, design process, and verification approach. Some course-specific files, testbenches, and implementation details may be omitted if they are not allowed to be shared publicly.

## Project Motivation

Modern processors use pipelining to improve instruction throughput by overlapping the execution of multiple instructions. This project explores how a pipelined CPU is designed at the RTL level, including datapath construction, control logic, hazards, forwarding, branching, memory access, and verification.

The goal of the project was to better understand the relationship between computer architecture concepts and their hardware implementation in SystemVerilog.

## Key Features

- 64-bit datapath
- ARM-inspired instruction support
- Multi-stage pipelined processor design
- Instruction fetch, decode, execute, memory, and writeback stages
- Register file integration
- ALU operation support
- Data memory and instruction memory integration
- Forwarding logic to reduce unnecessary stalls
- Hazard detection and control
- Branch and control-flow handling
- SystemVerilog RTL implementation
- Simulation-based testing and debugging

## Pipeline Architecture

The CPU follows a classic five-stage pipeline structure:

1. **Instruction Fetch (IF)**  
   Fetches the next instruction from instruction memory and updates the program counter.

2. **Instruction Decode (ID)**  
   Decodes the instruction, reads register operands, and generates control signals.

3. **Execute (EX)**  
   Performs ALU operations, branch calculations, and address calculations.

4. **Memory (MEM)**  
   Handles data memory reads and writes for load/store instructions.

5. **Writeback (WB)**  
   Writes results back to the register file.

```text
+----------+     +----------+     +----------+     +----------+     +----------+
|   IF     | --> |   ID     | --> |   EX     | --> |   MEM    | --> |   WB     |
| Fetch    |     | Decode   |     | Execute  |     | Memory   |     | Writeback|
+----------+     +----------+     +----------+     +----------+     +----------+
      |                |                |                |                |
      v                v                v                v                v
 Program        Register File        ALU /          Data Memory       Register
 Counter        Control Logic        Branch Logic                     Writeback
