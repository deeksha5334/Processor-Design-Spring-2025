
module instruction_memory (
    input [9:0] address,         
    output [36:0] instruction     
);


    reg [36:0] memory [0:1023];
    

    assign instruction = memory[address];
    


    initial begin

        integer i;
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = 37'b0;
        end
    end

endmodule
