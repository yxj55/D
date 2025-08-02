module ysyx_25030093_pc(
    input [2:0] pc_single,
    input [31:0] rs1_data,
    input [31:0] imm_data,
    input rst,
    input clk,
    output reg [31:0] pc,
    input B_single,
    input [31:0] csr_data_pc,
    input [31:0] inst,
    input in_valid_WBU
);


import "DPI-C" function void call_ftrace_printf(input int pc,input int dnpc);
import "DPI-C" function void ret_ftrace_printf(input int pc);

initial begin
    pc = 32'h80000000;
end


reg [31:0] pc_current;
always@(posedge clk)begin
    if(rst) begin
        pc_current <=32'h80000000;
    end
    else begin
      if(in_valid_WBU) begin
        case(pc_single)
       3'b001:begin
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
       3'b010:begin 
        
        // call_ftrace_printf(pc_current, pc_current + imm_data);
      
         pc_current <= pc_current + imm_data;//jal
     
       end
       3'b100:begin
         pc_current <= (B_single) ? pc_current + imm_data  : pc_current + 32'd4;
       end
       3'b101:begin
         pc_current <= csr_data_pc;
       end
       3'b110:begin
      
           pc_current <= pc_current + 32'd4;
       end
        default:pc_current <= pc_current ;
        endcase
        end
    end
    end

assign pc = pc_current;
endmodule