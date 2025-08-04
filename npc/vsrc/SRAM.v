
module ysyx_25030093_SRAM(
    input                SRAM_arvalid,
    input       [31:0]   SRAM_araddr,
    input                SRAM_rready,
    output reg  [31:0]   SRAM_rdata,
    output reg           SRAM_rvalid,
    output reg           SRAM_arready,
 //------------------------------------------//
    input       [31:0]   SRAM_awaddr,
    input       [31:0]   SRAM_wdata,
    input       [2:0]    SRAM_wstrb,
    input                SRAM_awvalid,
    input                SRAM_wvalid,
    input                SRAM_bready,
    output reg           SRAM_awready,
    output reg           SRAM_wready,
    output reg           SRAM_bvalid,

    input                clk
);
import "DPI-C" function int paddr_read(input int raddr);
   import "DPI-C" function void paddr_write(
  input int waddr, input byte wstrb,input int wdata);



// 读操作
always @(posedge clk) begin
  if(SRAM_arvalid & SRAM_rready)begin
    SRAM_rdata <= paddr_read(SRAM_araddr);
    SRAM_rvalid <= 1'b1;
    SRAM_arready <= 1'b0;
  end
  else begin
    SRAM_rvalid <= 1'b0;
    SRAM_arready <= 1'b1;
  end
end

//写操作
always @(posedge clk) begin
  if(SRAM_awvalid & SRAM_wvalid & SRAM_bready)begin
    paddr_write(SRAM_awaddr,SRAM_wstrb,SRAM_wdata);
    SRAM_awready <= 1'b0;
    SRAM_wready <= 1'b0;
    SRAM_bvalid <= 1'b1;
  end
  else begin
    SRAM_awready <= 1'b1;
    SRAM_wready  <= 1'b1;
    SRAM_bvalid  <= 1'b0;
  end
end






endmodule