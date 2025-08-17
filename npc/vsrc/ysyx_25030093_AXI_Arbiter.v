module ysyx_25030093_AXI_Arbiter(
    input                 clock,
    input                 reset,
//---------------IFU读地址----------------//     
    input       [31:0]     IFU_araddr,
    input                  IFU_arvalid,
    output  reg            IFU_arready,
    input       [3:0]      IFU_arid,
    input       [7:0]      IFU_arlen,
    input       [2:0]      IFU_arsize,
    input       [1:0]      IFU_arburst,
//---------------IFU读数据----------------//  
    output      [31:0]     IFU_rdata,
    output  reg            IFU_rvalid,
    input                  IFU_rready,
    output  reg [1:0]      IFU_rresp,
    output  reg            IFU_rlast,
    output  reg [3:0]      IFU_rid,
 //---------------IFU写地址----------------//   
    input       [31:0]     IFU_awaddr,
    input                  IFU_awvalid,
    output                 IFU_awready, 
    input       [3:0]      IFU_awid,
    input       [7:0]      IFU_awlen,
    input       [2:0]      IFU_awsize,
    input       [1:0]      IFU_awburst, 

//---------------IFU写数据----------------//    
    input       [31:0]     IFU_wdata,
    input       [3:0]      IFU_wstrb,
    input                  IFU_wvalid,
    output                 IFU_wready,
    input                  IFU_wlast,
//---------------IFU写回复----------------//
    output  reg            IFU_bvalid,
    input                  IFU_bready,  
    output      [1:0]      IFU_bresp,
    output      [3:0]      IFU_bid,
//---------------LSU读地址----------------//     
    input       [31:0]     LSU_araddr,
    input                  LSU_arvalid,
    output  reg            LSU_arready,
    input       [3:0]      LSU_arid,
    input       [7:0]      LSU_arlen,
    input       [2:0]      LSU_arsize,
    input       [1:0]      LSU_arburst,
//---------------LSU读数据----------------//  
    output      [31:0]     LSU_rdata,
    output  reg            LSU_rvalid,
    input                  LSU_rready,
    output      [1:0]      LSU_rresp,
    output                 LSU_rlast,
    output      [3:0]      LSU_rid,
//---------------LSU写地址----------------//   
    input       [31:0]     LSU_awaddr,
    input                  LSU_awvalid,
    output                 LSU_awready, 
    input       [3:0]      LSU_awid,
    input       [7:0]      LSU_awlen,
    input       [2:0]      LSU_awsize,
    input       [1:0]      LSU_awburst, 
//---------------LSU写数据----------------//    
    input       [31:0]     LSU_wdata,
    input       [3:0]      LSU_wstrb,
    input                  LSU_wvalid,
    output                 LSU_wready,
    input                  LSU_wlast,
//---------------LSU写回复----------------//
    output  reg            LSU_bvalid,
    input                  LSU_bready, 
    output  reg [1:0]      LSU_bresp,
    output  reg [3:0]      LSU_bid,

//---------------读地址----------------//    
    output  reg [31:0]     araddr,
    output  reg            arvalid,
    input                  arready,
    output  reg [3:0]      arid,
    output  reg [7:0]      arlen,
    output  reg [2:0]      arsize,
    output  reg [1:0]      arburst,

    output  reg [31:0]     A_CLINT_araddr,
    output  reg            A_CLINT_arvalid,
    input                  A_CLINT_arready,
    output  reg [3:0]      A_CLINT_arid,
    output  reg [7:0]      A_CLINT_arlen,
    output  reg [2:0]      A_CLINT_arsize,
    output  reg [1:0]      A_CLINT_arburst,
//---------------读数据----------------//    
    input                  rvalid,
    input       [31:0]     rdata,          
    output  reg            rready,
    input       [1:0]      rresp,
    input                  rlast,
    input       [3:0]      rid,

    input                  A_CLINT_rvalid,
    input       [31:0]     A_CLINT_rdata,
    output  reg            A_CLINT_rready,
    input       [1:0]      A_CLINT_rresp,
    input                  A_CLINT_rlast,
    input       [3:0]      A_CLINT_rid,
//---------------写地址----------------// 
    output  reg [31:0]     awaddr,
    output  reg            awvalid,
    input                  awready,
    output  reg [3:0]      awid,
    output  reg [7:0]      awlen,
    output  reg [2:0]      awsize,
    output  reg [1:0]      awburst,


    output  reg [31:0]     A_CLINT_awaddr,
    output  reg            A_CLINT_awvalid,
    input                  A_CLINT_awready,
    output  reg [3:0]      A_CLINT_awid,
    output  reg [7:0]      A_CLINT_awlen,
    output  reg [2:0]      A_CLINT_awsize,
    output  reg [1:0]      A_CLINT_awburst,
//---------------写数据----------------//  
    output  reg [31:0]     wdata,
    output  reg            wvalid,
    output  reg [3:0]      wstrb,
    input                  wready,
    output  reg            wlast,

    output  reg [31:0]     A_CLINT_wdata,
    output  reg            A_CLINT_wvalid,
    output  reg [3:0]      A_CLINT_wstrb,
    input                  A_CLINT_wready,
    output  reg            A_CLINT_wlast,
//---------------写回复----------------//  
    output  reg            bready,
    input                  bvalid,
    input       [1:0]      bresp,
    input       [3:0]      bid,

    output reg             A_CLINT_bready,
    input                  A_CLINT_bvalid,
    input       [1:0]      A_CLINT_bresp,
    input       [3:0]      A_CLINT_bid

);
parameter IFU = 3'b000, LSU_ar_IDLE = 3'b001, LSU_aw_IDLE = 3'b010 ,LSU_ar_Soc = 3'b011,LSU_aw_Soc = 3'b100,LSU_ar_CLINT = 3'b101,LSU_aw_CLINT = 3'b110,IDLE= 3'b111;


reg aw_state,w_state;
always@(posedge clock)begin
    if(LSU_awvalid)begin
        aw_state <= 1'b1;
    end
    else begin
        aw_state <= aw_state;
    end
    if(LSU_wvalid)begin
        w_state <= 1'b1;
    end
    else begin
        w_state <= w_state;
    end
end




reg [2:0] state;

always @(posedge clock) begin
    if(reset)begin
        state <= IDLE;
    end
    else begin 
    case(state)
    IDLE:begin
        if(IFU_arvalid)begin
            state <= IFU;
        end
        else if(LSU_arvalid)begin
            state <= LSU_ar_IDLE;
        end
        else if(aw_state & w_state)begin
            state <= LSU_aw_IDLE;
        end
        else state <= IDLE;
    end
    IFU:begin
       if(IFU_rvalid & IFU_rready)begin
        state <= IDLE;
       end
       else state <= IFU;
    end
    LSU_ar_IDLE:begin
        if((LSU_araddr == 32'ha0000048)||(LSU_araddr == 32'ha000004c))begin
            state <= LSU_ar_CLINT;
        end
        else state <= LSU_ar_Soc;
    end
    LSU_aw_IDLE:begin
        if((LSU_awaddr == 32'ha0000048)||(LSU_awaddr == 32'ha000004c))begin
            state <= LSU_aw_CLINT;
        end
        else begin
            state <= LSU_aw_Soc;     
        end 
    end
    LSU_ar_Soc:begin
        if(LSU_rvalid & LSU_rready)begin
            state <= IDLE;
        end
        else state <= LSU_ar_Soc;
    end
    LSU_ar_CLINT:begin
        if(LSU_rvalid & LSU_rready)begin
            state <= IDLE;
        end
        else state <= LSU_ar_CLINT;
    end
    LSU_aw_Soc:begin
        if(LSU_bvalid & LSU_bready )begin
            state <= IDLE;
             aw_state <= 1'b0;
            w_state <= 1'b0;
        end
        else begin 
            state <= LSU_aw_Soc;
              aw_state <= 1'b0;
            w_state <= 1'b0;
        end
    end
    LSU_aw_CLINT:begin
        if(LSU_bvalid & LSU_bready)begin
            state <= IDLE;
            aw_state <= 1'b0;
            w_state <= 1'b0;
        end
        else begin
            state <= LSU_aw_CLINT;
            aw_state <= 1'b0;
            w_state <= 1'b0;
        end
    end
    default:begin
        state <= state;
    end
    endcase
end
end



always@(*)begin
   
    araddr = 32'b0;
    arvalid = 1'b0;
    arburst = 2'b0;
    arid = 0;
    arlen = 0;
    arsize = 0;
    
    rready = 1'b0;
    
    awaddr = 32'b0;
    awvalid = 1'b0;
    awburst = 2'b0;
    awid = 0;
    awlen = 0;
    awsize = 0;
    
    wdata = 32'b0;
    wstrb = 0;
    wvalid = 1'b0;
    wlast = 1'b0;
    
    bready = 1'b0;
    
    // IFU 接口
    IFU_arready = 1'b0;
    IFU_rvalid = 1'b0;
    IFU_rdata = 32'b0;
    IFU_rid = 0;
    IFU_rlast = 1'b0;
    IFU_rresp = 0;
    IFU_awready = 1'b0;
    IFU_wready = 1'b0;
    IFU_bvalid = 1'b0;
    IFU_bid = 0;
    IFU_bresp = 0;
    
    // LSU 接口
    LSU_arready = 1'b0;
    LSU_rvalid = 1'b0;
    LSU_rdata = 32'b0;
    LSU_rid = 0;
    LSU_rlast = 1'b0;
    LSU_rresp = 0;
    LSU_awready = 1'b0;
    LSU_wready = 1'b0;
    LSU_bvalid = 1'b0;
    LSU_bid = 0;
    LSU_bresp = 0;
    
    // CLINT 接口
    A_CLINT_araddr = 32'b0;
    A_CLINT_arvalid = 1'b0;
    A_CLINT_arburst = 2'b0;
    A_CLINT_arid = 0;
    A_CLINT_arlen = 0;
    A_CLINT_arsize = 0;
    A_CLINT_rready = 1'b0;
    A_CLINT_awaddr = 32'b0;
    A_CLINT_awvalid = 1'b0;
    A_CLINT_awburst = 2'b0;
    A_CLINT_awid = 0;
    A_CLINT_awlen = 0;
    A_CLINT_awsize = 0;
    A_CLINT_wdata = 32'b0;
    A_CLINT_wstrb = 0;
    A_CLINT_wvalid = 1'b0;
    A_CLINT_wlast = 1'b0;
    A_CLINT_bready = 1'b0;

   case(state)
   IDLE:begin
    
   end
  IFU:begin
    araddr          = IFU_araddr;
    arvalid         = IFU_arvalid;
    arburst         = IFU_arburst;
    arid            = IFU_arid;
    arlen           = IFU_arlen;
    arsize          = IFU_arsize;
    IFU_arready     = arready;
    rready          = IFU_rready;
    IFU_rvalid      = rvalid;
    IFU_rdata       = rdata;
    IFU_rid         = rid;
    IFU_rlast       = rlast;
    IFU_rresp       = rresp;
    awaddr          = IFU_awaddr;
    awvalid         = IFU_awvalid;
    awburst         = IFU_awburst;
    awid            = IFU_awid;
    awlen           = IFU_awlen;
    awsize          = IFU_awsize;
    IFU_awready     = awready;
    wdata           = IFU_wdata;
    wstrb           = IFU_wstrb;
    wvalid          = IFU_wvalid;
    IFU_wready      = wready;
    wlast           = IFU_wlast;
    IFU_bvalid      = bvalid;
    IFU_bid         = bid;
    IFU_bresp       = bresp;
    bready          = IFU_bready;

     A_CLINT_arvalid  = 1'b0;
     A_CLINT_awvalid  = 1'b0;
     A_CLINT_wvalid   = 1'b0;
            
  end  
  LSU_ar_Soc:begin
   // $display("now LSU_awaddr = %h ",LSU_awaddr);
   // $display("LSU_araddr = %h",LSU_araddr);
   // $display("LSU_wstrb = %h",LSU_wstrb);
   // $display("now single %h",((LSU_awaddr > 32'h80000000) && (LSU_awaddr < 32'h80ffffff)) && (((LSU_araddr > 32'h80000000) && (LSU_araddr < 32'h80ffffff))));
             //    $display("here");
                  araddr           = LSU_araddr;
                  arvalid          = LSU_arvalid;
                  arburst          = LSU_arburst;
                  arid             = LSU_arid;
                  arlen            = LSU_arlen;
                  arsize           = LSU_arsize;
                  LSU_arready      = arready;

                  rready           = LSU_rready;
                  LSU_rvalid       = rvalid;
                  LSU_rdata        = rdata;
                  LSU_rid          = rid;
                  LSU_rlast        = rlast;
                  LSU_rresp        = rresp;

                  awaddr           = 32'b0;
                  awvalid          = 1'b0;
                  awburst          = LSU_awburst;
                  awid             = LSU_awid;
                  awlen            = LSU_awlen;
                  awsize           = LSU_awsize;
                  LSU_awready      = awready; 

                  wdata            = 32'b0;
                  wstrb            = LSU_wstrb;
                  wvalid           = 1'b0;
                  LSU_wready       = wready;
                  wlast            = LSU_wlast;

                  LSU_bvalid       = bvalid;
                  LSU_bid          = bid;
                  LSU_bresp        = bresp;
                  bready           = LSU_bready;

                  A_CLINT_arvalid  = 1'b0;
                  A_CLINT_awvalid  = 1'b0;
                  A_CLINT_wvalid   = 1'b0;
  end
  LSU_aw_Soc:  begin
                  araddr           = 32'b0;
                  arvalid          = 1'b0;
                  arburst          = LSU_arburst;
                  arid             = LSU_arid;
                  arlen            = LSU_arlen;
                  arsize           = LSU_arsize;
                  LSU_arready      = 1'b0;

                  rready           = LSU_rready;
                  LSU_rvalid       = 1'b0;
                  LSU_rdata        = rdata;
                  LSU_rid          = rid;
                  LSU_rlast        = rlast;
                  LSU_rresp        = rresp;

                  awaddr           = LSU_awaddr;
                  awvalid          = LSU_awvalid;
                  awburst          = LSU_awburst;
                  awid             = LSU_awid;
                  awlen            = LSU_awlen;
                  awsize           = LSU_awsize;
                  LSU_awready      = awready; 

                  wdata            = LSU_wdata;
                  wstrb            = LSU_wstrb;
                  wvalid           = LSU_wvalid;
                  LSU_wready       = wready;
                  wlast            = LSU_wlast;

                  LSU_bvalid       = bvalid;
                  LSU_bid          = bid;
                  LSU_bresp        = bresp;
                  bready           = LSU_bready;

                  A_CLINT_arvalid  = 1'b0;
                  A_CLINT_awvalid  = 1'b0;
                  A_CLINT_wvalid   = 1'b0;  
    
    end
  LSU_ar_CLINT:begin
       // $display("CLINT");
                  A_CLINT_araddr           = LSU_araddr;
                  A_CLINT_arvalid          = LSU_arvalid;
                  A_CLINT_arburst          = LSU_arburst;
                  A_CLINT_arid             = LSU_arid;
                  A_CLINT_arlen            = LSU_arlen;
                  A_CLINT_arsize           = LSU_arsize;
                  LSU_arready              = A_CLINT_arready;

                  A_CLINT_rready           = LSU_rready;
                  LSU_rvalid               = A_CLINT_rvalid;
                  LSU_rdata                = A_CLINT_rdata;
                  LSU_rid                  = A_CLINT_rid;
                  LSU_rlast                = A_CLINT_rlast;
                  LSU_rresp                = A_CLINT_rresp;

                  A_CLINT_awaddr           = 32'b0;
                  A_CLINT_awvalid          = 1'b0;
                  A_CLINT_awburst          = LSU_awburst;
                  A_CLINT_awid             = LSU_awid;
                  A_CLINT_awlen            = LSU_awlen;
                  A_CLINT_awsize           = LSU_awsize;
                  LSU_awready              = A_CLINT_awready; 

                  A_CLINT_wdata            = 32'b0;
                  A_CLINT_wstrb            = LSU_wstrb;
                  A_CLINT_wvalid           = 1'b0;
                  LSU_wready               = A_CLINT_wready;
                  A_CLINT_wlast            = LSU_wlast;

                  LSU_bvalid               = A_CLINT_bvalid;
                  LSU_bid                  = A_CLINT_bid;
                  LSU_bresp                = A_CLINT_bresp;
                  A_CLINT_bready           = LSU_bready;

                  arvalid  = 1'b0;
                  awvalid  = 1'b0;
                  wvalid   = 1'b0;  
   
    end
    LSU_aw_CLINT:begin
       // $display("CLINT");
                  A_CLINT_araddr           = 32'b0;
                  A_CLINT_arvalid          = 1'b0;
                  A_CLINT_arburst          = LSU_arburst;
                  A_CLINT_arid             = LSU_arid;
                  A_CLINT_arlen            = LSU_arlen;
                  A_CLINT_arsize           = LSU_arsize;
                  LSU_arready              = 1'b0;

                  A_CLINT_rready           = LSU_rready;
                  LSU_rvalid               = 1'b0;
                  LSU_rdata                = A_CLINT_rdata;
                  LSU_rid                  = A_CLINT_rid;
                  LSU_rlast                = A_CLINT_rlast;
                  LSU_rresp                = A_CLINT_rresp;

                  A_CLINT_awaddr           = LSU_awaddr;
                  A_CLINT_awvalid          = LSU_awvalid;
                  A_CLINT_awburst          = LSU_awburst;
                  A_CLINT_awid             = LSU_awid;
                  A_CLINT_awlen            = LSU_awlen;
                  A_CLINT_awsize           = LSU_awsize;
                  LSU_awready              = A_CLINT_awready; 

                  A_CLINT_wdata            = LSU_wdata;
                  A_CLINT_wstrb            = LSU_wstrb;
                  A_CLINT_wvalid           = LSU_wvalid;
                  LSU_wready               = A_CLINT_wready;
                  A_CLINT_wlast            = LSU_wlast;

                  LSU_bvalid               = A_CLINT_bvalid;
                  LSU_bid                  = A_CLINT_bid;
                  LSU_bresp                = A_CLINT_bresp;
                  A_CLINT_bready           = LSU_bready;

                  arvalid  = 1'b0;
                  awvalid  = 1'b0;
                  wvalid   = 1'b0;  
  
    end
    default:begin
            arvalid = 1'b0;
            awvalid = 1'b0;
            wvalid  = 1'b0;

            A_CLINT_awvalid = 1'b0;
            A_CLINT_arvalid = 1'b0;
            A_CLINT_wvalid  = 1'b0;
    end
   endcase
 
end





endmodule