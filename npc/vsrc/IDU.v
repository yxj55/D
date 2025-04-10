module ysyx_25030093_IDU(
    input [31:0] inst
);
wire [4:0] rs1;
wire [4:0] rd;
wire [6:0] op;
assign op=inst[6:0];


//11位立即数
wire [11:0] imm;
wire imm= (op==0010011) ? inst[31:20]: 



endmodule