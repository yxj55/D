module ysyx_25030093_IFU(
    input in_valid,
    input clk,
    input rst,
    output valid,
    input ready,
    output [31:0] inst_wire,
    input [31:0] pc
);




// output declaration of module ysyx_25030093_IFU_SRAM


ysyx_25030093_IFU_SRAM u_ysyx_25030093_IFU_SRAM(
    .in_valid  (in_valid),
    .valid      (valid),
    .ready      (ready),
    .clk       	(clk        ),
    .rst       	(rst        ),
    .pc        	(pc         ),
    .inst_wire 	(inst_wire  )
);



endmodule