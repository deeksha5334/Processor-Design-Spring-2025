// Register file module for the 37-bit ISA processor
module register_file (
    input clk,                 // Clock signal
    input reset,               // Reset signal
    input [4:0] rs1_addr,      // Source register 1 address
    input [4:0] rs2_addr,      // Source register 2 address
    input [4:0] rd_addr,       // Destination register address
    input [47:0] rd_data,      // Data to write to destination register
    input reg_write,           // Register write enable
    output [47:0] rs1_data,    // Source register 1 data
    output [47:0] rs2_data     // Source register 2 data
);

    // 32 registers, each 48 bits wide
    reg [47:0] registers [0:31];
    integer i;

    // Read data from registers
    assign rs1_data = (rs1_addr == 5'b0) ? 48'b0 : registers[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 48'b0 : registers[rs2_addr];

    // Register 0 is hardwired to 0
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers to 0
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 48'b0;
            end
        end else if (reg_write && rd_addr != 5'b0) begin
            // Write data to register if reg_write is enabled and not writing to $zero
            registers[rd_addr] <= rd_data;
        end
    end

endmodule
