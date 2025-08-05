
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
    input                clk,
    input                rst,
    input       [7:0]    wstrb,
 //------------------------------------------//
    input       [31:0]   SRAM_LSU_rdata,  // SRAM 读数据
    input                SRAM_LSU_arready, //SRAM 读就绪
    input                SRAM_LSU_rvalid, //读数据有效
    output reg  [31:0]   LSU_SRAM_araddr,//读地址
    output reg           LSU_SRAM_arvalid,//读地址有效
    output reg           LSU_SRAM_rready,
 //------------------------------------------//
    input                SRAM_LSU_awready,//SRAM写地址就绪
    input                SRAM_LSU_wready,//SRAM写数据有效
    input                SRAM_LSU_bvalid,//写回复有效
    output reg  [31:0]   LSU_SRAM_awaddr,//写地址
    output reg  [31:0]   LSU_SRAM_wdata,//写数据
    output reg  [7:0]    LSU_SRAM_wstrb,//掩码
    output reg           LSU_SRAM_wvalid,//数据有效
    output reg           LSU_SRAM_awvalid,//地址有效
    output reg           LSU_SRAM_bready // 写回复就绪
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
if(SRAM_LSU_rvalid & LSU_SRAM_rready) begin
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
    default:begin
      state <= Prepare_data;
    end
   endcase
end
else if( SRAM_LSU_bvalid & LSU_SRAM_bready) begin
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
  endcase
end

assign out_ready = (state == IDLE);
assign out_valid = (state == Occurrence_data);


reg ar_state;

//读操作

// output declaration of module random_delay_generator
wire ar_ready;
random_delay_generator ar_random_delay_generator(
  .clk     	(clk      ),
  .reset   	(rst    ),
  .request 	( LOAD_single & in_ready & in_valid ),
  .ready   	(ar_ready    )
);




//读地址
always@(posedge clk)begin
  if(LOAD_single & in_ready & in_valid)begin
    ar_state <= 1'b1; 
  end
  else if(ar_state & ar_ready)begin
    LSU_SRAM_araddr <= rd_data;
    LSU_SRAM_arvalid <= 1'b1;
    ar_state <= 1'b0;
  end
  else if(SRAM_LSU_arready) begin //检查 arready 下周期拉低 arvalid
    LSU_SRAM_arvalid <=1'b0;
  end

end


// output declaration of module random_delay_generator
wire r_ready;

random_delay_generator r_random_delay_generator(
  .clk     	(clk      ),
  .reset   	(rst    ),
  .request 	(SRAM_LSU_rvalid  ),
  .ready   	(r_ready    )
);




//读数据
always@(posedge clk)begin
    if(SRAM_LSU_rvalid & r_ready)begin
        LSU_SRAM_rready <=1'b1;
    end
    else  begin
        LSU_SRAM_rready <=1'b0;
    end
end


//写操作
//写地址

// output declaration of module random_delay_generator
wire aw_ready;

random_delay_generator aw_random_delay_generator(
  .clk     	(clk      ),
  .reset   	(rst    ),
  .request 	(in_ready & in_valid & STORE_single  ),
  .ready   	(aw_ready    )
);



reg awaddr_state;

always@(posedge clk)begin
   if(in_ready & in_valid & STORE_single)begin
     awaddr_state <= 1'b1;
   end
   else if(awaddr_state & aw_ready)begin
    LSU_SRAM_awaddr <= rd_data;
    LSU_SRAM_awvalid <=1'b1;
    awaddr_state <= 1'b0;
  end
  else if(SRAM_LSU_awready) begin
    LSU_SRAM_awvalid <= 1'b0;
  end 
 
end


//写数据随机延迟
wire w_ready;
random_delay_generator w_random_delay_generator(
  .clk     	(clk      ),
  .reset   	(rst    ),
  .request 	(in_ready & in_valid & STORE_single  ),
  .ready   	(w_ready    )
);

//写数据操作
reg wdata_state;

always@(posedge clk)begin
   if(in_ready & in_valid & STORE_single)begin
     wdata_state <= 1'b1;
   end
   if(wdata_state & w_ready )begin
    LSU_SRAM_wdata <= rs2_data;
    LSU_SRAM_wvalid <= 1'b1; 
    LSU_SRAM_wstrb <= wstrb;
    wdata_state <= 1'b0;
  end
  else if(SRAM_LSU_wready)begin
    LSU_SRAM_wvalid <= 1'b0;
  end

end

// output declaration of module random_delay_generator
wire b_ready;

random_delay_generator u_random_delay_generator(
  .clk     	(clk      ),
  .reset   	(rst    ),
  .request 	(SRAM_LSU_bvalid  ),
  .ready   	(b_ready    )
);


//写回复
always @(posedge clk) begin
  if(SRAM_LSU_bvalid & b_ready )begin
    LSU_SRAM_bready <= 1'b1;
  end
  else LSU_SRAM_bready <= 1'b0;
end


endmodule