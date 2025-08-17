
module ysyx_25030093_mux21(
    input [31:0] a,
    input [31:0] b,
    input s,
    output  reg [31:0] o
);

always @(*) begin
    case(s)
    1'b1: o = a;
    1'b0: o = b;
    endcase
end

endmodule