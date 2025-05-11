// Fixed Data memory module for the 37-bit ISA processor
module data_memory (
    input clk,                // Clock signal
    input [9:0] address,      // 10-bit address
    input [47:0] write_data,  // 48-bit data to write
    input mem_read,           // Memory read enable
    input mem_write,          // Memory write enable
    output reg [47:0] read_data   // 48-bit data read
);

    // Memory array (1024 locations x 48 bits)
    reg [47:0] memory [0:1023];
    
    // Read data from memory
    always @(*) begin
        if (mem_read) begin
            read_data = memory[address];
            $display("Reading %d from memory address %h", memory[address], address);
        end else begin
            read_data = 48'b0;
        end
    end
    
    // Write data to memory
    always @(posedge clk) begin
        if (mem_write) begin
            memory[address] <= write_data;
            $display("Writing %d to memory address %h", write_data, address);
        end
    end
    
endmodule
