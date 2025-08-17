
module ysyx_25030093_IFU(
    input                 in_valid,
    input                 clock,
    input                 reset,
    output                valid,
    input                 ready,
    output  reg  [31:0]   inst_wire,
    input        [31:0]   pc,
 //------------------读地址-------------------//
    output  reg  [31:0]  io_master_araddr,
    output  reg          io_master_arvalid,
    input                io_master_arready,
    output  reg  [3:0]   io_master_arid,
    output  reg  [7:0]   io_master_arlen,
    output  reg  [2:0]   io_master_arsize,
    output  reg  [1:0]   io_master_arburst,
 //------------------读数据-------------------//
    input                io_master_rvalid,
    output  reg          io_master_rready,
    input        [31:0]  io_master_rdata,
    input        [1:0]   io_master_rresp,
    input                io_master_rlast,
    input        [3:0]   io_master_rid,
 //------------------写地址-------------------//
    input                io_master_awready,
    output reg           io_master_awvalid,
    output reg   [31:0]  io_master_awaddr,
    output reg   [3:0]   io_master_awid,
    output reg   [7:0]   io_master_awlen,
    output reg   [2:0]   io_master_awsize,
    output reg   [1:0]   io_master_awburst,
 //------------------写数据-------------------//
    input                io_master_wready,
    output reg           io_master_wvalid,
    output reg   [31:0]  io_master_wdata,
    output reg   [3:0]   io_master_wstrb,
    output reg           io_master_wlast,
 //------------------写回复-------------------//
    output reg           io_master_bready,
    input                io_master_bvalid,
    input        [1:0]   io_master_bresp,
    input        [3:0]   io_master_bid
);


//------------------------------------------//
parameter IDLE =2'b00,Prepare_data = 2'b01,Occurrence_data = 2'b10;

reg [1:0] state;
reg IFU_single;

always@(posedge clock)begin
    if(reset)begin
        state <= IDLE;
        IFU_single <= 1'b1;
    end
    else begin
        case(state)
        IDLE:begin
           if((ready & in_valid)||(IFU_single) ) begin
                state <= Prepare_data;
                IFU_single <= 1'b0;
           end
           else state <= IDLE;
        end
        Prepare_data:begin
          
            if(io_master_rvalid & io_master_rready) begin
                 inst_wire <= io_master_rdata;
                 state <= Occurrence_data;
            end
            else state <= Prepare_data;
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

     assign valid = (state == Occurrence_data);
//------------------------------------------//

always@(posedge clock)begin
    if(io_master_rvalid)begin
        io_master_rready <= 1'b1;

    end
    else begin
        io_master_rready <=1'b0;
    end
end





always@(posedge clock)begin
    if(IFU_single ||(ready & in_valid))begin
        io_master_araddr <= pc;
        io_master_arvalid <= 1'b1;

    end
    else  if(io_master_arready) begin
        io_master_arvalid <= 1'b0;
    end 
end








//------------------------------------------//





endmodule