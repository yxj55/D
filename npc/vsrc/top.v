module ysyx_25030093_top(
    input clk,
    output reg [31:0] pc,
    output reg [31:0] inst, 
    input wire rst
);
import "DPI-C" function int paddr_read(input int raddr,input int len);
 assign inst = paddr_read(pc,4);


// // output declaration of module ysyx_25030093_IFU
// wire valid;

// ysyx_25030093_IFU u_ysyx_25030093_IFU(
//     .clk   	(clk    ),
//     .rst   	(rst    ),
//     .valid 	(valid  ),
//     .ready 	(ready  ),
//     .inst  	(inst   ),
//     .pc    	(pc     )
// );





wire [31:0] inst_wire = inst;
wire [2:0] pc_single; //控制pc +4 信号
wire [4:0] rd,rs1,rs2;

wire wen;//控制写入
wire wen_read;//控制读
wire [31:0] imm_data;

wire wen_csr;
wire [31:0] csr_data;
wire [31:0] csr_data_pc;
wire [31:0] csr_wdata;

wire ecall_single;
wire [4:0] alu_single;//alu 控制信号
//输出控制信号
ysyx_25030093_IDU 

u_ysyx_25030093_IDU(
    .imm_or_rs2_other (imm_or_rs2_other),
    .rs1_pc_other (rs1_pc_other),
    .ready      (ready),
    .valid      (valid),
    .alu_single (alu_single),
    .pc_single (pc_single),
    .wen        (wen),
    .wen_read   (wen_read),
    .inst       (inst_wire),
    .imm_data 	(imm_data  ),
    .rd         (rd),
    .rs1        (rs1),
    .rs2        (rs2),
    .ecall_single      (ecall_single),
    .wen_csr (wen_csr)
);



wire [31:0] rs1_data;//read rs1
wire [31:0] rs2_data;//read rs2
wire [31:0] rd_data;
wire B_single;

wire [31:0] alu_data2;
wire [31:0] alu_data1;


ysyx_25030093_alu u_ysyx_25030093_alu(
    .alu_single  (alu_single),
    .rs2_data       (rs2_data),
    .rd_data      	(rd_data       ),
    
    .B_single        (B_single),
     .csr_data   (csr_data),
    .csr_wdata  (csr_wdata),
    .alu_data2  (alu_data2),
    .alu_data1  ( alu_data1)
);


wire [1:0] imm_or_rs2_other;

ysyx_25030093_mux41 imm_data_or_rs2_data_mux41(
    .a 	(imm_data  ),
    .b 	(rs2_data  ),
    .y 	(alu_data2  ),
    .s 	(imm_or_rs2_other  )
);

wire [1:0] rs1_pc_other;


ysyx_25030093_mux41 u_ysyx_25030093_mux41(
    .a 	(rs1_data  ),
    .b 	(pc  ),
    .y 	(alu_data1  ),
    .s 	(rs1_pc_other  )
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



ysyx_25030093_pc u_ysyx_25030093_pc(
    .pc_single(pc_single),
    .imm_data (imm_data),
    .rs1_data (rs1_data),
    .clk        (clk),
    .pc       	(pc      ),
    .rst        (rst),
    .B_single    (B_single),
    .csr_data_pc (csr_data_pc),
    .inst         (inst_wire)
);


  








endmodule
