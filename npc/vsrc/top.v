
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
     .IFU_SRAM_araddr (IFU_araddr),
     .IFU_SRAM_arvalid (IFU_arvalid),
     .IFU_SRAM_rready  (IFU_rready),
     .SRAM_IFU_arready (IFU_arready),
     .SRAM_IFU_rdata   (IFU_rdata),
     .SRAM_IFU_rvalid  (IFU_rvalid)
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
    .clk              (clk),
    .rst              (rst),
    .LSU_single       (LSU_single),
    .rd_or_LSU_single (rd_or_LSU_single),
    .wstrb            (wstrb),
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

// output declaration of module ysyx_25030093_AXI_Arbiter
wire [31:0] IFU_araddr;
wire        IFU_arready;
wire        IFU_arvalid;

wire [31:0] IFU_rdata;
wire        IFU_rready;
wire        IFU_rvalid;

wire        IFU_awready;
wire        IFU_awvalid;
wire [31:0] IFU_awaddr;

wire [31:0] IFU_wdata;
wire        IFU_wvalid;
wire        IFU_wready;

wire        IFU_bready;
wire        IFU_bvalid;

wire [31:0] LSU_araddr;
wire        LSU_arvalid;
wire        LSU_arready;

wire [31:0] LSU_rdata;
wire        LSU_rvalid;
wire        LSU_rready;

wire [31:0] LSU_awaddr;
wire        LSU_awready;
wire        LSU_awvalid;

wire [31:0] LSU_wdata;
wire        LSU_wvalid;
wire [7:0]  LSU_wstrb;
wire        LSU_wready;

wire        LSU_bready;
wire        LSU_bvalid;

wire [31:0] A_SRAM_araddr;
wire        A_SRAM_arready;
wire        A_SRAM_arvalid;

wire [31:0] A_SRAM_rdata;
wire        A_SRAM_rvalid;
wire        A_SRAM_rready;

wire [31:0] A_SRAM_awaddr;
wire        A_SRAM_awready;
wire        A_SRAM_awvalid;

wire [31:0] A_SRAM_wdata;
wire        A_SRAM_wready;
wire        A_SRAM_wvalid;
wire [7:0]  A_SRAM_wstrb;

wire        A_SRAM_bvalid;
wire        A_SRAM_bready;

ysyx_25030093_AXI_Arbiter 

u_ysyx_25030093_AXI_Arbiter(
    .clk            	(clk             ),
    .rst            	(rst             ),
    .IFU_araddr     	(IFU_araddr      ),
    .IFU_arvalid    	(IFU_arvalid     ),
    .IFU_arready    	(IFU_arready     ),
    .IFU_rdata      	(IFU_rdata       ),
    .IFU_rvalid     	(IFU_rvalid      ),
    .IFU_rready     	(IFU_rready      ),
    .IFU_awaddr     	(IFU_awaddr      ),
    .IFU_awvalid    	(IFU_awvalid     ),
    .IFU_awready    	(IFU_awready     ),
    .IFU_wdata      	(IFU_wdata       ),
    .IFU_wstrb      	(IFU_wstrb       ),
    .IFU_wvalid     	(IFU_wvalid      ),
    .IFU_wready     	(IFU_wready      ),
    .IFU_bvalid     	(IFU_bvalid      ),
    .IFU_bready     	(IFU_bready      ),
    .LSU_araddr     	(LSU_araddr      ),
    .LSU_arvalid    	(LSU_arvalid     ),
    .LSU_arready    	(LSU_arready     ),
    .LSU_rdata      	(LSU_rdata       ),
    .LSU_rvalid     	(LSU_rvalid      ),
    .LSU_rready     	(LSU_rready      ),
    .LSU_awaddr     	(LSU_awaddr      ),
    .LSU_awvalid    	(LSU_awvalid     ),
    .LSU_awready    	(LSU_awready     ),
    .LSU_wdata      	(LSU_wdata       ),
    .LSU_wstrb      	(LSU_wstrb       ),
    .LSU_wvalid     	(LSU_wvalid      ),
    .LSU_wready     	(LSU_wready      ),
    .LSU_bvalid     	(LSU_bvalid      ),
    .LSU_bready     	(LSU_bready      ),
    .A_SRAM_araddr  	(A_SRAM_araddr   ),
    .A_SRAM_arvalid 	(A_SRAM_arvalid  ),
    .A_SRAM_arready 	(A_SRAM_arready  ),
    .A_SRAM_rvalid  	(A_SRAM_rvalid   ),
    .A_SRAM_rdata   	(A_SRAM_rdata    ),
    .A_SRAM_rready  	(A_SRAM_rready   ),
    .A_SRAM_awaddr  	(A_SRAM_awaddr   ),
    .A_SRAM_awvalid 	(A_SRAM_awvalid  ),
    .A_SRAM_awready 	(A_SRAM_awready  ),
    .A_SRAM_wdata   	(A_SRAM_wdata    ),
    .A_SRAM_wvalid  	(A_SRAM_wvalid   ),
    .A_SRAM_wstrb   	(A_SRAM_wstrb    ),
    .A_SRAM_wready  	(A_SRAM_wready   ),
    .A_SRAM_bready  	(A_SRAM_bready   ),
    .A_SRAM_bvalid  	(A_SRAM_bvalid   ),
    .A_UART_araddr      (UART_araddr),
    .A_UART_arready     (UART_arready),
    .A_UART_arvalid     (UART_arvalid),
    .A_UART_rvalid      (UART_rvalid),
    .A_UART_rready      (UART_rready),
    .A_UART_rdata       (UART_rdata),
    .A_UART_awaddr      (UART_awaddr),
    .A_UART_awvalid     (UART_awvalid),
    .A_UART_awready     (UART_awready),
    .A_UART_wdata       (UART_wdata),
    .A_UART_wstrb       (UART_wstrb),
    .A_UART_wvalid      (UART_wvalid),
    .A_UART_wready      (UART_wready),
    .A_UART_bready      (UART_bready),
    .A_UART_bvalid      (UART_bvalid),
    .A_CLINT_araddr     (CLINT_araddr),
    .A_CLINT_arvalid    (CLINT_arvalid),
    .A_CLINT_arready    (CLINT_arready),
    .A_CLINT_rdata      (CLINT_rdata),
    .A_CLINT_rready     (CLINT_rready),
    .A_CLINT_rvalid     (CLINT_rvalid),
    .A_CLINT_awvalid    (CLINT_awvalid),
    .A_CLINT_awaddr     (CLINT_awaddr),
    .A_CLINT_awready    (CLINT_awready),
    .A_CLINT_wvalid     (CLINT_wvalid),
    .A_CLINT_wready     (CLINT_wready),
    .A_CLINT_wdata      (CLINT_wdata),
    .A_CLINT_wstrb      (CLINT_wstrb),
    .A_CLINT_bready     (CLINT_bready),
    .A_CLINT_bvalid     (CLINT_bvalid)
);



//------------------------------------------//

wire LOAD_single;
wire STORE_single;
wire [7:0] wstrb;
//LSU
ysyx_25030093_LSU u_ysyx_25030093_LSU(
    .in_valid    	  (out_valid_EXU_LSU     ),
    .in_ready         (out_ready_WBU_LSU),
    .out_ready        (out_ready_LSU_EXU),
    .out_valid        (out_valid_LSU_WBU),
    .rd_data    	  (rd_data     ),
    .rs2_data   	  (rs2_data    ),
    .LSU_data   	  (LSU_data    ),
    .LSU_single 	  (LSU_single  ),
    .clk        	  (clk         ),
    .rst              (rst),
    .wstrb            (wstrb),
    .LOAD_single      (LOAD_single),
    .STORE_single     (STORE_single),
    .LSU_SRAM_araddr  (LSU_araddr),
    .LSU_SRAM_arvalid (LSU_arvalid),
    .LSU_SRAM_rready  (LSU_rready),
    .SRAM_LSU_rdata   (LSU_rdata),
    .SRAM_LSU_arready (LSU_arready),
    .SRAM_LSU_rvalid  (LSU_rvalid),
    .LSU_SRAM_awaddr  (LSU_awaddr),
    .LSU_SRAM_awvalid (LSU_awvalid),
    .LSU_SRAM_wstrb   (LSU_wstrb),
    .LSU_SRAM_wvalid  (LSU_wvalid),
    .LSU_SRAM_bready  (LSU_bready),
    .LSU_SRAM_wdata   (LSU_wdata),
    .SRAM_LSU_awready (LSU_awready),
    .SRAM_LSU_wready  (LSU_wready),
    .SRAM_LSU_bvalid  (LSU_bvalid)
);

//------------------------------------------//



ysyx_25030093_SRAM LSU_ysyx_25030093_SRAM(
    .SRAM_arvalid 	(A_SRAM_arvalid  ),
    .SRAM_araddr  	(A_SRAM_araddr   ),
    .SRAM_rready  	(A_SRAM_rready   ),
    .SRAM_rdata   	(A_SRAM_rdata    ),
    .SRAM_rvalid  	(A_SRAM_rvalid   ),
    .SRAM_arready 	(A_SRAM_arready  ),
    .SRAM_awaddr  	(A_SRAM_awaddr   ),
    .SRAM_wdata   	(A_SRAM_wdata    ),
    .SRAM_wstrb   	(A_SRAM_wstrb    ),
    .SRAM_awvalid 	(A_SRAM_awvalid  ),
    .SRAM_wvalid  	(A_SRAM_wvalid   ),
    .SRAM_bready  	(A_SRAM_bready   ),
    .SRAM_awready 	(A_SRAM_awready  ),
    .SRAM_wready  	(A_SRAM_wready   ),
    .SRAM_bvalid  	(A_SRAM_bvalid   ),
    .clk          	(clk           )
);

//------------------------------------------//

// output declaration of module ysyx_25030093_UART
wire [31:0] UART_araddr;
wire        UART_arvalid;
wire        UART_arready;
wire        UART_rready;
wire        UART_rvalid;
wire [31:0] UART_rdata;
wire [31:0] UART_awaddr;
wire        UART_awvalid;
wire        UART_awready;
wire [31:0] UART_wdata;
wire        UART_wvalid;
wire        UART_wready;
wire [7:0]  UART_wstrb;
wire        UART_bready;
wire        UART_bvalid;

ysyx_25030093_UART u_ysyx_25030093_UART(
    .clk          	(clk           ),
    .UART_araddr  	(UART_araddr   ),
    .UART_arvalid 	(UART_arvalid  ),
    .UART_arready 	(UART_arready  ),
    .UART_rvalid  	(UART_rvalid   ),
    .UART_rdata   	(UART_rdata    ),
    .UART_rready  	(UART_rready   ),
    .UART_awaddr  	(UART_awaddr   ),
    .UART_awvalid 	(UART_awvalid  ),
    .UART_awready 	(UART_awready  ),
    .UART_wdata   	(UART_wdata    ),
    .UART_wvalid  	(UART_wvalid   ),
    .UART_wstrb   	(UART_wstrb    ),
    .UART_wready  	(UART_wready   ),
    .UART_bready  	(UART_bready   ),
    .UART_bvalid  	(UART_bvalid   )
);
//------------------------------------------//

// output declaration of module ysyx_25030093_CLINT
wire        CLINT_arready;
wire [31:0] CLINT_rdata;
wire        CLINT_rvalid;
wire        CLINT_rready;
wire [31:0] CLINT_araddr;
wire        CLINT_arvalid;

wire [31:0] CLINT_awaddr;
wire        CLINT_awvalid;
wire        CLINT_awready;

wire [31:0] CLINT_wdata;
wire        CLINT_wvalid;
wire [7:0]  CLINT_wstrb;
wire        CLINT_wready;

wire        CLINT_bready;
wire        CLINT_bvalid;

ysyx_25030093_CLINT u_ysyx_25030093_CLINT(
    .clk           	(clk            ),
    .CLINT_araddr  	(CLINT_araddr   ),
    .CLINT_arvalid 	(CLINT_arvalid  ),
    .CLINT_arready 	(CLINT_arready  ),
    .CLINT_rready  	(CLINT_rready   ),
    .CLINT_rdata   	(CLINT_rdata    ),
    .CLINT_rvalid  	(CLINT_rvalid   ),
    .CLINT_awaddr   (CLINT_awaddr),
    .CLINT_awready  (CLINT_awready),
    .CLINT_awvalid  (CLINT_awvalid),
    .CLINT_wdata    (CLINT_wdata),
    .CLINT_wready   (CLINT_wready),
    .CLINT_wvalid   (CLINT_wvalid),
    .CLINT_wstrb    (CLINT_wstrb),
    .CLINT_bready   (CLINT_bready),
    .CLINT_bvalid   (CLINT_bvalid)

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
