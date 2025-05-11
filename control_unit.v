// Fixed Control unit module for the 37-bit ISA processor
module control_unit (
    input [5:0] opcode,           // Instruction opcode
    input [10:0] funct_r,         // Function field for R-type instructions
    input is_bne,                 // Is BNE instruction flag
    output reg reg_write,         // Register write enable
    output reg mem_read,          // Memory read enable
    output reg mem_write,         // Memory write enable
    output reg branch,            // Branch instruction flag
    output reg jump,              // Jump instruction flag
    output reg alu_src,           // ALU source selector (0: register, 1: immediate)
    output reg mem_to_reg,        // Memory to register selector (0: ALU result, 1: memory data)
    output reg [3:0] alu_op       // ALU operation code
);

    // ALU Operations
    parameter ALU_ADD = 4'b0000;  // Addition
    parameter ALU_SUB = 4'b0001;  // Subtraction
    parameter ALU_SLT = 4'b0010;  // Set Less Than
    parameter ALU_LI  = 4'b0011;  // Load Immediate

    // Opcodes
    parameter R_TYPE = 6'b000000; // R-type instruction
    parameter ADDI   = 6'b000001; // Add immediate
    parameter SUBI   = 6'b000010; // Subtract immediate
    parameter LW     = 6'b001000; // Load word
    parameter SW     = 6'b001001; // Store word
    parameter J      = 6'b010000; // Jump
    parameter BEQ    = 6'b010010; // Branch if equal
    parameter BNE    = 6'b010011; // Branch if not equal
    parameter LI     = 6'b011000; // Load immediate

    // Function codes for R-type instructions
    parameter ADD_FUNCT = 11'b00000000001; // Add
    parameter SUB_FUNCT = 11'b00000000010; // Subtract
    parameter SLT_FUNCT = 11'b00000001000; // Set less than

    // Control signal generation
    always @(*) begin
        // Default values
        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        branch = 1'b0;
        jump = 1'b0;
        alu_src = 1'b0;
        mem_to_reg = 1'b0;
        alu_op = 4'b0000;

        case (opcode)
            R_TYPE: begin
                // R-type instructions
                reg_write = 1'b1;      // Write to register
                
                // Set ALU operation based on function code
                case (funct_r)
                    ADD_FUNCT: begin
                        alu_op = ALU_ADD;
                        $display("Control: R-type ADD instruction");
                    end
                    SUB_FUNCT: begin
                        alu_op = ALU_SUB;
                        $display("Control: R-type SUB instruction");
                    end
                    SLT_FUNCT: begin
                        alu_op = ALU_SLT;
                        $display("Control: R-type SLT instruction");
                    end
                    default: begin
                        alu_op = ALU_ADD;
                        $display("Control: Unknown R-type function: %b", funct_r);
                    end
                endcase
            end
            
            ADDI: begin
                // Add immediate
                reg_write = 1'b1;  // Write to register
                alu_src = 1'b1;    // Use immediate
                alu_op = ALU_ADD;  // Addition operation
                $display("Control: ADDI instruction");
            end
            
            SUBI: begin
                // Subtract immediate
                reg_write = 1'b1;  // Write to register
                alu_src = 1'b1;    // Use immediate
                alu_op = ALU_SUB;  // Subtraction operation
                $display("Control: SUBI instruction");
            end
            
            LW: begin
                // Load word
                reg_write = 1'b1;   // Write to register
                mem_read = 1'b1;    // Read from memory
                alu_src = 1'b1;     // Use immediate for address calculation
                mem_to_reg = 1'b1;  // Write memory data to register
                alu_op = ALU_ADD;   // Addition for address calculation
                $display("Control: LW instruction");
            end
            
            SW: begin
                // Store word
                mem_write = 1'b1;   // Write to memory
                alu_src = 1'b1;     // Use immediate for address calculation
                alu_op = ALU_ADD;   // Addition for address calculation
                $display("Control: SW instruction");
            end
            
            J: begin
                // Jump
                jump = 1'b1;        // Jump instruction
                $display("Control: J instruction");
            end
            
            BEQ: begin
                // Branch if equal
                branch = 1'b1;      // Branch instruction
                alu_op = ALU_SUB;   // Subtraction for comparison
                $display("Control: BEQ instruction");
            end
            
            BNE: begin
                // Branch if not equal
                branch = 1'b1;      // Branch instruction
                alu_op = ALU_SUB;   // Subtraction for comparison
                $display("Control: BNE instruction");
            end
            
            LI: begin
                // Load immediate
                reg_write = 1'b1;   // Write to register
                alu_src = 1'b1;     // Use immediate
                alu_op = ALU_LI;    // Pass immediate to result
                $display("Control: LI instruction");
            end
            
            default: begin
                // Unknown opcode - NOP
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                jump = 1'b0;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                alu_op = 4'b0000;
                $display("Control: Unknown opcode: %b", opcode);
            end
        endcase
    end

endmodule
