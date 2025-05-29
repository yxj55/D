module ysyx_25030093_pc(
    input [1:0] pc_single,
    input [31:0] rs1_data,
    input [31:0] imm_data,
    input rst,
    input clk,
    output reg [31:0] pc,
    input B_single
);


import "DPI-C" function void call_ftrace_printf(input int pc,input int dnpc);
import "DPI-C" function void ret_ftrace_printf(input int pc);



reg [31:0] pc_current;
always@(posedge clk)begin
    if(rst) begin
        pc_current <=32'h80000000;
    end
    else begin
        case(pc_single)
       2'b01:begin
       /*
        if(inst == 32'h00008067)begin
            ret_ftrace_printf(pc_current);
        end
        else begin
            call_ftrace_printf(pc_current,(rs1_data + imm_data)& (~32'h1));
        end
       */
            pc_current <= (rs1_data + imm_data)& (~32'h1);//jalr
       end
       2'b10:begin 
        /*
         call_ftrace_printf(pc_current, pc_current + imm_data);
       */
         pc_current <= pc_current + imm_data;//jal
        
       end
       2'b11:begin
         pc_current <= (B_single) ? pc_current + imm_data  : pc_current + 32'd4;
       end
        default:pc_current <= pc_current + 32'd4;
        endcase
   
    end
end
assign pc = pc_current;
endmodule