
module control_unit (
    input [5:0] opcode,           // Instruction opcode
    input [10:0] funct_r,         // Function field for R-type instructions
    input is_bne,                 // Is BNE instruction flag
    output reg reg_write,         // Register write enable
    output reg mem_read,          // Memory read enable
    output reg mem_write,         // Memory write enable
    output reg branch,           
    output reg jump,             
    output reg alu_src,        
    output reg mem_to_reg,        
    output reg [3:0] alu_op       
);

    // ALU Operations
    parameter ALU_ADD = 4'b0000; 
    parameter ALU_SUB = 4'b0001; 
    parameter ALU_SLT = 4'b0010;  
    parameter ALU_LI  = 4'b0011; 

    // Opcodes
    parameter R_TYPE = 6'b000000; 
    parameter ADDI   = 6'b000001; 
    parameter SUBI   = 6'b000010; 
    parameter LW     = 6'b001000;
    parameter SW     = 6'b001001; 
    parameter J      = 6'b010000; 
    parameter BEQ    = 6'b010010; 
    parameter BNE    = 6'b010011; 
    parameter LI     = 6'b011000; 

    // Function codes for R-type instructions
    parameter ADD_FUNCT = 11'b00000000001;
    parameter SUB_FUNCT = 11'b00000000010; 
    parameter SLT_FUNCT = 11'b00000001000; 

    // Control signal generation
    always @(*) begin
        // Default values
        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        branch = 1'b0;
        jump = 1'b0;
        alu_src = 1'b0;
        mem_to_reg = 1'b0;
        alu_op = 4'b0000;

        case (opcode)
            R_TYPE: begin
                // R-type instructions
                reg_write = 1'b1;     
                
                case (funct_r)
                    ADD_FUNCT: begin
                        alu_op = ALU_ADD;
                        $display("Control: R-type ADD instruction");
                    end
                    SUB_FUNCT: begin
                        alu_op = ALU_SUB;
                        $display("Control: R-type SUB instruction");
                    end
                    SLT_FUNCT: begin
                        alu_op = ALU_SLT;
                        $display("Control: R-type SLT instruction");
                    end
                    default: begin
                        alu_op = ALU_ADD;
                        $display("Control: Unknown R-type function: %b", funct_r);
                    end
                endcase
            end
            
            ADDI: begin
                // Add immediate
                reg_write = 1'b1;  
                alu_src = 1'b1;    
                alu_op = ALU_ADD;  
                $display("Control: ADDI instruction");
            end
            
            SUBI: begin
                // Subtract immediate
                reg_write = 1'b1;
                alu_src = 1'b1;   
                alu_op = ALU_SUB;
                $display("Control: SUBI instruction");
            end
            
            LW: begin
                // Load word
                reg_write = 1'b1;   
                mem_read = 1'b1;  
                alu_src = 1'b1;   
                mem_to_reg = 1'b1;  
                alu_op = ALU_ADD;  
                $display("Control: LW instruction");
            end
            
            SW: begin
                // Store word
                mem_write = 1'b1;   
                alu_src = 1'b1;    
                alu_op = ALU_ADD;  
                $display("Control: SW instruction");
            end
            
            J: begin
                // Jump
                jump = 1'b1;        
                $display("Control: J instruction");
            end
            
            BEQ: begin
                // Branch if equal
                branch = 1'b1;     
                alu_op = ALU_SUB;   
                $display("Control: BEQ instruction");
            end
            
            BNE: begin
                // Branch if not equal
                branch = 1'b1;      
                alu_op = ALU_SUB;   
                $display("Control: BNE instruction");
            end
            
            LI: begin
                // Load immediate
                reg_write = 1'b1;  
                alu_src = 1'b1;    
                alu_op = ALU_LI;    
                $display("Control: LI instruction");
            end
            
            default: begin
                // Unknown opcode - NOP
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                branch = 1'b0;
                jump = 1'b0;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                alu_op = 4'b0000;
                $display("Control: Unknown opcode: %b", opcode);
            end
        endcase
    end

endmodule
