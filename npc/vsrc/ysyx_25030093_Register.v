module ysyx_25030093_Register #(ADDR_WIDTH = 5, DATA_WIDTH = 32) (
  input clk,
  input [DATA_WIDTH-1:0] wdata,
  input [ADDR_WIDTH-1:0] waddr,
  input
 wen,
 output [DATA_WIDTH-1:0] rs1_data,
 input [ADDR_WIDTH-1:0] rs1_addr
);
  reg [DATA_WIDTH-1:0] rf [2**ADDR_WIDTH-1:0];
  always @(posedge clk) begin
    if (wen & waddr != 0) rf[waddr] <= wdata;
  end
  assign rs1_data=(rs1_addr == 0)?0:rf[rs1_addr];

 


endmodule
