module ysyx_25030093_AXI_Arbiter(
    input                 clk,
    input                 rst,
//---------------IFU读地址----------------//     
    input      [31:0]     IFU_araddr,
    input                 IFU_arvalid,
    output  reg           IFU_arready,
//---------------IFU读数据----------------//  
    output      [31:0]    IFU_rdata,
    output  reg           IFU_rvalid,
    input                 IFU_rready,
 //---------------IFU写地址----------------//   
    input      [31:0]     IFU_awaddr,
    input                 IFU_awvalid,
    output                IFU_awready,  
//---------------IFU写数据----------------//    
    input      [31:0]     IFU_wdata,
    input      [7:0]      IFU_wstrb,
    input                 IFU_wvalid,
    output                IFU_wready,
//---------------IFU写回复----------------//
    output  reg           IFU_bvalid,
    input                 IFU_bready,  

//---------------LSU读地址----------------//     
    input      [31:0]     LSU_araddr,
    input                 LSU_arvalid,
    output  reg           LSU_arready,
//---------------LSU读数据----------------//  
    output      [31:0]    LSU_rdata,
    output  reg           LSU_rvalid,
    input                 LSU_rready,
//---------------LSU写地址----------------//   
    input      [31:0]     LSU_awaddr,
    input                 LSU_awvalid,
    output                LSU_awready,  
//---------------LSU写数据----------------//    
    input      [31:0]     LSU_wdata,
    input      [7:0]      LSU_wstrb,
    input                 LSU_wvalid,
    output                LSU_wready,
//---------------LSU写回复----------------//
    output  reg           LSU_bvalid,
    input                 LSU_bready, 

//---------------读地址----------------//    
    output  reg [31:0]     A_SRAM_araddr,
    output  reg            A_SRAM_arvalid,
    input                  A_SRAM_arready,

    output  reg [31:0]     A_UART_araddr,
    output  reg            A_UART_arvalid,
    input                  A_UART_arready,

    output  reg [31:0]     A_CLINT_araddr,
    output  reg            A_CLINT_arvalid,
    input                  A_CLINT_arready,
//---------------读数据----------------//    
    input                  A_SRAM_rvalid,
    input       [31:0]     A_SRAM_rdata,          
    output  reg            A_SRAM_rready,

    input                  A_UART_rvalid,
    input       [31:0]     A_UART_rdata,
    output  reg            A_UART_rready,

    input                  A_CLINT_rvalid,
    input       [31:0]     A_CLINT_rdata,
    output  reg            A_CLINT_rready,
//---------------写地址----------------// 
    output  reg [31:0]     A_SRAM_awaddr,
    output  reg            A_SRAM_awvalid,
    input                  A_SRAM_awready,

    output  reg [31:0]     A_UART_awaddr,
    output  reg            A_UART_awvalid,
    input                  A_UART_awready,

    output  reg [31:0]     A_CLINT_awaddr,
    output  reg            A_CLINT_awvalid,
    input                  A_CLINT_awready,
//---------------写数据----------------//  
    output  reg [31:0]     A_SRAM_wdata,
    output  reg            A_SRAM_wvalid,
    output  reg [7:0]      A_SRAM_wstrb,
    input                  A_SRAM_wready,

    output  reg [31:0]     A_UART_wdata,
    output  reg            A_UART_wvalid,
    output  reg [7:0]      A_UART_wstrb,
    input                  A_UART_wready,

    output  reg [31:0]     A_CLINT_wdata,
    output  reg            A_CLINT_wvalid,
    output  reg [7:0]      A_CLINT_wstrb,
    input                  A_CLINT_wready,
//---------------写回复----------------//  
    output  reg            A_SRAM_bready,
    input                  A_SRAM_bvalid,

    output reg             A_UART_bready,
    input                  A_UART_bvalid,

    output reg             A_CLINT_bready,
    input                  A_CLINT_bvalid

);
parameter IFU = 3'b000, LSU_ar_IDLE = 3'b001, LSU_aw_IDLE = 3'b010 ,LSU_ar_SRAM = 3'b011,LSU_aw_SRAM = 3'b100,LSU_ar_CLINT = 3'b101,LSU_aw_UART = 3'b110,LSU_aw_CLINT = 3'b111;


reg aw_state,w_state;
always@(posedge clk)begin
    if(LSU_awvalid)begin
        aw_state <= 1'b1;
    end
    if(LSU_wvalid)begin
        w_state <= 1'b1;
    end
end




reg [2:0] state;

always @(posedge clk) begin
    if(rst)begin
        state <= IFU;
    end
    else begin 
    case(state)
    IFU:begin
        if(LSU_arvalid)begin
            state <= LSU_ar_IDLE;
        end
        else if(aw_state & w_state) begin
            state <= LSU_aw_IDLE;
        end
        else state <= IFU;
    end
    LSU_ar_IDLE:begin
        if((LSU_araddr == 32'ha0000048)||(LSU_araddr == 32'ha000004c))begin
            state <= LSU_ar_CLINT;
        end
        else state <= LSU_ar_SRAM;
    end
    LSU_aw_IDLE:begin
        if(LSU_awaddr == 32'ha00003f8)begin
            state <= LSU_aw_UART;
        end
        else if((LSU_awaddr == 32'ha0000048)||(LSU_awaddr == 32'ha000004c))begin
            state <= LSU_aw_CLINT;
        end
        else begin
            state <= LSU_aw_SRAM;     
        end 
    end
    LSU_ar_SRAM:begin
        if(IFU_arvalid)begin
            state <= IFU;
        end
        else state <= LSU_ar_SRAM;
    end
    LSU_ar_CLINT:begin
        if(IFU_arvalid)begin
            state <= IFU;
        end
        else state <= LSU_ar_CLINT;
    end
    LSU_aw_SRAM:begin
        if(IFU_arvalid)begin
            state <= IFU;
             aw_state <= 1'b0;
            w_state <= 1'b0;
        end
        else begin 
            state <= LSU_aw_SRAM;
              aw_state <= 1'b0;
            w_state <= 1'b0;
        end
    end
    LSU_aw_UART:begin
        if(IFU_arvalid)begin
            state <= IFU;
              aw_state <= 1'b0;
            w_state <= 1'b0;
        end
        else begin 
            state <= LSU_aw_UART;
            aw_state <= 1'b0;
            w_state <= 1'b0;
        end
    end
    LSU_aw_CLINT:begin
        if(IFU_arvalid)begin
            state <= IFU;
            aw_state <= 1'b0;
            w_state <= 1'b0;
        end
        else begin
            state <= LSU_aw_CLINT;
            aw_state <= 1'b0;
            w_state <= 1'b0;
        end
    end
    endcase
end
end



always@(*)begin
   case(state)
  IFU:begin
    A_SRAM_araddr   = IFU_araddr;
    A_SRAM_arvalid  = IFU_arvalid;
    IFU_arready     = A_SRAM_arready;
    A_SRAM_rready   = IFU_rready;
    IFU_rvalid      = A_SRAM_rvalid;
    IFU_rdata       = A_SRAM_rdata;
    A_SRAM_awaddr   = IFU_awaddr;
    A_SRAM_awvalid  = IFU_awvalid;
    IFU_awready     = A_SRAM_awready;
    A_SRAM_wdata    = IFU_wdata;
    A_SRAM_wstrb    = IFU_wstrb;
    A_SRAM_wvalid   = IFU_wvalid;
    IFU_wready      = A_SRAM_wready;
    IFU_bvalid      = A_SRAM_bvalid;
    A_SRAM_bready   = IFU_bready;

     A_UART_arvalid  = 1'b0;
     A_UART_awvalid  = 1'b0;
     A_UART_wvalid   = 1'b0;
            
  end  
  LSU_ar_SRAM:begin
   // $display("now LSU_awaddr = %h ",LSU_awaddr);
   // $display("LSU_araddr = %h",LSU_araddr);
   // $display("LSU_wstrb = %h",LSU_wstrb);
   // $display("now single %h",((LSU_awaddr > 32'h80000000) && (LSU_awaddr < 32'h80ffffff)) && (((LSU_araddr > 32'h80000000) && (LSU_araddr < 32'h80ffffff))));
             //    $display("here");
                  A_SRAM_araddr   = LSU_araddr;
                  A_SRAM_arvalid  = LSU_arvalid;
                  LSU_arready     = A_SRAM_arready;
                  A_SRAM_rready   = LSU_rready;
                  LSU_rvalid      = A_SRAM_rvalid;
                  LSU_rdata       = A_SRAM_rdata;
                  A_SRAM_awaddr   = 32'b0;
                  A_SRAM_awvalid  = 1'b0;
                  LSU_awready     = A_SRAM_awready;   
                  A_SRAM_wdata    = 32'b0;
                  A_SRAM_wstrb    = LSU_wstrb;
                  A_SRAM_wvalid   = 1'b0;
                  LSU_wready      = A_SRAM_wready;
                  LSU_bvalid      = A_SRAM_bvalid;
                  A_SRAM_bready   = LSU_bready;

                  A_UART_arvalid  = 1'b0;
                  A_UART_awvalid  = 1'b0;
                  A_UART_wvalid   = 1'b0;
  end
  LSU_aw_SRAM:  begin
                  A_SRAM_araddr   = 32'b0;
                  A_SRAM_arvalid  = 1'b0;
                  LSU_arready     = A_SRAM_arready;
                  A_SRAM_rready   = LSU_rready;
                  LSU_rvalid      = A_SRAM_rvalid;
                  LSU_rdata       = A_SRAM_rdata;
                  A_SRAM_awaddr   = LSU_awaddr;
                  A_SRAM_awvalid  = LSU_awvalid;
                  LSU_awready     = A_SRAM_awready;   
                  A_SRAM_wdata    = LSU_wdata;
                  A_SRAM_wstrb    = LSU_wstrb;
                  A_SRAM_wvalid   = LSU_wvalid;
                  LSU_wready      = A_SRAM_wready;
                  LSU_bvalid      = A_SRAM_bvalid;
                  A_SRAM_bready   = LSU_bready;

                  A_UART_arvalid  = 1'b0;
                  A_UART_awvalid  = 1'b0;
                  A_UART_wvalid   = 1'b0;  

                  A_CLINT_arvalid = 1'b0;
                  A_CLINT_awvalid = 1'b0;
                  A_CLINT_wvalid  = 1'b0;      
    end
  LSU_ar_CLINT:begin
       // $display("CLINT");
                  A_CLINT_araddr  = LSU_araddr;
                  A_CLINT_arvalid = LSU_arvalid;
                  LSU_arready     = A_CLINT_arready;
                  A_CLINT_rready  = LSU_rready;
                  LSU_rvalid      = A_CLINT_rvalid;
                  LSU_rdata       = A_CLINT_rdata;
                  A_CLINT_awaddr   = LSU_awaddr;
                  A_CLINT_awvalid  = 1'b0;
                  LSU_awready     = A_CLINT_awready;   
                  A_CLINT_wdata    = LSU_wdata;
                  A_CLINT_wstrb    = LSU_wstrb;
                  A_CLINT_wvalid   = 1'b0;
                  LSU_wready      = A_CLINT_wready;
                  LSU_bvalid      = A_CLINT_bvalid;
                  A_CLINT_bready   = LSU_bready;

                  A_SRAM_arvalid  = 1'b0;
                  A_SRAM_awvalid  = 1'b0;
                  A_SRAM_wvalid   = 1'b0;  

                  A_UART_arvalid  = 1'b0;
                  A_UART_awvalid  = 1'b0;
                  A_UART_wvalid   = 1'b0;        
    end
    LSU_aw_UART:begin
                  A_UART_araddr   = 32'd0;
                  A_UART_arvalid  = 1'b0;
                  LSU_arready     = A_UART_arready;
                  A_UART_rready   = LSU_rready;
                  LSU_rvalid      = A_UART_rvalid;
                  LSU_rdata       = A_UART_rdata;
                  A_UART_awaddr   = LSU_awaddr;
                  A_UART_awvalid  = LSU_awvalid;
                  LSU_awready     = A_UART_awready;   
                  A_UART_wdata    = LSU_wdata;
                  A_UART_wstrb    = LSU_wstrb;
                  A_UART_wvalid   = LSU_wvalid;
                  LSU_wready      = A_UART_wready;
                  LSU_bvalid      = A_UART_bvalid;
                  A_UART_bready   = LSU_bready;

                  A_SRAM_arvalid  = 1'b0;
                  A_SRAM_awvalid  = 1'b0;
                  A_SRAM_wvalid   = 1'b0; 

                  A_CLINT_arvalid = 1'b0;
                  A_CLINT_awvalid = 1'b0;
                  A_CLINT_wvalid  = 1'b0;
    end
    LSU_aw_CLINT:begin
       // $display("CLINT");
                  A_CLINT_araddr  = LSU_araddr;
                  A_CLINT_arvalid = LSU_arvalid;
                  LSU_arready     = A_CLINT_arready;
                  A_CLINT_rready  = LSU_rready;
                  LSU_rvalid      = A_CLINT_rvalid;
                  LSU_rdata       = A_CLINT_rdata;
                  A_CLINT_awaddr   = LSU_awaddr;
                  A_CLINT_awvalid  = LSU_awvalid;
                  LSU_awready     = A_CLINT_awready;   
                  A_CLINT_wdata    = LSU_wdata;
                  A_CLINT_wstrb    = LSU_wstrb;
                  A_CLINT_wvalid   = LSU_wvalid;
                  LSU_wready      = A_CLINT_wready;
                  LSU_bvalid      = A_CLINT_bvalid;
                  A_CLINT_bready   = LSU_bready;

                  A_SRAM_arvalid  = 1'b0;
                  A_SRAM_awvalid  = 1'b0;
                  A_SRAM_wvalid   = 1'b0;  

                  A_UART_arvalid  = 1'b0;
                  A_UART_awvalid  = 1'b0;
                  A_UART_wvalid   = 1'b0;    
    end
    default:begin

    end
   endcase
 
end





endmodule