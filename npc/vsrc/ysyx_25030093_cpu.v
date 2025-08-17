
module ysyx_25030093_cpu(
    input                clock,
    input wire           reset,
    input                io_interrupt,

//Master信号
//--------------------写地址----------------------//
    input  wire                  io_master_awready,
    output wire                  io_master_awvalid,
    output wire        [31:0]    io_master_awaddr,
    output wire        [3:0]     io_master_awid,
    output wire        [7:0]     io_master_awlen,
    output wire        [2:0]     io_master_awsize,
    output wire        [1:0]     io_master_awburst,
//--------------------写数据----------------------//   
    input  wire                  io_master_wready,
    output wire                  io_master_wvalid,
    output wire        [31:0]    io_master_wdata,
    output wire        [3:0]     io_master_wstrb,
    output wire                  io_master_wlast,
//--------------------写回复----------------------//
    output wire                  io_master_bready,
    input  wire                  io_master_bvalid,
    input  wire        [1:0]     io_master_bresp,
    input  wire        [3:0]     io_master_bid,
//--------------------读地址----------------------//
    input  wire                  io_master_arready,
    output wire                  io_master_arvalid,
    output wire        [31:0]    io_master_araddr,
    output wire        [3:0]     io_master_arid,
    output wire        [7:0]     io_master_arlen,
    output wire        [2:0]     io_master_arsize,
    output wire        [1:0]     io_master_arburst,
//--------------------读数据----------------------// 
    output wire                  io_master_rready,
    input  wire                  io_master_rvalid,
    input  wire        [1:0]     io_master_rresp,
    input  wire        [31:0]    io_master_rdata,
    input  wire                  io_master_rlast,
    input  wire        [3:0]     io_master_rid,


//Slave信号
//--------------------写地址----------------------//
    output wire                  io_slave_awready,
    input  wire                  io_slave_awvalid,
    input  wire        [31:0]    io_slave_awaddr,
    input  wire        [3:0]     io_slave_awid,
    input  wire        [7:0]     io_slave_awlen,
    input  wire        [2:0]     io_slave_awsize,
    input  wire        [1:0]     io_slave_awburst,
//--------------------写数据----------------------//
    output wire                  io_slave_wready,
    input  wire                  io_slave_wvalid,
    input  wire        [31:0]    io_slave_wdata,
    input  wire        [3:0]     io_slave_wstrb,
    input  wire                  io_slave_wlast,
//--------------------写回复----------------------//
    input  wire                  io_slave_bready,
    output wire                  io_slave_bvalid,
    output wire        [1:0]     io_slave_bresp,
    output wire        [3:0]     io_slave_bid,
//--------------------读地址----------------------//
    output wire                  io_slave_arready,
    input  wire                  io_slave_arvalid,
    input  wire        [31:0]    io_slave_araddr,
    input  wire        [3:0]     io_slave_arid,
    input  wire        [7:0]     io_slave_arlen,
    input  wire        [2:0]     io_slave_arsize,
    input  wire        [1:0]     io_slave_arburst,
//--------------------读数据----------------------// 
    input  wire                  io_slave_rready,
    output wire                  io_slave_rvalid,
    output wire        [1:0]     io_slave_rresp,
    output wire        [31:0]    io_slave_rdata,
    output wire                  io_slave_rlast,
    output wire        [3:0]     io_slave_rid


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
wire [31:0] IFU_araddr;
wire        IFU_arready;
wire        IFU_arvalid;
wire [3:0]  IFU_arid;
wire [7:0]  IFU_arlen;
wire [2:0]  IFU_arsize;
wire [1:0]  IFU_arburst;

wire [31:0] IFU_rdata;
wire        IFU_rready;
wire        IFU_rvalid;
wire [1:0]  IFU_rresp;
wire        IFU_rlast;
wire [3:0]  IFU_rid;

wire        IFU_awready;
wire        IFU_awvalid;
wire [31:0] IFU_awaddr;
wire [3:0]  IFU_awid;
wire [7:0]  IFU_awlen;
wire [2:0]  IFU_awsize;
wire [1:0]  IFU_awburst;

wire [31:0] IFU_wdata;
wire        IFU_wvalid;
wire        IFU_wready;
wire [3:0]  IFU_wstrb;
wire        IFU_wlast;

wire        IFU_bready;
wire        IFU_bvalid;
wire [1:0]  IFU_bresp;
wire [3:0]  IFU_bid;

 ysyx_25030093_IFU IFU(
    .in_valid               (out_valid_pc),
     .clock             	(clock    ),
     .reset   	            (reset    ),
     .valid 	            (out_valid_IFU  ),
     .ready 	            (out_ready_IDU_IFU  ),
     .inst_wire  	        (inst_wire   ),
     .pc    	            (pc     ),
     .io_master_araddr      (IFU_araddr),
     .io_master_arvalid     (IFU_arvalid),
     .io_master_arready     (IFU_arready),
     .io_master_arburst     (IFU_arburst),
     .io_master_arid        (IFU_arid),
     .io_master_arlen       (IFU_arlen),
     .io_master_arsize      (IFU_arsize),
     .io_master_rid         (IFU_rid),
     .io_master_rlast       (IFU_rlast),
     .io_master_rresp       (IFU_rresp),
     .io_master_rready      (IFU_rready),
     .io_master_rdata       (IFU_rdata),
     .io_master_rvalid      (IFU_rvalid),
     .io_master_awaddr      (IFU_awaddr),
     .io_master_awburst     (IFU_awburst),
     .io_master_awid        (IFU_awid),
     .io_master_awlen       (IFU_awlen),
     .io_master_awready     (IFU_awready),
     .io_master_awsize      (IFU_awsize),
     .io_master_awvalid     (IFU_awvalid),
     .io_master_wdata       (IFU_wdata),
     .io_master_wlast       (IFU_wlast),
     .io_master_wready      (IFU_wready),
     .io_master_wstrb       (IFU_wstrb),
     .io_master_wvalid      (IFU_wvalid),
     .io_master_bid         (IFU_bid),
     .io_master_bready      (IFU_bready),
     .io_master_bresp       (IFU_bresp),
     .io_master_bvalid      (IFU_bvalid)
 );


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
    .rd_or_LSU_single (rd_or_LSU_single),
    .LOAD_single      (LOAD_single),
    .STORE_single     (STORE_single)
);

//------------------------------------------//

wire [31:0] rs1_data;//read rs1
wire [31:0] rs2_data;//read rs2
wire [31:0] rd_data;
wire B_single;

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

// output declaration of module ysyx_25030093_AXI_Arbiter



ysyx_25030093_AXI_Arbiter 

AXI_Arbiter(
    .clock            	    (clock             ),
    .reset            	    (reset             ),
    .IFU_araddr     	    (IFU_araddr      ),
    .IFU_arvalid    	    (IFU_arvalid     ),
    .IFU_arready    	    (IFU_arready     ),
    .IFU_arburst            (IFU_arburst),
    .IFU_arid               (IFU_arid),
    .IFU_arlen              (IFU_arlen),
    .IFU_arsize             (IFU_arsize),
    .IFU_rdata      	    (IFU_rdata       ),
    .IFU_rvalid     	    (IFU_rvalid      ),
    .IFU_rready     	    (IFU_rready      ),
    .IFU_rid                (IFU_rid),
    .IFU_rlast              (IFU_rlast),
    .IFU_rresp              (IFU_rresp),
    .IFU_awaddr     	    (IFU_awaddr      ),
    .IFU_awvalid    	    (IFU_awvalid     ),
    .IFU_awready    	    (IFU_awready     ),
    .IFU_awburst            (IFU_awburst),
    .IFU_awid               (IFU_awid),
    .IFU_awlen              (IFU_awlen),
    .IFU_awsize             (IFU_awsize),
    .IFU_wdata      	    (IFU_wdata       ),
    .IFU_wstrb      	    (IFU_wstrb       ),
    .IFU_wvalid     	    (IFU_wvalid      ),
    .IFU_wready     	    (IFU_wready      ),
    .IFU_wlast              (IFU_wlast),
    .IFU_bresp              (IFU_bresp),
    .IFU_bvalid     	    (IFU_bvalid      ),
    .IFU_bready     	    (IFU_bready      ),
    .IFU_bid                (IFU_bid),
    .LSU_araddr     	    (LSU_araddr      ),
    .LSU_arvalid    	    (LSU_arvalid     ),
    .LSU_arready    	    (LSU_arready     ),
    .LSU_arburst            (LSU_arburst),
    .LSU_arid               (LSU_arid),
    .LSU_arlen              (LSU_arlen),
    .LSU_arsize             (LSU_arsize),
    .LSU_rdata      	    (LSU_rdata       ),
    .LSU_rvalid     	    (LSU_rvalid      ),
    .LSU_rready     	    (LSU_rready      ),
    .LSU_rid                (LSU_rid),
    .LSU_rlast              (LSU_rlast),
    .LSU_rresp              (LSU_rresp),
    .LSU_awaddr     	    (LSU_awaddr      ),
    .LSU_awvalid    	    (LSU_awvalid     ),
    .LSU_awready    	    (LSU_awready     ),
    .LSU_awburst            (LSU_awburst),
    .LSU_awid               (LSU_awid),
    .LSU_awlen              (LSU_awlen),
    .LSU_awsize             (LSU_awsize),
    .LSU_wdata      	    (LSU_wdata       ),
    .LSU_wstrb      	    (LSU_wstrb       ),
    .LSU_wvalid     	    (LSU_wvalid      ),
    .LSU_wready     	    (LSU_wready      ),
    .LSU_wlast              (LSU_wlast),
    .LSU_bresp              (LSU_bresp),
    .LSU_bvalid     	    (LSU_bvalid      ),
    .LSU_bready     	    (LSU_bready      ),
    .LSU_bid                (LSU_bid),
    .araddr     	        (io_master_araddr      ),
    .arvalid    	        (io_master_arvalid     ),
    .arready    	        (io_master_arready     ),
    .arburst                (io_master_arburst),
    .arid                   (io_master_arid),
    .arlen                  (io_master_arlen),
    .arsize                 (io_master_arsize),
    .rdata      	        (io_master_rdata       ),
    .rvalid     	        (io_master_rvalid      ),
    .rready     	        (io_master_rready      ),
    .rid                    (io_master_rid),
    .rlast                  (io_master_rlast),
    .rresp                  (io_master_rresp),
    .awaddr     	        (io_master_awaddr      ),
    .awvalid    	        (io_master_awvalid     ),
    .awready    	        (io_master_awready     ),
    .awburst                (io_master_awburst),
    .awid                   (io_master_awid),
    .awlen                  (io_master_awlen),
    .awsize                 (io_master_awsize),
    .wdata      	        (io_master_wdata       ),
    .wstrb      	        (io_master_wstrb       ),
    .wvalid     	        (io_master_wvalid      ),
    .wready     	        (io_master_wready      ),
    .wlast                  (io_master_wlast),
    .bresp                  (io_master_bresp),
    .bvalid     	        (io_master_bvalid      ),
    .bready     	        (io_master_bready      ),
    .bid                    (io_master_bid),
    .A_CLINT_araddr     	(CLINT_araddr      ),
    .A_CLINT_arvalid    	(CLINT_arvalid     ),
    .A_CLINT_arready    	(CLINT_arready     ),
    .A_CLINT_arburst        (CLINT_arburst),
    .A_CLINT_arid           (CLINT_arid),
    .A_CLINT_arlen          (CLINT_arlen),
    .A_CLINT_arsize         (CLINT_arsize),
    .A_CLINT_rdata      	(CLINT_rdata       ),
    .A_CLINT_rvalid     	(CLINT_rvalid      ),
    .A_CLINT_rready     	(CLINT_rready      ),
    .A_CLINT_rid            (CLINT_rid),
    .A_CLINT_rlast          (CLINT_rlast),
    .A_CLINT_rresp          (CLINT_rresp),
    .A_CLINT_awaddr     	(CLINT_awaddr      ),
    .A_CLINT_awvalid    	(CLINT_awvalid     ),
    .A_CLINT_awready    	(CLINT_awready     ),
    .A_CLINT_awburst        (CLINT_awburst),
    .A_CLINT_awid           (CLINT_awid),
    .A_CLINT_awlen          (CLINT_awlen),
    .A_CLINT_awsize         (CLINT_awsize),
    .A_CLINT_wdata      	(CLINT_wdata       ),
    .A_CLINT_wstrb      	(CLINT_wstrb       ),
    .A_CLINT_wvalid     	(CLINT_wvalid      ),
    .A_CLINT_wready     	(CLINT_wready      ),
    .A_CLINT_wlast          (CLINT_wlast),
    .A_CLINT_bresp          (CLINT_bresp),
    .A_CLINT_bvalid     	(CLINT_bvalid      ),
    .A_CLINT_bready     	(CLINT_bready      ),
    .A_CLINT_bid            (CLINT_bid)
);



//------------------------------------------//

wire LOAD_single;
wire STORE_single;
wire [3:0] wstrb;
wire [31:0] LSU_araddr;
wire        LSU_arvalid;
wire        LSU_arready;
wire [3:0]  LSU_arid;
wire [7:0]  LSU_arlen;
wire [2:0]  LSU_arsize;
wire [1:0]  LSU_arburst;

wire [31:0] LSU_rdata;
wire        LSU_rvalid;
wire        LSU_rready;
wire [1:0]  LSU_rresp;
wire        LSU_rlast;
wire [3:0]  LSU_rid;

wire [31:0] LSU_awaddr;
wire        LSU_awready;
wire        LSU_awvalid;
wire [3:0]  LSU_awid;
wire [7:0]  LSU_awlen;
wire [2:0]  LSU_awsize;
wire [1:0]  LSU_awburst;

wire [31:0] LSU_wdata;
wire        LSU_wvalid;
wire [3:0]  LSU_wstrb;
wire        LSU_wready;
wire        LSU_wlast;

wire        LSU_bready;
wire        LSU_bvalid;
wire [1:0]  LSU_bresp;
wire [3:0]  LSU_bid;
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
    .LOAD_single      (LOAD_single),
    .STORE_single     (STORE_single),
    .LSU_araddr  (LSU_araddr),
    .LSU_arvalid (LSU_arvalid),
    .LSU_arready (LSU_arready),
    .LSU_arburst (LSU_arburst),
    .LSU_arid    (LSU_arid),
    .LSU_arlen   (LSU_arlen),
    .LSU_arsize  (LSU_arsize),
    .LSU_rready  (LSU_rready),
    .LSU_rdata   (LSU_rdata),
    .LSU_rvalid  (LSU_rvalid),
    .LSU_rid     (LSU_rid),
    .LSU_rlast   (LSU_rlast),
    .LSU_rresp   (LSU_rresp),
    .LSU_awready (LSU_awready),
    .LSU_awaddr  (LSU_awaddr),
    .LSU_awvalid (LSU_awvalid),
    .LSU_awburst (LSU_awburst),
    .LSU_awid    (LSU_awid),
    .LSU_awlen   (LSU_awlen),
    .LSU_awsize  (LSU_awsize),
    .LSU_wstrb   (LSU_wstrb),
    .LSU_wvalid  (LSU_wvalid),
    .LSU_wdata   (LSU_wdata),
    .LSU_wready  (LSU_wready),
    .LSU_wlast   (LSU_wlast),
    .LSU_bready  (LSU_bready),
    .LSU_bvalid  (LSU_bvalid),
    .LSU_bid     (LSU_bid),
    .LSU_bresp   (LSU_bresp)
);

//------------------------------------------//



// output declaration of module ysyx_25030093_CLINT
wire [31:0] CLINT_araddr;
wire        CLINT_arready;
wire        CLINT_arvalid;
wire [3:0]  CLINT_arid;
wire [7:0]  CLINT_arlen;
wire [2:0]  CLINT_arsize;
wire [1:0]  CLINT_arburst;

wire [31:0] CLINT_rdata;
wire        CLINT_rready;
wire        CLINT_rvalid;
wire [1:0]  CLINT_rresp;
wire        CLINT_rlast;
wire [3:0]  CLINT_rid;

wire        CLINT_awready;
wire        CLINT_awvalid;
wire [31:0] CLINT_awaddr;
wire [3:0]  CLINT_awid;
wire [7:0]  CLINT_awlen;
wire [2:0]  CLINT_awsize;
wire [1:0]  CLINT_awburst;

wire [31:0] CLINT_wdata;
wire        CLINT_wvalid;
wire        CLINT_wready;
wire [3:0]  CLINT_wstrb;
wire        CLINT_wlast;

wire        CLINT_bready;
wire        CLINT_bvalid;
wire [1:0]  CLINT_bresp;
wire [3:0]  CLINT_bid;

ysyx_25030093_CLINT CLINT(
    .clock           	(clock            ),
    .CLINT_araddr     	(CLINT_araddr      ),
    .CLINT_arvalid    	(CLINT_arvalid     ),
    .CLINT_arready    	(CLINT_arready     ),
    .CLINT_arburst        (CLINT_arburst),
    .CLINT_arid           (CLINT_arid),
    .CLINT_arlen          (CLINT_arlen),
    .CLINT_arsize         (CLINT_arsize),
    .CLINT_rdata      	(CLINT_rdata       ),
    .CLINT_rvalid     	(CLINT_rvalid      ),
    .CLINT_rready     	(CLINT_rready      ),
    .CLINT_rid            (CLINT_rid),
    .CLINT_rlast          (CLINT_rlast),
    .CLINT_rresp          (CLINT_rresp),
    .CLINT_awaddr     	(CLINT_awaddr      ),
    .CLINT_awvalid    	(CLINT_awvalid     ),
    .CLINT_awready    	(CLINT_awready     ),
    .CLINT_awburst        (CLINT_awburst),
    .CLINT_awid           (CLINT_awid),
    .CLINT_awlen          (CLINT_awlen),
    .CLINT_awsize         (CLINT_awsize),
    .CLINT_wdata      	(CLINT_wdata       ),
    .CLINT_wstrb      	(CLINT_wstrb       ),
    .CLINT_wvalid     	(CLINT_wvalid      ),
    .CLINT_wready     	(CLINT_wready      ),
    .CLINT_wlast          (CLINT_wlast),
    .CLINT_bresp          (CLINT_bresp),
    .CLINT_bvalid     	(CLINT_bvalid      ),
    .CLINT_bready     	(CLINT_bready      ),
    .CLINT_bid            (CLINT_bid)

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
    .B_single    (B_single),
    .csr_data_pc (csr_data_pc),
    .inst         (inst_wire),
    .out_valid_pc (out_valid_pc)
);


  //------------------------------------------//


endmodule
