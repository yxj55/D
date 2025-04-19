module ysyx_25030093_addi(
    input wire [31:0] rs1_data,
    input wire [31:0] imm_data,
    output wire [31:0] rd_data
    );
    assign rd_data=rs1_data + imm_data;


endmodule
