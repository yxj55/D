
module ysyx_25030093_LSU(
    input                in_valid,
    input                in_ready,
    output               out_ready,
    output               out_valid,
    input       [31:0]   rd_data,
    input       [31:0]   rs2_data,
    output reg  [31:0]   LSU_data,
    input       [2:0]    LSU_single,
    input                clock,
    input                reset,
    output reg           lsu_reqValid,  
    output reg  [31:0]   lsu_addr,      
    output reg  [1:0]    lsu_size,      
    output reg           lsu_wen,       
    output reg  [31:0]   lsu_wdata,     
    output reg  [3:0]    lsu_wmask,     
    input                lsu_respValid, 
    input       [31:0]   lsu_rdata     
);

assign  lsu_wen = ((LSU_single == 3'b100) | (LSU_single == 3'b011)) ? 1'b1 : 1'b0;
assign  lsu_size= ((LSU_single == 3'b001) | (LSU_single == 3'b011)) ? 2'b10 : 2'b00;//lw sw 4字节  lbu sb 1字节

wire  UART_or_RAM_or_Flash;

assign UART_or_RAM_or_Flash = ((rd_data >= 32'h10000000) & (rd_data <= 32'h10000fff)) | ((rd_data >= 32'h80000000) & (rd_data <= 32'h81ffffff)) ? 1'b1 : 1'b0;

parameter IDLE =2'b00,Prepare_data = 2'b01,Occurrence_data = 2'b10;

reg [1:0] state;

wire [31:0] offset;

always@(posedge clock)begin
  if(reset)begin
    state <= IDLE;
  end
  else begin
  case(state)
IDLE:begin
  if(in_valid & in_ready)begin
    state        <= Prepare_data;
    lsu_addr     <= (UART_or_RAM_or_Flash)&(LSU_single != 3'b000)? rd_data : {rd_data[31:2],2'b00};
    lsu_reqValid <= (LSU_single != 3'b000) ? 1'b1 : 1'b0;
    lsu_wmask    <= (LSU_single != 3'b000) ? wstrb : 4'b0;
    lsu_wdata    <= (UART_or_RAM_or_Flash) &(LSU_single != 3'b000) ? rs2_data << offset: rs2_data ;
  end
  else begin
    state <= IDLE;
  end
end
Prepare_data:begin
  lsu_reqValid <= 1'b0;
if(lsu_respValid & !lsu_wen ) begin
  case(LSU_single)
    3'b001:begin//lw
      LSU_data <= lsu_rdata;
      state    <= Occurrence_data;
    end
    3'b010:begin//lbu
      case(rd_data[1:0])
    2'b00:  LSU_data <= {{24{1'b0}},lsu_rdata[7:0]};
    2'b01:  LSU_data <= {{24{1'b0}},lsu_rdata[15:8]};
    2'b10:  LSU_data <= {{24{1'b0}},lsu_rdata[23:16]};
    2'b11:  LSU_data <= {{24{1'b0}},lsu_rdata[31:24]};
    endcase
      state    <= Occurrence_data;
    end
    default:begin
      state <= Prepare_data;
    end
   endcase
end
else if(lsu_respValid & lsu_wen) begin
  state <= Occurrence_data;
end
else if(LSU_single == 3'b000)begin
  state <= Occurrence_data;
end
else begin
      state <= Prepare_data;
end
end
Occurrence_data:begin
  state <= IDLE;
end
default:begin
  state <= IDLE;
end
  endcase
  end
end

assign out_ready = (state == IDLE);
assign out_valid = (state == Occurrence_data);



wire [3:0] wstrb;
assign wstrb  =   ((rd_data[1:0] == 2'b00) & (LSU_single == 3'b100)) ? 4'b0001 :
                  ((rd_data[1:0] == 2'b01) & (LSU_single == 3'b100)) ? 4'b0010 :
                  ((rd_data[1:0] == 2'b10) & (LSU_single == 3'b100)) ? 4'b0100 :
                  ((rd_data[1:0] == 2'b11) & (LSU_single == 3'b100)) ? 4'b1000 :
                  (LSU_single == 3'b011) ? 4'b1111 :
                  4'b0001;
assign offset =   ((wstrb == 4'b0001) & (LSU_single == 3'b100)) ?  32'd0 :
                  ((wstrb == 4'b0010) & (LSU_single == 3'b100)) ?  32'd8 :
                  ((wstrb == 4'b0100) & (LSU_single == 3'b100)) ?  32'd16 :
                  ((wstrb == 4'b1000) & (LSU_single == 3'b100)) ?  32'd24 :
                  (LSU_single == 3'b011) ? 32'd0 : 32'd0;
                 




endmodule