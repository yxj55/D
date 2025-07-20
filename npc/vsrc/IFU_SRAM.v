module ysyx_25030093_IFU_SRAM(
    output  reg valid,
    input ready,
    input clk,
    input rst,
    input [31:0] pc,
    output  [31:0] inst_wire
);
import "DPI-C" function int paddr_read(input int raddr,input int len);
     reg [31:0] inst;
    // reg [31:0] inst_delay;

     always@(posedge clk)begin
        if(rst)begin
            inst  <=  32'd0;  
            valid <= 1'b0;
        end
        else begin
            if(ready) begin
                inst <= paddr_read(pc,4);
                valid <= !valid;
            end 
        end
        
     end
     /*
   always @(posedge clk) begin
    if (valid) begin
        inst_delay <= inst; // 记录当前的inst到延迟寄存器
    end
end
*/
assign inst_wire = inst;
endmodule