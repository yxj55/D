module ysyx_25030093_EXU(
    input clk,
    input rst,
    input [4:0] alu_single,
    input wire [31:0] rs2_data,
    output reg [31:0] rd_data,
    output reg B_single,
    input wire [31:0] csr_data,
    output reg [31:0] csr_wdata,
    input [31:0] alu_data2,
    input [31:0] alu_data1
  //  input in_valid
);
/*
reg state;
always @(posedge clk) begin
    if(rst)begin
        
    end
end
*/





ysyx_25030093_alu u_ysyx_25030093_alu(
    .alu_single  (alu_single),
    .rd_data      	(rd_data       ),
    
    .B_single        (B_single),
     .csr_data   (csr_data),
    .csr_wdata  (csr_wdata),
    .alu_data2  (alu_data2),
    .alu_data1  ( alu_data1)
);


endmodule