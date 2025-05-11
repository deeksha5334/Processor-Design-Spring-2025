
module instruction_decoder (
    input [36:0] instruction,        
    output [5:0] opcode,         
    output [4:0] rs1,       
    output [4:0] rs2,         
    output [4:0] rd,                  
    output [4:0] shamt,         
    output [10:0] funct_r,            
    output [15:0] immediate,  
    output [25:0] jump_address,     
    output [4:0] link_reg,           
    output reg is_r_type,      
    output reg is_i_type,            
    output reg is_j_type           
);


    assign opcode = instruction[36:31];


    assign rs1 = instruction[30:26];
    assign rs2 = instruction[25:21];
    assign rd = instruction[20:16];
    assign shamt = instruction[15:11];
    assign funct_r = instruction[10:0];
    

    assign immediate = instruction[15:0];
    

    assign link_reg = instruction[30:26];
    assign jump_address = instruction[25:0];
    

    always @(*) begin
  
        is_r_type = 1'b0;
        is_i_type = 1'b0;
        is_j_type = 1'b0;
        
        case(opcode)
            6'b000000: is_r_type = 1'b1; 
            
  
            6'b000001: is_i_type = 1'b1; 
            6'b000010: is_i_type = 1'b1;
            6'b001000: is_i_type = 1'b1;
            6'b001001: is_i_type = 1'b1; 
            6'b010010: is_i_type = 1'b1; 
            6'b010011: is_i_type = 1'b1; 
            6'b011000: is_i_type = 1'b1; 
            
   
            6'b010000: is_j_type = 1'b1; 
            
            default: begin

                is_r_type = 1'b0;
                is_i_type = 1'b0;
                is_j_type = 1'b0;
            end
        endcase
    end

endmodule
