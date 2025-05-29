module ysyx_25030093_top(
    input clk,
    output reg [31:0] pc,
    input wire [31:0] inst, 
    input wire rst
);
  

wire [1:0] pc_single; //控制pc +4 信号
wire [4:0] rd,rs1,rs2;
wire wen;//控制写入
wire wen_read;//控制读
wire [31:0] imm_data;


wire [5:0] alu_single;//alu 控制信号
wire [1:0] pc_single;
//输出控制信号
ysyx_25030093_IDU 

u_ysyx_25030093_IDU(
    .alu_single (alu_single),
    .pc_single (pc_single),
    .wen        (wen),
    .wen_read   (wen_read),
    .inst       (inst),
    .imm_data 	(imm_data  ),
    .rd         (rd),
    .rs1        (rs1),
    .rs2        (rs2)
);



wire [31:0] rs1_data;//read rs1
wire [31:0] rs2_data;//read rs2
wire [31:0] rd_data;
wire B_single;

ysyx_25030093_alu u_ysyx_25030093_alu(

    .alu_single  (alu_single),
    .imm_data       (imm_data),
    .pc             (pc),
    .rs1_data            (rs1_data),
    .rs2_data       (rs2_data),
    .rd_data      	(rd_data       ),
    .B_single        (B_single)
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



ysyx_25030093_pc u_ysyx_25030093_pc(
    .pc_single(pc_single),
    .imm_data (imm_data),
    .rs1_data (rs1_data),
    .clk        (clk),
    .pc       	(pc      ),
    .rst        (rst),
    .B_single    (B_single)
);


  








endmodule
