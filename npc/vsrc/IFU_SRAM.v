module ysyx_25030093_IFU_SRAM(
    output  reg valid,
    input ready,
    input clk,
    input rst,
    input [31:0] pc,
    output reg [31:0] inst_wire
);
import "DPI-C" function int paddr_read(input int raddr,input int len);

parameter IDLE =1'b0,WAIT_READY = 1'b1;

reg state;
     reg [31:0] inst;
    // reg [31:0] inst_delay;

     always@(posedge clk)begin
        if(rst)begin
            inst_wire  <=  32'd0;  
            valid <= 1'b0;
        end
        else begin
           case(state)
           IDLE:begin
            if(1)begin
                state <= WAIT_READY;
                valid <= 1'b1;
            end
            else begin
                state <=IDLE;
                valid <= 1'b0;
            end
           end
           WAIT_READY:begin
            if(ready)begin
                inst_wire <= paddr_read(pc,4);
                state <= IDLE;
                valid <=1'b0;
            end
            else begin
                state <= WAIT_READY;
                valid <= valid;
            end
           end
           endcase
        end
        
     end
     /*
   always @(posedge clk) begin
    if (valid) begin
        inst_delay <= inst; // 记录当前的inst到延迟寄存器
    end
end
*/
//assign inst_wire = inst;
endmodule