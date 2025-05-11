// Instruction decoder module for the 37-bit ISA processor
module instruction_decoder (
    input [36:0] instruction,         // 37-bit instruction
    output [5:0] opcode,              // 6-bit opcode
    output [4:0] rs1,                 // Source register 1
    output [4:0] rs2,                 // Source register 2
    output [4:0] rd,                  // Destination register
    output [4:0] shamt,               // Shift amount
    output [10:0] funct_r,            // Function code for R-type
    output [15:0] immediate,          // Immediate value
    output [25:0] jump_address,       // Jump address
    output [4:0] link_reg,            // Link register
    output reg is_r_type,             // R-type instruction flag
    output reg is_i_type,             // I-type instruction flag
    output reg is_j_type              // J-type instruction flag
);

    // Extract common fields for all instruction types
    assign opcode = instruction[36:31];
    
    // Extract fields for R-type instructions
    assign rs1 = instruction[30:26];
    assign rs2 = instruction[25:21];
    assign rd = instruction[20:16];
    assign shamt = instruction[15:11];
    assign funct_r = instruction[10:0];
    
    // Extract fields for I-type instructions
    // rs1 is already extracted above
    // rd is already extracted above
    assign immediate = instruction[15:0];
    
    // Extract fields for J-type instructions
    assign link_reg = instruction[30:26];
    assign jump_address = instruction[25:0];
    
    // Determine instruction type based on opcode
    always @(*) begin
        // Default values
        is_r_type = 1'b0;
        is_i_type = 1'b0;
        is_j_type = 1'b0;
        
        case(opcode)
            6'b000000: is_r_type = 1'b1; // R-type operations
            
            // I-type operations
            6'b000001: is_i_type = 1'b1; // ADDI
            6'b000010: is_i_type = 1'b1; // SUBI
            6'b001000: is_i_type = 1'b1; // LW
            6'b001001: is_i_type = 1'b1; // SW
            6'b010010: is_i_type = 1'b1; // BEQ
            6'b010011: is_i_type = 1'b1; // BNE
            6'b011000: is_i_type = 1'b1; // LI
            
            // J-type operations
            6'b010000: is_j_type = 1'b1; // J
            
            default: begin
                // Unknown instruction type
                is_r_type = 1'b0;
                is_i_type = 1'b0;
                is_j_type = 1'b0;
            end
        endcase
    end

endmodule
