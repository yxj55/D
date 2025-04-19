module ysyx_25030093_IFU(
    input clk,
    output reg [31:0] io_pc,
    input rst
);
   reg [31:0] pc;
    always @(posedge clk) begin
        if (rst) begin
            pc <= 32'h8000_0000; // 复位时PC初始值
        end else begin
            pc <=pc+4; // 每个时钟周期+4
        end
    end
assign io_pc=pc;

endmodule
