module ysyx_25030093_WBU #(ADDR_WIDTH = 5, DATA_WIDTH = 32)(
  input clk,
  input [DATA_WIDTH-1:0] wdata,
  input [ADDR_WIDTH-1:0] waddr,
  input wen,
  input [5:0] alu_single,
  input wen_read,
 output [DATA_WIDTH-1:0] rs1_data,
 input [ADDR_WIDTH-1:0] rs1_addr,
 output [DATA_WIDTH-1:0] rs2_data,
 input [ADDR_WIDTH-1:0] rs2_addr,
 output wire [31:0] csr_data,
  output wire [31:0] csr_data_pc,
  input [31:0] imm_csr,
  input ecall_single,
  input [31:0] ecall_now_pc,
  input [31:0] csr_wdata,
  output wen_csr
);


//寄存器写入和读取模块
ysyx_25030093_Register u_ysyx_25030093_Register(
    .clk      	(clk       ),
    .wdata    	(rd_data     ),
    .waddr    	(rd     ),
    .wen      	(wen       ),
    .wen_read   (wen_read),
    .rs1_data 	(rs1_data  ),
    .rs1_addr 	(rs1  ),
    .rs2_data   (rs2_data),
    .rs2_addr   (rs2)

);
// output declaration of module ysyx_25030093_CSR_REG

ysyx_25030093_CSR_REG u_ysyx_25030093_CSR_REG(
    .clk          	(clk           ),
    .rst          	(rst           ),
    .csr_data     	(csr_data      ),
    .csr_data_pc  	(csr_data_pc   ),
    .imm_csr      	(imm_data      ),
    .ecall_single 	(ecall_single  ),
    .ecall_now_pc 	(pc  ),
    .csr_wdata    	(csr_wdata     ),
    .wen_csr        (wen_csr)
);



endmodule