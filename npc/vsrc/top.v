
module ysyx_25030093_top(
    input                clk,
    output reg [31:0]    pc,
    output reg [31:0]    inst, 
    input wire           rst,
    output               inst_done
);


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


//------------------------------------------//

assign inst_done = out_valid_WBU;



// IFU
//------------------------------------------//
 ysyx_25030093_IFU u_ysyx_25030093_IFU(
    .in_valid  (out_valid_WBU),
     .clk   	(clk    ),
     .rst   	(rst    ),
     .valid 	(out_valid_IFU  ),
     .ready 	(out_ready_IDU_IFU  ),
     .inst_wire  	(inst   ),
     .pc    	(pc     ),
     .IFU_SRAM_araddr (IFU_SRAM_araddr),
     .IFU_SRAM_arvalid (IFU_SRAM_arvalid),
     .IFU_SRAM_rready  (IFU_SRAM_rready),
     .SRAM_IFU_arready (SRAM_IFU_arready),
     .SRAM_IFU_rdata   (SRAM_IFU_rdata),
     .SRAM_IFU_rvalid  (SRAM_IFU_rvalid)
 );

//------------------------------------------//
//IFU_SRAM
wire SRAM_IFU_arready;
wire SRAM_IFU_rvalid;
wire [31:0] SRAM_IFU_rdata;
wire [31:0] IFU_SRAM_araddr;
wire IFU_SRAM_arvalid;
wire IFU_SRAM_rready;


wire SRAM_IFU_awready;
wire SRAM_IFU_wready;
wire SRAM_IFU_bvalid;

ysyx_25030093_SRAM IFU_ysyx_25030093_SRAM(
    .SRAM_arvalid 	(IFU_SRAM_arvalid  ),
    .SRAM_araddr  	(IFU_SRAM_araddr   ),
    .SRAM_rready  	(IFU_SRAM_rready   ),
    .SRAM_rdata   	(SRAM_IFU_rdata    ),
    .SRAM_rvalid  	(SRAM_IFU_rvalid   ),
    .SRAM_arready 	(SRAM_IFU_arready  ),
    .SRAM_awaddr  	(32'd0   ),
    .SRAM_wdata   	(32'd0    ),
    .SRAM_wstrb   	(8'd0   ),
    .SRAM_awvalid 	(1'b0 ),
    .SRAM_wvalid  	( 1'b0 ),
    .SRAM_bready  	(1'b0 ),
    .SRAM_awready 	( SRAM_IFU_awready),
    .SRAM_wready  	(SRAM_IFU_wready ),
    .SRAM_bvalid  	( SRAM_IFU_bvalid ),
    .clk          	(clk           )
);







//------------------------------------------//
wire [31:0] inst_wire;
assign inst_wire = inst;

//------------------------------------------//


wire [2:0] pc_single; //控制pc +4 信号
wire [4:0] rd,rs1,rs2;

wire rd_or_LSU_single;
wire [3:0] LSU_single;
wire wen;//控制写入
wire wen_read;//控制读
wire [31:0] imm_data;

wire wen_csr;
wire [31:0] csr_data;
wire [31:0] csr_data_pc;
wire [31:0] csr_wdata;


wire ecall_single;
wire [4:0] alu_single;//alu 控制信号

//------------------------------------------//

//IDU
//输出控制信号
ysyx_25030093_IDU 

u_ysyx_25030093_IDU(
    .imm_or_rs2_other (imm_or_rs2_other),
    .rs1_pc_other (rs1_pc_other),
    .out_valid      (out_valid_IDU_EXU),
    .out_ready      (out_ready_IDU_IFU),
    .in_valid      (out_valid_IFU),
    .in_ready       (out_ready_EXU_IDU),
    .alu_single (alu_single),
    .pc_single (pc_single),
    .wen        (wen),
    .wen_read   (wen_read),
    .inst_wire       (inst_wire),
    .imm_data 	(imm_data  ),
    .rd         (rd),
    .rs1        (rs1),
    .rs2        (rs2),
    .ecall_single      (ecall_single),
    .wen_csr (wen_csr),
    .clk    (clk),
    .rst    (rst),
    .LSU_single (LSU_single),
    .rd_or_LSU_single (rd_or_LSU_single),
    .wstrb      (wstrb),
    .LOAD_single    (LOAD_single),
    .STORE_single   (STORE_single)
);

//------------------------------------------//

wire [31:0] rs1_data;//read rs1
wire [31:0] rs2_data;//read rs2
wire [31:0] rd_data;
wire B_single;

wire [31:0] alu_data2;
wire [31:0] alu_data1;

//------------------------------------------//
ysyx_25030093_EXU u_ysyx_25030093_EXU(
    .in_valid       (out_valid_IDU_EXU),
    .in_ready       (out_ready_LSU_EXU),
    .out_ready      (out_ready_EXU_IDU),
    .out_valid      (out_valid_EXU_LSU),
    .clk           (clk),
    .rst            (rst),
    .alu_single  (alu_single),
    .rd_data      	(rd_data       ),
    
    .B_single        (B_single),
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
    .a 	(imm_data  ),
    .b 	(rs2_data  ),
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

wire [7:0] wstrb;
wire LOAD_single;
wire STORE_single;

//LSU
ysyx_25030093_LSU u_ysyx_25030093_LSU(
    .in_valid    	(out_valid_EXU_LSU     ),
    .in_ready       (out_ready_WBU_LSU),
    .out_ready      (out_ready_LSU_EXU),
    .out_valid      (out_valid_LSU_WBU),
    .rd_data    	(rd_data     ),
    .rs2_data   	(rs2_data    ),
    .LSU_data   	(LSU_data    ),
    .LSU_single 	(LSU_single  ),
    .clk        	(clk         ),
    .rst            (rst),
    .wstrb          (wstrb),
    .LOAD_single    (LOAD_single),
    .STORE_single   (STORE_single),
    .LSU_SRAM_araddr(LSU_SRAM_araddr),
    .LSU_SRAM_arvalid(LSU_SRAM_arvalid),
    .LSU_SRAM_rready (LSU_SRAM_rready),
    .SRAM_LSU_rdata     (SRAM_LSU_rdata),
    .SRAM_LSU_arready  (SRAM_LSU_arready),
    .SRAM_LSU_rvalid    (SRAM_LSU_rvalid),
    .LSU_SRAM_awaddr (LSU_SRAM_awaddr),
    .LSU_SRAM_awvalid (LSU_SRAM_awvalid),
    .LSU_SRAM_wstrb (LSU_SRAM_wstrb),
    .LSU_SRAM_wvalid (LSU_SRAM_wvalid),
    .LSU_SRAM_bready (LSU_SRAM_bready),
    .LSU_SRAM_wdata (LSU_SRAM_wdata),
    .SRAM_LSU_awready (SRAM_LSU_awready),
    .SRAM_LSU_wready (SRAM_LSU_wready),
    .SRAM_LSU_bvalid (SRAM_LSU_bvalid)
);

//------------------------------------------//

//LSU_SRAM
wire [31:0] SRAM_LSU_rdata;
wire [31:0] LSU_SRAM_araddr;
wire LSU_SRAM_arvalid;
wire LSU_SRAM_rready;
wire SRAM_LSU_arready;
wire SRAM_LSU_rvalid;

wire LSU_SRAM_bready;
wire LSU_SRAM_wvalid;
wire LSU_SRAM_awvalid;
wire [31:0] LSU_SRAM_awaddr;
wire [31:0] LSU_SRAM_wdata;
wire [7:0]  LSU_SRAM_wstrb;
wire SRAM_LSU_awready;
wire SRAM_LSU_wready;
wire SRAM_LSU_bvalid;


ysyx_25030093_SRAM LSU_ysyx_25030093_SRAM(
    .SRAM_arvalid 	(LSU_SRAM_arvalid  ),
    .SRAM_araddr  	(LSU_SRAM_araddr   ),
    .SRAM_rready  	(LSU_SRAM_rready   ),
    .SRAM_rdata   	(SRAM_LSU_rdata    ),
    .SRAM_rvalid  	(SRAM_LSU_rvalid   ),
    .SRAM_arready 	(SRAM_LSU_arready  ),
    .SRAM_awaddr  	(LSU_SRAM_awaddr   ),
    .SRAM_wdata   	(LSU_SRAM_wdata    ),
    .SRAM_wstrb   	(LSU_SRAM_wstrb    ),
    .SRAM_awvalid 	(LSU_SRAM_awvalid  ),
    .SRAM_wvalid  	(LSU_SRAM_wvalid   ),
    .SRAM_bready  	(LSU_SRAM_bready   ),
    .SRAM_awready 	(SRAM_LSU_awready  ),
    .SRAM_wready  	(SRAM_LSU_wready   ),
    .SRAM_bvalid  	(SRAM_LSU_bvalid   ),
    .clk          	(clk           )
);







//------------------------------------------//

//寄存器写入和读取模块
ysyx_25030093_Register u_ysyx_25030093_Register(
    .in_valid   (out_valid_WBU),
    .clk      	(clk       ),
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
ysyx_25030093_CSR_REG u_ysyx_25030093_CSR_REG(
    .clk          	(clk           ),
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

ysyx_25030093_WBU u_ysyx_25030093_WBU(
    .rst            (rst),
    .clk          	(clk           ),
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

ysyx_25030093_pc u_ysyx_25030093_pc(
    .in_valid_WBU   (out_valid_WBU),
    .pc_single(pc_single),
    .imm_data (imm_data),
    .rs1_data (rs1_data),
    .clk        (clk),
    .pc       	(pc      ),
    .rst        (rst),
    .B_single    (B_single),
    .csr_data_pc (csr_data_pc),
    .inst         (inst)
);


  //------------------------------------------//








endmodule
