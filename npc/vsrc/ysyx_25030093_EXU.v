module ysyx_25030093_EXU(
    input clk,
    input [31:0] imm_data,
    input Regwrite,
    input [4:0] rd,
    input [4:0] rs1
);
wire [31:0] rs1_data_reg; // 从寄存器堆读取的 rs1_data
wire [31:0] rd_data;
ysyx_25030093_Register u_Register(
    .clk      (clk),
    .wen      (Regwrite),
    .wdata    (rd_data),
    .waddr    (rd),
    .rs1_addr (rs1),
    .rs1_data (rs1_data_reg)  // 读取 rs1 的值
);

ysyx_25030093_addi u_addi(
    .rs1_data (rs1_data_reg),  // 传入正确的 rs1_data
    .imm_data (imm_data),
    .rd_data  (rd_data)
);
endmodule
