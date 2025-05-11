
module data_memory (
    input clk,               
    input [9:0] address,     
    input [47:0] write_data,
    input mem_read,           
    input mem_write,         
    output reg [47:0] read_data  
);


    reg [47:0] memory [0:1023];
    

    always @(*) begin
        if (mem_read) begin
            read_data = memory[address];
            $display("Reading %d from memory address %h", memory[address], address);
        end else begin
            read_data = 48'b0;
        end
    end
    

    always @(posedge clk) begin
        if (mem_write) begin
            memory[address] <= write_data;
            $display("Writing %d to memory address %h", write_data, address);
        end
    end
    
endmodule
