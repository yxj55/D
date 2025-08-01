module ysyx_25030093_mux41(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] y,
    input [1:0] s
);

always @(*) begin
   
    case(s)
    2'b00: y = a;
    2'b01: y = b;
    2'b10: y = 32'd4;
    2'b11: y = 32'd0;

    endcase
end



endmodule