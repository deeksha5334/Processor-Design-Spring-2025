// Fixed Top-level CPU module for the 37-bit ISA processor
module cpu (
    input clk,                 // Clock signal
    input reset                // Reset signal
);

    // Program counter and instruction memory connections
    wire [9:0] pc;
    wire [36:0] instruction;
    
    // Instruction decoder signals
    wire [5:0] opcode;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [4:0] shamt;
    wire [10:0] funct_r;
    wire [15:0] immediate;
    wire [25:0] jump_address;
    wire [4:0] link_reg;
    wire is_r_type;
    wire is_i_type;
    wire is_j_type;
    
    // Control unit signals
    wire reg_write;
    wire mem_read;
    wire mem_write;
    wire branch;
    wire jump;
    wire alu_src;
    wire mem_to_reg;
    wire [3:0] alu_op;
    
    // Register file signals
    wire [47:0] rs1_data;
    wire [47:0] rs2_data;
    wire [47:0] write_data;
    
    // ALU signals
    wire [47:0] alu_in2;
    wire [47:0] alu_result;
    wire zero;
    
    // Data memory signals
    wire [47:0] mem_read_data;
    
    // Sign extension for immediate values
    wire [47:0] sign_extended_imm = {{32{immediate[15]}}, immediate};
    
    // Program counter module
    program_counter pc_unit (
        .clk(clk),
        .reset(reset),
        .branch(branch),
        .jump(jump),
        .zero(zero),
        .is_bne(opcode == 6'b010011), // BNE opcode
        .immediate(immediate),
        .jump_address(jump_address),
        .pc(pc)
    );
    
    // Instruction memory module
    instruction_memory imem (
        .address(pc),
        .instruction(instruction)
    );
    
    // Instruction decoder module
    instruction_decoder idec (
        .instruction(instruction),
        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .shamt(shamt),
        .funct_r(funct_r),
        .immediate(immediate),
        .jump_address(jump_address),
        .link_reg(link_reg),
        .is_r_type(is_r_type),
        .is_i_type(is_i_type),
        .is_j_type(is_j_type)
    );
    
    // Control unit module
    control_unit ctrl (
        .opcode(opcode),
        .funct_r(funct_r),
        .is_bne(opcode == 6'b010011), // BNE opcode
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .jump(jump),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op)
    );
    
    // Register file module
    register_file regfile (
        .clk(clk),
        .reset(reset),
        .rs1_addr(rs1),
        .rs2_addr(rs2),
        .rd_addr(rd),
        .rd_data(write_data),
        .reg_write(reg_write),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );
    
    // ALU source mux
    assign alu_in2 = alu_src ? sign_extended_imm : rs2_data;
    
    // ALU module
    alu alu_unit (
        .alu_op(alu_op),
        .operand1(rs1_data),
        .operand2(alu_in2),
        .result(alu_result),
        .zero(zero)
    );
    
    // Data memory module
    data_memory dmem (
        .clk(clk),
        .address(alu_result[9:0]),
        .write_data(rs2_data),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(mem_read_data)
    );
    
    // Memory to register mux
    assign write_data = mem_to_reg ? mem_read_data : alu_result;
    
    // Debug information
    always @(posedge clk) begin
        if (!reset) begin
            $display("==== CPU Cycle Information ====");
            $display("PC: %h", pc);
            $display("Instruction: %b", instruction);
            $display("Opcode: %b, RS1: %d, RS2: %d, RD: %d", opcode, rs1, rs2, rd);
            $display("reg_write: %b, mem_read: %b, mem_write: %b", reg_write, mem_read, mem_write);
            $display("RS1 Data: %d, RS2 Data: %d", rs1_data, rs2_data);
            $display("ALU Result: %d, Write Data: %d", alu_result, write_data);
            $display("==============================");
        end
    end

endmodule
