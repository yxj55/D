module ysyx_25030093_IFU_SRAM(
    input in_valid,
    output  wire valid,
    input ready,
    input clk,
    input rst,
    input [31:0] pc,
    output reg [31:0] inst_wire
);
import "DPI-C" function int paddr_read(input int raddr,input int len);

parameter IDLE =2'b00,Prepare_data = 2'b01,Occurrence_data = 2'b10;

reg [1:0] state;


always@(posedge clk)begin
    if(rst)begin
        state <= Prepare_data;
    end
    else begin
        case(state)
        IDLE:begin
           if(ready & in_valid) begin
                state <= Prepare_data;
           end
           else state <= IDLE;
        end
        Prepare_data:begin
            inst_wire <= paddr_read(pc,4);
            state <= Occurrence_data;
        end
        Occurrence_data:begin
            state <= IDLE;
        end
        endcase
    end
end

     assign valid = (state == Occurrence_data);
     /*
   always @(posedge clk) begin
    if (valid) begin
        inst_delay <= inst; // 记录当前的inst到延迟寄存器
    end
end
*/
//assign inst_wire = inst;
endmodule