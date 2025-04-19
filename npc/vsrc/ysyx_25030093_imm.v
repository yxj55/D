module ysyx_25030093_imm(
    input [31:0] inst,
    input [2:0] imm_type,
    output [31:0] imm_ex
);
    wire [31:0] imm_I;
    assign imm_I={{21{inst[31]}},inst[30:20]};
    assign imm_ex=imm_I;
endmodule
