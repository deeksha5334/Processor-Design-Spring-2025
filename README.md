# Processor-Design-Spring-20245
Computer Architecture and Organization
# 37-bit Instruction Set Architecture (ISA) Processor

This repository contains the implementation of a custom 37-bit ISA processor as specified in the Phase 1 document. The processor is designed for general computing tasks with a von Neumann architecture.

## Architecture Specifications

- Target Market: General Purpose
- Memory Organization: Von Neumann (single memory space for both code and data)
- Address Bus Width: 10 bits (can address 1024 memory locations)
- Data Bus Width: 48 bits (each memory word and register is 48 bits)
- Register File: 32 × 48 bits (32 registers, each 48 bits wide)
- Program Load Address: 0x200 (512 in decimal)
- Instruction Width: 37 bits
- Immediate Field: 16 bits (size of immediate value in I-type instructions)
- Maximum Instructions: 64 (supporting up to 64 distinct instructions with 6-bit opcode)
- Endianness: Little Endian

## Instruction Formats

1. R-Type (Register-to-Register)
   - Format: `[opcode:6][rs1:5][rs2:5][rd:5][shamt:5][function:11]`
   - Used for operations that require two source operands and produce a result in a destination register

2. I-Type (Immediate)
   - Format: `[opcode:6][rs:5][rd:5][immediate:16]`
   - Used for operations involving one register operand and one immediate value, as well as load/store and branch instructions

3. J-Type (Jump)
   - Format: `[opcode:6][link_reg:5][jump_address:26]`
   - Used for unconditional jumps and procedure calls

## Instruction Set

### Arithmetic and Logical Operations
- `ADD`: rd = rs1 + rs2
- `ADDI`: rd = rs1 + immediate
- `SUB`: rd = rs1 - rs2
- `SUBI`: rd = rs1 - immediate
- `SLT`: rd = (rs1 < rs2) ? 1 : 0
- `LI`: rd = immediate

### Memory Operations
- `LW`: rd = Memory[rs1 + immediate]
- `SW`: Memory[rs1 + immediate] = rd

### Control Flow Operations
- `J`: PC = jump_address
- `BEQ`: if (rs1 == rd) PC = PC + immediate
- `BNE`: if (rs1 != rd) PC = PC + immediate

## Test Programs

### Program 1: C = A + B
Computes the sum of two values from memory and stores the result back to memory.

- Memory Setup:
  - A = 0x10 (contains value 20)
  - B = 0x20 (contains value 22)
  - C = 0x30 (should contain value 42 after execution)

### Program 2: Sum of Integers from 0 to 10
Calculates the sum of integers from 0 to 10 using a loop.

- **Register Allocation**:
  - $s0 (reg 16): i (loop counter)
  - $s1 (reg 17): sum (result)
  - $s2 (reg 18): constant 10 (loop limit)
  - $s3 (reg 19): constant 1 (for incrementing)

## Module Structure

- alu.v: ALU implementation
- control_unit.v: Control unit logic
- cpu.v: Top-level CPU module
- instruction_memory.v: Instruction memory
- data_memory.v: Data memory
- register_file.v: Register file (32x48 bits)
- instruction_decoder.v: Instruction field extraction and type determination
- program_counter.v: Program counter module
- tb_program1.v: Test bench for Program 1 (A + B)
- tb_program2.v: Test bench for Program 2 (Sum from 0 to 10)

## How to Run

1. Compile the Verilog files using a Verilog compiler (e.g., Icarus Verilog):
   ```
   iverilog -o program1 tb_program1.v alu.v control_unit.v cpu.v data_memory.v instruction_decoder.v instruction_memory.v program_counter.v register_file.v
   ```

2. Run the simulation:
   ```
   vvp program1
   ```

3. Repeat the process for Program 2 (replace `program1` with `program2` and `tb_program1.v` with `tb_program2.v`).

## Implementation Notes

1. The processor uses a 10-bit PC, allowing it to address up to 1024 memory locations.
2. 16-bit immediate values from I-type instructions are sign-extended to 48 bits for operations.
3. For branch instructions, the immediate value is treated as an offset relative to the current PC.
4. The architecture uses little-endian byte ordering.
