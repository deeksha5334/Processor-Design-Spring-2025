// Instruction memory module for the 37-bit ISA processor
module instruction_memory (
    input [9:0] address,           // 10-bit address
    output [36:0] instruction      // 37-bit instruction
);

    // Memory array to store instructions (1024 locations x 37 bits)
    reg [36:0] memory [0:1023];
    
    // Read instruction from memory
    assign instruction = memory[address];
    
    // Initialize memory with instructions
    // This will be overridden by the test bench for different programs
    initial begin
        // Initialize all memory to NOP (all zeros)
        integer i;
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = 37'b0;
        end
    end

endmodule
