
module ysyx_25030093_LSU(
    input                in_valid,
    input                in_ready,
    output               out_ready,
    output               out_valid,
    input       [31:0]   rd_data,
    input       [31:0]   rs2_data,
    output reg  [31:0]   LSU_data,
    input       [3:0]    LSU_single,
    input                clk
);

parameter IDLE =2'b00,Prepare_data = 2'b01,Occurrence_data = 2'b10;

reg [1:0] state;

reg [7:0] lb_temp; 
reg [15:0] lh_temp;

always@(posedge clk)begin
  case(state)
IDLE:begin
  if(in_valid & in_ready)begin
    state <= Prepare_data;
  end
  else begin
    state <= IDLE;
    LSU_run <= 1'b0;
  end
end
Prepare_data:begin
 case(LSU_single)

 endcase
end
Occurrence_data:begin
  state <= IDLE;
  LSU_run <= 1'b0;
end
  endcase
end

assign out_ready = (state == IDLE);
assign out_valid = (state == Occurrence_data);






endmodule