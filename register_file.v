
module register_file (
    input clk,                 
    input reset,              
    input [4:0] rs1_addr,     
    input [4:0] rs2_addr,     
    input [4:0] rd_addr,       
    input [47:0] rd_data,      
    input reg_write,          
    output [47:0] rs1_data,    
    output [47:0] rs2_data     
);


    reg [47:0] registers [0:31];
    integer i;


    assign rs1_data = (rs1_addr == 5'b0) ? 48'b0 : registers[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 48'b0 : registers[rs2_addr];

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin

            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 48'b0;
            end
        end else if (reg_write && rd_addr != 5'b0) begin

            registers[rd_addr] <= rd_data;
        end
    end

endmodule
