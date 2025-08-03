
module ysyx_25030093_EXU(
    output wire                 out_valid,
    output wire                 out_ready,
    input                       in_valid,
    input                       in_ready,
    input                       clk,
    input                       rst,
    input      [4:0]            alu_single,
    input wire [31:0]           rs2_data,
    output reg [31:0]           rd_data,
    output reg                  B_single,
    input wire [31:0]           csr_data,
    output reg [31:0]           csr_wdata,
    input      [31:0]           alu_data2,
    input      [31:0]           alu_data1
);

parameter IDLE =2'b00,Prepare_data = 2'b01,Occurrence_data = 2'b10;

reg [1:0] state;
reg alu_run;


always@(posedge clk)begin
    if(rst)begin
        state <= IDLE;
    end
    else begin
        case(state)
        IDLE:begin
           if(in_ready & in_valid) begin
                state <= Prepare_data;
           end
           else begin
            alu_run <= 1'b0;
            state <= IDLE;
        end
           end 
        Prepare_data:begin
            alu_run <= 1'b1;
            state <= Occurrence_data;
        end
        Occurrence_data:begin
            state <= IDLE;
            alu_run <= 1'b0;
        end
        endcase
    end
end

assign out_ready = (state == IDLE);
assign out_valid =  (state == Occurrence_data);







ysyx_25030093_alu u_ysyx_25030093_alu(
   .alu_run     (alu_run),
    .alu_single  (alu_single),
    .rd_data      	(rd_data       ),
    
    .B_single        (B_single),
     .csr_data   (csr_data),
    .csr_wdata  (csr_wdata),
    .alu_data2  (alu_data2),
    .alu_data1  ( alu_data1)
);


endmodule