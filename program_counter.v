// Program counter module for the 37-bit ISA processor
module program_counter (
    input clk,                     // Clock signal
    input reset,                   // Reset signal
    input branch,                  // Branch control signal
    input jump,                    // Jump control signal
    input zero,                    // Zero flag from ALU
    input is_bne,                  // Is BNE instruction
    input [15:0] immediate,        // Immediate value for branches
    input [25:0] jump_address,     // Jump address
    output reg [9:0] pc            // 10-bit program counter
);

    // Program load address is 0x200 (512 in decimal)
    parameter PROGRAM_LOAD_ADDRESS = 10'h200;
    wire branch_taken;
    wire [9:0] branch_target;
    
    // Branch is taken if:
    // 1. For BEQ: branch=1 AND zero=1
    // 2. For BNE: branch=1 AND zero=0 AND is_bne=1
    assign branch_taken = branch && ((zero && !is_bne) || (!zero && is_bne));
    
    // Calculate branch target: PC + sign-extended immediate
    // Note: Immediate value is already in the correct format from the instruction
    assign branch_target = pc + {{2{immediate[15]}}, immediate[13:0]};

    // PC update logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset PC to program load address
            pc <= PROGRAM_LOAD_ADDRESS;
        end else begin
            if (jump) begin
                // Jump instruction - set PC to jump address
                // Use only lower 10 bits of jump address
                pc <= jump_address[9:0];
            end else if (branch_taken) begin
                // Branch taken - set PC to branch target
                pc <= branch_target;
            end else begin
                // Normal execution - increment PC
                pc <= pc + 10'd1;
            end
        end
    end

endmodule
