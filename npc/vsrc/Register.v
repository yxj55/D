module ysyx_25030093_Register #(ADDR_WIDTH = 5, DATA_WIDTH = 32) (
  input clk,
  input [DATA_WIDTH-1:0] wdata,
  input [ADDR_WIDTH-1:0] waddr,
  input wen,
  input [5:0] alu_single,
  input wen_read,
 output [DATA_WIDTH-1:0] rs1_data,
 input [ADDR_WIDTH-1:0] rs1_addr,
 output [DATA_WIDTH-1:0] rs2_data,
 input [ADDR_WIDTH-1:0] rs2_addr

);

  reg [DATA_WIDTH-1:0] rf [2**ADDR_WIDTH-1:0];
  
  always @(posedge clk) begin
     if (wen & waddr != 0) begin
   // $display("Write: addr=%d, wdata=%h, stored=%h wen=%d", waddr, wdata, rf[waddr],wen);
    rf[waddr] <= wdata;
    end
  end

  assign rs1_data=((rs1_addr == 0)&(wen_read == 1'b1))?0:rf[rs1_addr];
  assign rs2_data=((rs2_addr == 0)&(wen_read == 1'b1))?0:rf[rs2_addr];


endmodule
