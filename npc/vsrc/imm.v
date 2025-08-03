
module ysyx_25030093_imm(
    input       [31:0]        inst,
    input       [2:0]         imm_type,
    output reg  [31:0]        imm_ex
);
   
   always@(*)begin
    case(imm_type)
    3'b000: imm_ex =  {{21{inst[31]}},inst[30:20]}; //I-type
    3'b001: imm_ex = {inst[31:12],{12{1'b0}}};  //U-type
    3'b010: imm_ex = {{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0}; //J-type
    3'b011: imm_ex = {{21{inst[31]}},inst[30:25],inst[11:8],inst[7]}; //S-type
    3'b100: imm_ex = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0}; //B-type
    default: imm_ex =32'd4;
    endcase
   // $display("imm_ex :%h",imm_ex);
   end
   
endmodule
