`timescale 1ns/1ps
module tb_program1;
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
        
        // Apply reset for a few clock cycles
        #20;
        reset = 0;
        
        // Initialize instruction memory with program
        // Program: C = A + B
        
        // 1. LI $s1, 16 - Load immediate 16 (0x10) to $s1 for address A
        // Opcode: LI = 011000, rs = 0, rd = $s1 (17), immediate = 16
        dut.imem.memory[10'h200] = {6'b011000, 5'd0, 5'd17, 5'd0, 16'd16};
        
        // 2. LI $s2, 32 - Load immediate 32 (0x20) to $s2 for address B
        // Opcode: LI = 011000, rs = 0, rd = $s2 (18), immediate = 32
        dut.imem.memory[10'h201] = {6'b011000, 5'd0, 5'd18, 5'd0, 16'd32};
        
        // 3. LI $s3, 48 - Load immediate 48 (0x30) to $s3 for address C
        // Opcode: LI = 011000, rs = 0, rd = $s3 (19), immediate = 48
        dut.imem.memory[10'h202] = {6'b011000, 5'd0, 5'd19, 5'd0, 16'd48};
        
        // 4. LW $s0, 0($s1) - Load from address in $s1 (0x10) to $s0
        // Opcode: LW = 001000, rs = $s1 (17), rd = $s0 (16), immediate = 0
        dut.imem.memory[10'h203] = {6'b001000, 5'd17, 5'd16, 5'd0, 16'd0};
        
        // 5. LW $s4, 0($s2) - Load from address in $s2 (0x20) to $s4
        // Opcode: LW = 001000, rs = $s2 (18), rd = $s4 (20), immediate = 0
        dut.imem.memory[10'h204] = {6'b001000, 5'd18, 5'd20, 5'd0, 16'd0};
        
        // 6. ADD $s5, $s0, $s4 - Add $s0 and $s4, store in $s5
        // Opcode: R-type = 000000, rs1 = $s0 (16), rs2 = $s4 (20), rd = $s5 (21), shamt = 0, funct = 1 (ADD)
        dut.imem.memory[10'h205] = {6'b000000, 5'd16, 5'd20, 5'd21, 5'd0, 11'b00000000001};
        
        // 7. SW $s5, 0($s3) - Store $s5 to address in $s3 (0x30)
        // Opcode: SW = 001001, rs = $s3 (19), rd = $s5 (21), immediate = 0
        dut.imem.memory[10'h206] = {6'b001001, 5'd19, 5'd21, 5'd0, 16'd0};
        
        // Initialize data memory
        dut.dmem.memory[16] = 48'd20;  // Value at address A (0x10)
        dut.dmem.memory[32] = 48'd22;  // Value at address B (0x20)
        
        // Run simulation for enough cycles to complete the program
        // We need 7 instructions * ~3-5 cycles each = ~35 cycles, so 50 should be enough
        #500;
        
        // Display debugging information
        $display("Initial Memory:");
        $display("Memory A (0x10/16): %d", dut.dmem.memory[16]);
        $display("Memory B (0x20/32): %d", dut.dmem.memory[32]);
        $display("Final register values:");
        $display("Register $s0 (16): %d", dut.regfile.registers[16]);
        $display("Register $s1 (17): %d", dut.regfile.registers[17]);
        $display("Register $s2 (18): %d", dut.regfile.registers[18]);
        $display("Register $s3 (19): %d", dut.regfile.registers[19]);
        $display("Register $s4 (20): %d", dut.regfile.registers[20]);
        $display("Register $s5 (21): %d", dut.regfile.registers[21]);
        
        // Check results
        if (dut.dmem.memory[48] == 48'd42) begin
            $display("Program 1 TEST PASSED: (C) = %d", dut.dmem.memory[48]);
        end else begin
            $display("Program 1 TEST FAILED: Expected (C) = 42, got %d", dut.dmem.memory[48]);
            $display("Memory C (0x30/48): %d", dut.dmem.memory[48]);
        end
        
        // End simulation
        #10 $finish;
    end
endmodule
