module ysyx_25030093_CLINT(
    input           clock,
//---------------读地址----------------//     
    input        [31:0]   CLINT_araddr,
    input                 CLINT_arvalid,
    output  reg           CLINT_arready,
    output  reg  [3:0]    CLINT_arid,
    output  reg  [7:0]    CLINT_arlen,
    output  reg  [2:0]    CLINT_arsize,
    output  reg  [1:0]    CLINT_arburst,
//---------------读数据----------------//
    input                 CLINT_rready,
    output  reg  [31:0]   CLINT_rdata,
    output  reg           CLINT_rvalid,
    input        [1:0]    CLINT_rresp,
    input                 CLINT_rlast,
    input        [3:0]    CLINT_rid,
//---------------写地址----------------// ,
    input      [31:0]     CLINT_awaddr,
    input                 CLINT_awvalid,
    output reg            CLINT_awready,
    output reg [3:0]      CLINT_awid,
    output reg [7:0]      CLINT_awlen,
    output reg [2:0]      CLINT_awsize,
    output reg [1:0]      CLINT_awburst,
//---------------写数据----------------//  
    input      [31:0]     CLINT_wdata,
    input                 CLINT_wvalid,
    input      [3:0]      CLINT_wstrb,
    output reg            CLINT_wready,
    output reg            CLINT_wlast,
//---------------写回复----------------//  
    input                 CLINT_bready,
    output reg            CLINT_bvalid,
    input      [1:0]      CLINT_bresp,
    input      [3:0]      CLINT_bid
);

reg [63:0] mtime;


always @(posedge clock) begin
    mtime <= mtime + 64'd1;
end

always @(posedge clock) begin
    if(CLINT_arvalid)begin
        CLINT_arready <= 1'b1;
    end
    else CLINT_arready <= 1'b0;
end
 
always @(posedge clock) begin
    if(CLINT_arvalid & CLINT_arready)begin//握手

        if(CLINT_araddr == 32'ha0000048)begin//低32
            CLINT_rdata <= mtime[31:0];
            CLINT_rvalid <= 1'b1;
        end
        else if(CLINT_araddr == 32'ha000004c)begin//高32
            CLINT_rdata <= mtime[63:32];
            CLINT_rvalid <= 1'b1;
        end
    end
    else if(CLINT_rready) begin
            CLINT_rvalid <= 1'b0; 
    end
end


reg aw_state;
always @(posedge clock) begin
    if(CLINT_awvalid)begin
        CLINT_awready <= 1'b1;
        aw_state <= 1'b1;
    end
    else CLINT_awready <= 1'b0;
end

reg w_state;
always @(posedge clock) begin
    if(CLINT_wvalid)begin
        CLINT_wready <= 1'b1;
        w_state <= 1'b1;
    end
    else CLINT_wready <= 1'b0;
end

always@(posedge clock)begin
    if(w_state & aw_state)begin
        w_state <= 1'b0;
        aw_state <= 1'b0;
        CLINT_bvalid <= 1'b1;
    end
    else if(CLINT_bready) CLINT_bvalid <= 1'b0;
end






endmodule