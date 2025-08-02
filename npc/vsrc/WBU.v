module ysyx_25030093_WBU(
   input in_valid,
   output out_valid,
   output out_ready,
   input rst,
   input clk,
   input [31:0] rd_data,
   input [31:0] rs2_data,
   output  [31:0] LSU_data,
   input [3:0] LSU_single,
   input rd_or_LSU_single
);

parameter IDLE =2'b00,Prepare_data = 2'b01,Occurrence_data = 2'b10;

reg [1:0] state;



always@(posedge clk)begin
    if(rst)begin
        state <= IDLE;
    end
    else begin
        case(state)
        IDLE:begin
           if(in_valid) begin
                state <= Prepare_data;
           end
           else state <= IDLE;
        end
        Prepare_data:begin
            state <= Occurrence_data;
        end
        Occurrence_data:begin
            state <= IDLE;
        end
        endcase
    end
end


assign out_ready = (state == IDLE);
assign out_valid = (state == Occurrence_data);


ysyx_25030093_LSU u_ysyx_25030093_LSU(
    .clk        	(clk         ),
    .rd_data    	(rd_data     ),
    .rs2_data   	(rs2_data    ),
    .LSU_data   	(LSU_data    ),
    .LSU_single 	(LSU_single  ),
    .rd_or_LSU_single (rd_or_LSU_single)
);




endmodule