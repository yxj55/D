module ysyx_25030093_IFU(
    input clk,
    input rst,
    output valid,
    input ready,
    output [31:0] inst,
    input [31:0] pc
);




// output declaration of module ysyx_25030093_IFU_SRAM


ysyx_25030093_IFU_SRAM u_ysyx_25030093_IFU_SRAM(
    .valid      (valid),
    .ready      (ready),
    .clk       	(clk        ),
    .rst       	(rst        ),
    .pc        	(pc         ),
    .inst_wire 	(inst  )
);



endmodule