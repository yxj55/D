
module ysyx_25030093_imm(
    input       [31:0]        inst,
    input       [1:0]         imm_type,
    output reg  [31:0]        imm_ex
);
   
   always@(*)begin
    case(imm_type)
    2'b00: imm_ex =  {{21{inst[31]}},inst[30:20]}; //I-type
    2'b01: imm_ex = {inst[31:12],{12{1'b0}}};  //U-type
    2'b10: imm_ex = {{21{inst[31]}},inst[30:25],inst[11:8],inst[7]}; //S-type
    default: imm_ex =32'd0;
    endcase
   // $display("imm_ex :%h",imm_ex);
   end
   
endmodule
