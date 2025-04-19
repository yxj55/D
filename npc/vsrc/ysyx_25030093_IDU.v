module ysyx_25030093_IDU(
    input [31:0] inst,
    output [2:0] imm_type,
    output Regwrite
);
import "DPI-C" function void npc_ebreak();

parameter I=3'b000;
assign imm_type=I;
assign Regwrite=1;
always@(inst)begin
    if(inst[31:20]==12'b000000000001&&inst[6:0]==7'b1110011)begin
        npc_ebreak();
    end
end

endmodule
