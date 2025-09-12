
module ysyx_25030093(
    input                clock,
    input wire           reset,

    output               io_ifu_reqValid,
    output  [31:0]       io_ifu_addr,
    input                io_ifu_respValid, 
    input   [31:0]       io_ifu_rdata,     

    output               io_lsu_reqValid,  
    output  [31:0]       io_lsu_addr,      
    output  [1:0]        io_lsu_size,      
    output               io_lsu_wen,       
    output  [31:0]       io_lsu_wdata,     
    output  [3:0]        io_lsu_wmask,     
    input                io_lsu_respValid, 
    input   [31:0]       io_lsu_rdata     

);
import "DPI-C" function void get_pc(input int pc);
import "DPI-C" function void get_inst_done(input bit inst_done);
reg [31:0] pc;
wire inst_done = out_valid_WBU;
always@(*)begin
    get_pc(pc);
end
always@(*)begin
    get_inst_done(inst_done);
end

wire [31:0] inst_wire;

//------------------------------------------//
wire out_valid_IFU;
wire out_valid_IDU_EXU;
wire out_ready_IDU_IFU;
wire out_ready_EXU_IDU;
wire out_valid_EXU_LSU;
wire out_valid_LSU_WBU;
wire out_ready_LSU_EXU;
wire out_ready_WBU_LSU;
wire out_valid_WBU;
wire out_valid_pc;


// IFU
//------------------------------------------//

 ysyx_25030093_IFU IFU(
    .in_valid               (out_valid_pc),
     .clock             	(clock    ),
     .reset   	            (reset    ),
     .valid 	            (out_valid_IFU  ),
     .ready 	            (out_ready_IDU_IFU  ),
     .inst_wire  	        (inst_wire   ),
     .pc    	            (pc     ),
     .IFU_addr              (io_ifu_addr),
     .IFU_rdata             (io_ifu_rdata),
     .IFU_reqValid          (io_ifu_reqValid),
     .IFU_respValid         (io_ifu_respValid)
 );


//------------------------------------------//


wire [1:0] pc_single; //控制pc +4 信号
wire [4:0] rd,rs1,rs2;

wire rd_or_LSU_single;
wire [2:0] LSU_single;
wire wen;//控制写入
wire wen_read;//控制读
wire [31:0] imm_data;

wire wen_csr;
wire [31:0] csr_data;
wire [31:0] csr_data_pc;
wire [31:0] csr_wdata;


wire ecall_single;
wire [1:0] alu_single;//alu 控制信号

//------------------------------------------//

//IDU
//输出控制信号
ysyx_25030093_IDU 

IDU(
    .imm_or_rs2_other (imm_or_rs2_other),
    .rs1_pc_other     (rs1_pc_other),
    .out_valid        (out_valid_IDU_EXU),
    .out_ready        (out_ready_IDU_IFU),
    .in_valid         (out_valid_IFU),
    .in_ready         (out_ready_EXU_IDU),
    .alu_single       (alu_single),
    .pc_single        (pc_single),
    .wen              (wen),
    .wen_read         (wen_read),
    .inst_wire        (inst_wire),
    .imm_data 	      (imm_data  ),
    .rd               (rd),
    .rs1              (rs1),
    .rs2              (rs2),
    .ecall_single     (ecall_single),
    .wen_csr          (wen_csr),
    .clock              (clock),
    .reset              (reset),
    .LSU_single       (LSU_single),
    .rd_or_LSU_single (rd_or_LSU_single)
);

//------------------------------------------//

wire [31:0] rs1_data;//read rs1
wire [31:0] rs2_data;//read rs2
wire [31:0] rd_data;

wire [31:0] alu_data2;
wire [31:0] alu_data1;

//------------------------------------------//
ysyx_25030093_EXU EXU(
    .in_valid       (out_valid_IDU_EXU),
    .in_ready       (out_ready_LSU_EXU),
    .out_ready      (out_ready_EXU_IDU),
    .out_valid      (out_valid_EXU_LSU),
    .clock           (clock),
    .reset            (reset),
    .alu_single  (alu_single),
    .rd_data      	(rd_data       ),
     .csr_data   (csr_data),
    .csr_wdata  (csr_wdata),
    .alu_data2  (alu_data2),
    .alu_data1  ( alu_data1)
);

//------------------------------------------//
wire [31:0] LSU_data;

//------------------------------------------//
//MUX_single

wire [1:0] rs1_pc_other;
wire [1:0] imm_or_rs2_other;
//MUX
//------------------------------------------//


ysyx_25030093_mux41 imm_data_or_rs2_data_mux41(
    .a 	(rs2_data  ),
    .b 	(imm_data  ),
    .y 	(alu_data2  ),
    .s 	(imm_or_rs2_other  )
);

ysyx_25030093_mux41 u_ysyx_25030093_mux41(
    .a 	(rs1_data  ),
    .b 	(pc  ),
    .y 	(alu_data1  ),
    .s 	(rs1_pc_other  )
);
//------------------------------------------//



//LSU
ysyx_25030093_LSU LSU(
    .in_valid    	  (out_valid_EXU_LSU     ),
    .in_ready         (out_ready_WBU_LSU),
    .out_ready        (out_ready_LSU_EXU),
    .out_valid        (out_valid_LSU_WBU),
    .rd_data    	  (rd_data     ),
    .rs2_data   	  (rs2_data    ),
    .LSU_data   	  (LSU_data    ),
    .LSU_single 	  (LSU_single  ),
    .clock        	  (clock         ),
    .reset              (reset),
    .lsu_addr           (io_lsu_addr),
    .lsu_rdata          (io_lsu_rdata),
    .lsu_reqValid       (io_lsu_reqValid),
    .lsu_respValid      (io_lsu_respValid),
    .lsu_size           (io_lsu_size),
    .lsu_wdata          (io_lsu_wdata),
    .lsu_wen            (io_lsu_wen),
    .lsu_wmask          (io_lsu_wmask)
);



//------------------------------------------//

//寄存器写入和读取模块
ysyx_25030093_Register Register(
    .in_valid   (out_valid_WBU),
    .clock      	(clock       ),
    .wdata    	(WBU_data    ),
    .waddr    	(rd     ),
    .wen      	(wen       ),
    .wen_read   (wen_read),
    .rs1_data 	(rs1_data  ),
    .rs1_addr 	(rs1  ),
    .rs2_data   (rs2_data),
    .rs2_addr   (rs2)

);
//------------------------------------------//
//CSR_REG
ysyx_25030093_CSR_REG CSR_REG(
    .clock          	(clock           ),
    .csr_data     	(csr_data      ),
    .csr_data_pc  	(csr_data_pc   ),
    .imm_csr      	(imm_data      ),
    .ecall_single 	(ecall_single  ),
    .ecall_now_pc 	(pc  ),
    .csr_wdata    	(csr_wdata     ),
    .wen_csr        (wen_csr),
    .in_valid       (out_valid_WBU)
);



//WBU
//------------------------------------------//

wire [31:0] WBU_data;

ysyx_25030093_WBU WBU(
    .reset            (reset),
    .clock          	(clock           ),
    .rd_data    	(rd_data     ),
    .LSU_data   	(LSU_data    ),
    .rd_or_LSU_single	(rd_or_LSU_single  ),
    .in_valid           (out_valid_LSU_WBU),
    .out_ready      (out_ready_WBU_LSU),
    .out_valid          (out_valid_WBU),
    .WBU_data           (WBU_data)
);

//PC
//------------------------------------------//

ysyx_25030093_pc npc(
    .in_valid_WBU   (out_valid_WBU),
    .pc_single(pc_single),
    .imm_data (imm_data),
    .rs1_data (rs1_data),
    .clock        (clock),
    .pc       	(pc      ),
    .reset        (reset),
    .csr_data_pc (csr_data_pc),
    .inst         (inst_wire),
    .out_valid_pc (out_valid_pc)
);


  //------------------------------------------//


endmodule
