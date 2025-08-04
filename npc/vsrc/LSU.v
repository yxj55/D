
module ysyx_25030093_LSU(
    input                in_valid,
    input                in_ready,
    output               out_ready,
    output               out_valid,
    input       [31:0]   rd_data,
    output reg  [31:0]   LSU_data,
    input       [3:0]    LSU_single,
    input                clk,
 //------------------------------------------//
    input       [31:0]   SRAM_LSU_rdata,  // SRAM 读数据
    input                SRAM_LSU_arready, //SRAM 读就绪
    input                SRAM_LSU_rvalid, //读数据有效
    output reg  [31:0]   LSU_SRAM_araddr,//读地址
    output reg           LSU_SRAM_arvalid,//读地址有效
    output reg           LSU_SRAM_rready,
 //------------------------------------------//


);

parameter IDLE =2'b00,Prepare_data = 2'b01,Occurrence_data = 2'b10;

reg [1:0] state;

always@(posedge clk)begin
  case(state)
IDLE:begin
  if(in_valid & in_ready)begin
    state <= Prepare_data;
  end
  else begin
    state <= IDLE;
  end
end
Prepare_data:begin
if(SRAM_LSU_rvalid) begin
  case(LSU_single)
    4'd0:begin//lb
      LSU_data <= {{24{SRAM_LSU_rdata[7]}},SRAM_LSU_rdata[7:0]};
      state    <= Occurrence_data;
    end
    4'd1:begin//lh
      LSU_data <= {{16{SRAM_LSU_rdata[15]}},SRAM_LSU_rdata[15:0]};
      state    <= Occurrence_data;
    end
    4'd2:begin//lw
      LSU_data <= SRAM_LSU_rdata;
      state    <= Occurrence_data;
    end
    4'd3:begin//lbu
      LSU_data <= {{24{1'b0}},SRAM_LSU_rdata[7:0]};
      state    <= Occurrence_data;
    end
    4'd4:begin//lhu
      LSU_data <= {{16{1'b0}},SRAM_LSU_rdata[15:0]};
      state    <= Occurrence_data;
    end
   endcase
end
else state <= Prepare_data;
end
Occurrence_data:begin
  state <= IDLE;
end
  endcase
end

assign out_ready = (state == IDLE);
assign out_valid = (state == Occurrence_data);

//读操作
always@(posedge clk)begin
  if(SRAM_LSU_arready)begin
    LSU_SRAM_araddr <= rd_data;
    LSU_SRAM_arvalid <= 1'b1; 
    LSU_SRAM_rready   <= 1'b1;
  end
  else begin
    LSU_SRAM_arvalid <=1'b0;
    LSU_SRAM_rready  <= 1'b0;
  end
end




endmodule