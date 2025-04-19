module ysyx_25030093_top(
    input clk,
    output reg [31:0] io_pc,
    input wire [31:0] inst,
    input wire rst
);
// output declaration of module ysyx_25030093_IFU
ysyx_25030093_IFU u_ysyx_25030093_IFU(
    .clk   	(clk    ),
    .io_pc 	(io_pc  ),
    .rst   	(rst    )
);

// output declaration of module ysyx_25030093_IDU
wire [2:0] imm_type;
wire Regwrite;

ysyx_25030093_IDU #(
    .I 	(000  ))
u_ysyx_25030093_IDU(
    .inst       (inst),
    .imm_type 	(imm_type  ),
    .Regwrite 	(Regwrite  )
);

wire [4:0] rd,rs1;
wire [31:0] imm_data;
assign rd=inst[11:7];
assign rs1=inst[19:15];
ysyx_25030093_imm u_ysyx_25030093_imm(
    .inst (inst),
    .imm_type (imm_type),
    .imm_ex (imm_data)
);

ysyx_25030093_EXU u_ysyx_25030093_EXU(
    .clk      	(clk       ),
    .imm_data 	(imm_data  ),
    .Regwrite 	(Regwrite  ),
    .rd       	(rd        ),
    .rs1      	(rs1       )
);



endmodule
