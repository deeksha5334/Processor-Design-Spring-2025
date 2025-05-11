
module program_counter (
    input clk,                     
    input reset,                 
    input branch,                 
    input jump,                   
    input zero,                
    input is_bne,           
    input [15:0] immediate,     
    input [25:0] jump_address,   
    output reg [9:0] pc         
);

   
    parameter PROGRAM_LOAD_ADDRESS = 10'h200;
    wire branch_taken;
    wire [9:0] branch_target;
    
    // Branch is taken if:
    // 1. For BEQ: branch=1 AND zero=1
    // 2. For BNE: branch=1 AND zero=0 AND is_bne=1
    assign branch_taken = branch && ((zero && !is_bne) || (!zero && is_bne));
    
 

    assign branch_target = pc + {{2{immediate[15]}}, immediate[13:0]};


    always @(posedge clk or posedge reset) begin
        if (reset) begin

            pc <= PROGRAM_LOAD_ADDRESS;
        end else begin
            if (jump) begin
 
             
                pc <= jump_address[9:0];
            end else if (branch_taken) begin
  
                pc <= branch_target;
            end else begin

                pc <= pc + 10'd1;
            end
        end
    end

endmodule
