// Fixed ALU module for the 37-bit ISA processor
module alu (
    input [3:0] alu_op,        // ALU operation code
    input [47:0] operand1,     // First operand
    input [47:0] operand2,     // Second operand
    output reg [47:0] result,  // Result of operation
    output zero                // Zero flag (1 if result is zero)
);

    // Zero flag is high when result is zero
    assign zero = (result == 48'b0);

    // ALU Operations as defined in the ISA
    parameter ALU_ADD = 4'b0000;   // Addition
    parameter ALU_SUB = 4'b0001;   // Subtraction
    parameter ALU_SLT = 4'b0010;   // Set Less Than
    parameter ALU_LI  = 4'b0011;   // Load Immediate (pass second operand)

    // ALU operation logic
    always @(*) begin
        // Debug output
        $display("ALU: op=%b, op1=%d, op2=%d", alu_op, operand1, operand2);
        
        case (alu_op)
            ALU_ADD: begin
                result = operand1 + operand2;
                $display("ALU ADD: %d + %d = %d", operand1, operand2, result);
            end
            ALU_SUB: begin
                result = operand1 - operand2;
                $display("ALU SUB: %d - %d = %d", operand1, operand2, result);
            end
            ALU_SLT: begin
                result = ($signed(operand1) < $signed(operand2)) ? 48'd1 : 48'd0;
                $display("ALU SLT: %d < %d = %d", operand1, operand2, result);
            end
            ALU_LI: begin
                result = operand2;
                $display("ALU LI: operand2 = %d", operand2);
            end
            default: begin
                result = 48'b0;
                $display("ALU: Unknown operation %b", alu_op);
            end
        endcase
    end

endmodule
