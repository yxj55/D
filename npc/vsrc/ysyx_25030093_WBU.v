module ysyx_25030093_WBU(
   input                in_valid,
   output               out_valid,
   output               out_ready,
   input                reset,
   input                clock,
   input   [31:0]       rd_data,
   input   [31:0]       LSU_data,
   input                rd_or_LSU_single,
   output  [31:0]       WBU_data
);

parameter IDLE =2'b00,Prepare_data = 2'b01,Occurrence_data = 2'b10;

reg [1:0] state;


always@(posedge clock)begin
    if(reset)begin
        state <= IDLE;
    end
    else begin
        case(state)
        IDLE:begin
           if(in_valid) begin
                state <= Prepare_data;
           end
           else begin
            state <= IDLE;
           end
            
        end
        Prepare_data:begin
            state <= Occurrence_data;
        end
        Occurrence_data:begin
            state <= IDLE;
        end
        default:begin
            state <= IDLE;
        end
        endcase
    end
end


assign out_ready = (state == IDLE);
assign out_valid = (state == Occurrence_data);


assign WBU_data = ((rd_or_LSU_single) & out_valid ) ? LSU_data : rd_data;



endmodule