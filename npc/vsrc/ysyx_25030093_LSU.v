
module ysyx_25030093_LSU(
    input                in_valid,
    input                in_ready,
    output               out_ready,
    output               out_valid,
    input                LOAD_single,
    input                STORE_single,
    input       [31:0]   rd_data,
    input       [31:0]   rs2_data,
    output reg  [31:0]   LSU_data,
    input       [3:0]    LSU_single,
    input                clock,
    input                reset,
    output      [31:0]   offset,
//---------------------读数据-------------------//
    input       [31:0]   LSU_rdata,  //   读数据
    input                LSU_rvalid, //读数据有效
    output reg           LSU_rready,
    input       [1:0]    LSU_rresp,
    input                LSU_rlast,
    input       [3:0]    LSU_rid,
//---------------------读地址-------------------//    
    input                LSU_arready, //  读就绪
    output reg  [31:0]   LSU_araddr,//读地址
    output reg           LSU_arvalid,//读地址有效
    output reg  [3:0]    LSU_arid,
    output reg  [7:0]    LSU_arlen,
    output reg  [2:0]    LSU_arsize,
    output reg  [1:0]    LSU_arburst,
//---------------------写地址-------------------//
    input                LSU_awready,// 写地址就绪
    output reg  [31:0]   LSU_awaddr,//写地址
    output reg           LSU_awvalid,//地址有效
    output reg  [3:0]    LSU_awid,
    output reg  [7:0]    LSU_awlen,
    output reg  [2:0]    LSU_awsize,
    output reg  [1:0]    LSU_awburst,
//---------------------写数据-------------------//
    output reg  [31:0]   LSU_wdata,//写数据
    output reg  [3:0]    LSU_wstrb,//掩码
    output reg           LSU_wvalid,//数据有效
    input                LSU_wready,// 写数据有效
    output reg           LSU_wlast,
//---------------------写回复-------------------//
    output reg           LSU_bready, // 写回复就绪
    input                LSU_bvalid,//写回复有效
    input       [1:0]    LSU_bresp,
    input       [3:0]    LSU_bid
);




parameter IDLE =2'b00,Prepare_data = 2'b01,Occurrence_data = 2'b10;

reg [1:0] state;

always@(posedge clock)begin
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
if(LSU_rvalid & LSU_rready) begin
  case(LSU_single)
    4'd0:begin//lb
    case(rd_data[1:0])
    2'b00:  LSU_data <= {{24{LSU_rdata[7]}},LSU_rdata[7:0]};
    2'b01:  LSU_data <= {{24{LSU_rdata[15]}},LSU_rdata[15:8]};
    2'b10:  LSU_data <= {{24{LSU_rdata[23]}},LSU_rdata[23:16]};
    2'b11:  LSU_data <= {{24{LSU_rdata[31]}},LSU_rdata[31:24]};
    endcase
      state    <= Occurrence_data;
    end
    4'd1:begin//lh
    case(rd_data[1:0])
    2'b00:  LSU_data <=  {{16{LSU_rdata[15]}},LSU_rdata[15:0]};
    2'b01:  LSU_data <=  {{16{LSU_rdata[15]}},LSU_rdata[15:0]};
    2'b10:  LSU_data <=  {{16{LSU_rdata[31]}},LSU_rdata[31:16]};
    2'b11:  LSU_data <=  {{16{LSU_rdata[31]}},LSU_rdata[31:16]};
    endcase
      state    <= Occurrence_data;
    end
    4'd2:begin//lw
      LSU_data <= LSU_rdata;
      state    <= Occurrence_data;
    end
    4'd3:begin//lbu
      case(rd_data[1:0])
    2'b00:  LSU_data <= {{24{1'b0}},LSU_rdata[7:0]};
    2'b01:  LSU_data <= {{24{1'b0}},LSU_rdata[15:8]};
    2'b10:  LSU_data <= {{24{1'b0}},LSU_rdata[23:16]};
    2'b11:  LSU_data <= {{24{1'b0}},LSU_rdata[31:24]};
    endcase
      state    <= Occurrence_data;
    end
    4'd4:begin//lhu
      case(rd_data[1:0])
    2'b00:  LSU_data <=  {{16{1'b0}},LSU_rdata[15:0]};
    2'b01:  LSU_data <=  {{16{1'b0}},LSU_rdata[15:0]};
    2'b10:  LSU_data <=  {{16{1'b0}},LSU_rdata[31:16]};
    2'b11:  LSU_data <=  {{16{1'b0}},LSU_rdata[31:16]};
    endcase
      state    <= Occurrence_data;
    end
    default:begin
      state <= Prepare_data;
    end
   endcase
end
else if(LSU_bvalid & LSU_bready) begin
  state <= Occurrence_data;
end
else if(LSU_single == 4'd8) begin
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

assign out_ready = (state == IDLE);
assign out_valid = (state == Occurrence_data);


reg ar_state;

//读操作

// output declaration of module random_delay_generator
// wire ar_ready;
// random_delay_generator ar_random_delay_generator(
//   .dynamic_seed (8'd124),
//   .clock     	(clock      ),
//   .reset   	(reset    ),
//   .request 	( LOAD_single & in_ready & in_valid ),
//   .ready   	(ar_ready    )
// );


//读地址
always@(posedge clock)begin
  if(LOAD_single & in_ready & in_valid)begin
    ar_state <= 1'b1; 
  end
  else if(ar_state )begin
    LSU_araddr <= rd_data;
    LSU_arvalid <= 1'b1;
    LSU_arburst <= 2'b01;
    LSU_arlen <= 8'b0; 
    if((LSU_single == 4'd0)|(LSU_single == 4'd3))begin
      LSU_arsize <= 3'd0;
    end
    else if((LSU_single == 4'd1)|(LSU_single == 4'd4))begin
      LSU_arsize <= 3'd1;
    end
    else if(LSU_single == 4'd2)begin
      LSU_arsize <= 3'd2;
    end
    ar_state <= 1'b0;
  end
  else if(LSU_arready) begin //检查 arready 下周期拉低 arvalid
    LSU_arvalid <=1'b0;
  end

end


// output declaration of module random_delay_generator
// wire r_ready;

// random_delay_generator r_random_delay_generator(
//   .dynamic_seed (8'd231),
//   .clock     	(clock      ),
//   .reset   	(reset    ),
//   .request 	(LSU_rvalid  ),
//   .ready   	(r_ready    )
// );




//读数据
always@(posedge clock)begin
    if(LSU_rvalid )begin
        LSU_rready <=1'b1;
    end
    else  begin
        LSU_rready <=1'b0;
    end
end


//写操作
//写地址

// output declaration of module random_delay_generator
// wire aw_ready;

// random_delay_generator aw_random_delay_generator(
//   .dynamic_seed (8'd154),
//   .clock     	(clock      ),
//   .reset   	(reset    ),
//   .request 	(in_ready & in_valid & STORE_single  ),
//   .ready   	(aw_ready    )
// );


assign LSU_awid = 4'b0;
assign LSU_arid = 4'b0;
reg awaddr_state;

always@(posedge clock)begin
   if(in_ready & in_valid & STORE_single)begin
     awaddr_state <= 1'b1;
   end
   else if(awaddr_state )begin
    // $display("addr =%h",{rd_data[31:2], 2'b00});
    LSU_awaddr  <= rd_data;
    LSU_awvalid <=1'b1;
    LSU_awburst <= 2'b01;
    LSU_awlen   <= 8'd0;
    if(LSU_single == 4'd5)begin//sb
      LSU_awsize <= 3'd0;
    end
    else if(LSU_single == 4'd6)begin//sh
      LSU_awsize <= 3'd1;
    end
    else if(LSU_single == 4'd7)begin//sw
      LSU_awsize <= 3'd2;
    end
    awaddr_state<= 1'b0;
  end
  else if(LSU_awready) begin
    LSU_awvalid <= 1'b0;
  end 
 
end


wire [3:0] wstrb;
assign wstrb  =   ((rd_data[1:0] == 2'b00) & (LSU_single == 4'd5)) ? 4'b0001 :
                  ((rd_data[1:0] == 2'b01) & (LSU_single == 4'd5)) ? 4'b0010 :
                  ((rd_data[1:0] == 2'b10) & (LSU_single == 4'd5)) ? 4'b0100 :
                  ((rd_data[1:0] == 2'b11) & (LSU_single == 4'd5)) ? 4'b1000 :
                  ((rd_data[1:0] == 2'b00) & (LSU_single == 4'd6)) ? 4'b0011 :
                  ((rd_data[1:0] == 2'b01) & (LSU_single == 4'd6)) ? 4'b0011 :
                  ((rd_data[1:0] == 2'b10) & (LSU_single == 4'd6)) ? 4'b1100 :
                  ((rd_data[1:0] == 2'b11) & (LSU_single == 4'd6)) ? 4'b1100 :
                  (LSU_single == 4'd7) ? 4'b1111 :
                  4'b0001;
assign offset =   ((wstrb == 4'b0001) & (LSU_single == 4'd5) &(LSU_wvalid)) ?  32'd0 :
                  ((wstrb == 4'b0010) & (LSU_single == 4'd5) &(LSU_wvalid)) ?  32'd8 :
                  ((wstrb == 4'b0100) & (LSU_single == 4'd5) &(LSU_wvalid)) ?  32'd16 :
                  ((wstrb == 4'b1000) & (LSU_single == 4'd5) &(LSU_wvalid)) ?  32'd24 :
                  ((wstrb == 4'b0011) & (LSU_single == 4'd6) &(LSU_wvalid)) ?  32'd0  :
                  ((wstrb == 4'b1100) & (LSU_single == 4'd6) &(LSU_wvalid)) ?  32'd16 :
                  (LSU_single == 4'd7) ? 32'd0 : 32'd0;
                 

//写数据随机延迟
// wire w_ready;
// random_delay_generator w_random_delay_generator(
//   .dynamic_seed (8'd73),
//   .clock     	(clock      ),
//   .reset   	(reset    ),
//   .request 	(in_ready & in_valid & STORE_single  ),
//   .ready   	(w_ready    )
// );

//写数据操作
reg wdata_state;

always@(posedge clock)begin
   if(in_ready & in_valid & STORE_single)begin
     wdata_state <= 1'b1;
   end
   if(wdata_state  )begin
   // $strobe("wstrb = %h",wstrb);
    LSU_wdata <= rs2_data;
    LSU_wvalid <= 1'b1; 
    LSU_wlast <= 1'b1;
    LSU_wstrb <= wstrb;
    wdata_state <= 1'b0;
  end
  else if(LSU_wready)begin
    LSU_wvalid <= 1'b0;
  end

end

// output declaration of module random_delay_generator




//写回复
always @(posedge clock) begin
  if(LSU_bvalid )begin
    LSU_bready <= 1'b1;
  end
  else LSU_bready <= 1'b0;
end


endmodule