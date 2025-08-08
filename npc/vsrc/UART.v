module ysyx_25030093_UART(
    input                  clk,

//---------------读地址----------------//    
    input      [31:0]      UART_araddr,
    input                  UART_arvalid,
    output reg             UART_arready,
//---------------读数据----------------//    
    output reg             UART_rvalid,
    output reg [31:0]      UART_rdata,
    input                  UART_rready,
//---------------写地址----------------// ,
    input      [31:0]      UART_awaddr,
    input                  UART_awvalid,
    output reg             UART_awready,
//---------------写数据----------------//  
    input      [31:0]      UART_wdata,
    input                  UART_wvalid,
    input      [7:0]       UART_wstrb,
    output reg             UART_wready,
//---------------写回复----------------//  
    input                  UART_bready,
    output reg             UART_bvalid

);
import "DPI-C" function int paddr_read(input int raddr);
   import "DPI-C" function void paddr_write(
  input int waddr, input byte wstrb,input int wdata);

//读地址
always @(posedge clk) begin
    if(UART_arvalid)begin
        UART_arready <= 1'b1;
    end
    else UART_arready <= 1'b0;
end

//读数据
always @(posedge clk) begin
    if(UART_arvalid & UART_arready)begin
        UART_rdata <= paddr_read(UART_araddr);
        UART_rvalid <= 1'b1;
    end
    else if(UART_rready) UART_rvalid <= 1'b0;
end


//写地址
reg UART_aw_state;//标志位
always @(posedge clk) begin
    if(UART_awvalid)begin
        UART_aw_state <= 1'b1;
        UART_awready <= 1'b1;
    end
    else UART_awready <= 1'b0;
end

//写数据
reg UART_w_state;
always @(posedge clk) begin
    if(UART_wvalid)begin
        UART_w_state <= 1'b1;
        UART_wready <= 1'b1;
    end
    else UART_wready <= 1'b0;
end

always @(posedge clk) begin
    if(UART_aw_state & UART_w_state)begin
      //  $display("now UART_wdata",UART_wdata);
        $write("%s",UART_wdata[7:0]);
        UART_bvalid <= 1'b1;
        UART_aw_state <= 1'b0;
        UART_w_state <= 1'b0;
    end
    else if(UART_bready) UART_bvalid <= 1'b0;
end



endmodule