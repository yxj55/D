module ysyx_25030093_LSU(
    input LSU_run,
    input clk,
    input [31:0] rd_data,
    input [31:0] rs2_data,
    output reg [31:0] LSU_data,
    input [3:0] LSU_single
);
import "DPI-C" function int paddr_read(input int raddr,input int len);
   import "DPI-C" function void paddr_write(
  input int waddr, input int len,input int wdata);


reg [7:0] lb_temp; 
reg [15:0] lh_temp;

always @(*) begin
  if(LSU_run) begin
    case(LSU_single)
    4'd0:begin
         lb_temp = paddr_read(rd_data ,1);//lb
         LSU_data = {{24{lb_temp[7]}},lb_temp};
    end
    4'd1:begin
        lh_temp = paddr_read(rd_data ,2);//lh
         LSU_data = {{16{lh_temp[15]}},lh_temp};
    end
     4'd2:LSU_data = paddr_read(rd_data,4); //lw
    4'd3:LSU_data = paddr_read(rd_data,1);//lbu
    4'd4:LSU_data = paddr_read(rd_data,2);//lhu
    4'd5:paddr_write(rd_data,1,rs2_data);//sb
    4'd6:paddr_write(rd_data,2,rs2_data);//sh
    4'd7: paddr_write(rd_data,4,rs2_data);//sw
    default:begin
        
    end
    endcase
  end
end



endmodule