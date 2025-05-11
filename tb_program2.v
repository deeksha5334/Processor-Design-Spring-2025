`timescale 1ns/1ps
module tb_program2;
    // Inputs
    reg clk;
    reg reset;
    
    // Instantiate the CPU
    cpu dut (
        .clk(clk),
        .reset(reset)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end
    
    // Test procedure
    initial begin
        // Initialize inputs
        reset = 1;
        

        #20;
        reset = 0;
        
        // Initialize instruction memory with program
        // Program 2: Sum from 0 to 10
        // int sum = 0;
        // for (i = 0; i <= 10; i++) {
        //     sum += i;
        // }
        
        // Register allocations:
        // $s0 (16): sum
        // $s1 (17): i
        // $s2 (18): constant 10 (loop end condition)
        // $s3 (19): constant 1 (increment)
        
        // 1. Initialize sum = 0
        // LI $s0, 0 - Load immediate 0 to $s0
        dut.imem.memory[10'h200] = {6'b011000, 5'd0, 5'd16, 5'd0, 16'd0};
        
        // 2. Initialize i = 0
        // LI $s1, 0 - Load immediate 0 to $s1
        dut.imem.memory[10'h201] = {6'b011000, 5'd0, 5'd17, 5'd0, 16'd0};
        
        // 3. Initialize constant 10
        // LI $s2, 10 - Load immediate 10 to $s2
        dut.imem.memory[10'h202] = {6'b011000, 5'd0, 5'd18, 5'd0, 16'd10};
        
        // 4. Initialize constant 1
        // LI $s3, 1 - Load immediate 1 to $s3
        dut.imem.memory[10'h203] = {6'b011000, 5'd0, 5'd19, 5'd0, 16'd1};
        
        // 5. LOOP: Check if i > 10
        // SLT $s4, $s2, $s1 - Set $s4 = 1 if $s2 < $s1 (10 < i)
        dut.imem.memory[10'h204] = {6'b000000, 5'd18, 5'd17, 5'd20, 5'd0, 11'b00000001000};
        
        // 6. Branch if i > 10
        // BNE $s4, $0, END - Branch to END if $s4 != 0
        dut.imem.memory[10'h205] = {6'b010011, 5'd20, 5'd0, 16'd4};
        
        // 7. Add i to sum
        // ADD $s0, $s0, $s1 - $s0 = $s0 + $s1 (sum = sum + i)
        dut.imem.memory[10'h206] = {6'b000000, 5'd16, 5'd17, 5'd16, 5'd0, 11'b00000000001};
        
        // 8. Increment i
        // ADD $s1, $s1, $s3 - $s1 = $s1 + $s3 (i = i + 1)
        dut.imem.memory[10'h207] = {6'b000000, 5'd17, 5'd19, 5'd17, 5'd0, 11'b00000000001};
        
        // 9. Jump back to LOOP
        // J LOOP - Jump to loop start
        dut.imem.memory[10'h208] = {6'b010000, 5'd0, 26'h204};
        
        // 10. END: Store result to memory
        // SW $s0, 0($0) - Store $s0 to address 0
        dut.imem.memory[10'h209] = {6'b001001, 5'd0, 5'd16, 5'd0, 16'd100};
        
        // Run simulation for enough cycles
        // Loop executes 11 times (i = 0 to 10), with multiple instructions per loop
        // So we need many cycles
        #2000;
        
        // Check results
        // Expected sum: 0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10 = 55
        if (dut.dmem.memory[100] == 48'd55) begin
            $display("Program 2 TEST PASSED: Sum = %d", dut.dmem.memory[100]);
        end else begin
            $display("Program 2 TEST FAILED: Expected Sum = 55, got %d", dut.dmem.memory[100]);
        end
        
        // Display register values for debugging
        $display("Final register values:");
        $display("Register $s0 (16) - sum: %d", dut.regfile.registers[16]);
        $display("Register $s1 (17) - i: %d", dut.regfile.registers[17]);
        $display("Register $s2 (18) - constant 10: %d", dut.regfile.registers[18]);
        $display("Register $s3 (19) - constant 1: %d", dut.regfile.registers[19]);
        $display("Register $s4 (20) - comparison result: %d", dut.regfile.registers[20]);
        
        // End simulation
        #10 $finish;
    end
endmodule
