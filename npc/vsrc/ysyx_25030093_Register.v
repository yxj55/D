module ysyx_25030093_Register #(ADDR_WIDTH = 5, DATA_WIDTH = 32) (
  input                   clock,
  input [DATA_WIDTH-1:0]  wdata,
  input [ADDR_WIDTH-1:0]  waddr,
  input                   wen,
  input                   wen_read,
 output [DATA_WIDTH-1:0]  rs1_data,
 input [ADDR_WIDTH-1:0]   rs1_addr,
 output [DATA_WIDTH-1:0]  rs2_data,
 input [ADDR_WIDTH-1:0]   rs2_addr,
 input                    in_valid
);

  reg [DATA_WIDTH-1:0] rf [15:0];
  always @(posedge clock) begin

     if ((wen & waddr != 0) & in_valid) begin
  //  $display("Write: addr=%d, wdata=%h, stored=%h wen=%d", waddr, wdata, rf[waddr],wen);
       rf[waddr[3:0]] <= wdata;
    end
  end

  assign rs1_data =((rs1_addr == 0)&(wen_read == 1'b1))?0:rf[rs1_addr[3:0]];
  assign rs2_data =((rs2_addr == 0)&(wen_read == 1'b1))?0:rf[rs2_addr[3:0]];
 


endmodule

module ysyx_25030093_CSR_REG(
  input                  clock,
  input                  reset,
  output wire [31:0]     csr_data,
  output wire [31:0]     csr_data_pc,
  input       [31:0]     imm_csr,
  input                  ecall_single,
  input       [31:0]     ecall_now_pc,
  input       [31:0]     csr_wdata,
  input                  wen_csr,
  input                  in_valid 

);
  reg [31:0] csr[7];
  reg [2:0] position;
  localparam mtvec = 3'd0,mepc = 3'd1, mcause = 3'd2,mstatus = 3'd3;
  localparam mvendorid = 3'd4 ,marchid = 3'd5,mcycle = 3'd6,mcycleh = 3'd7;
  always@(*)begin
  // $display("now imm_csr =%h",imm_csr);
  case(imm_csr[11:0])
  12'h305: begin position = mtvec;end//mtvec 
  12'h341: begin position = mepc;end//mepc
  12'h342: begin position = mcause;end //mcause
  12'h300: begin position = mstatus;end//mstatus
  12'hf11: begin position = mvendorid;end//mvendorid
  12'hf12: begin position = marchid;end//marchid
  12'hb00: begin position = mcycle;end//mcyle
  12'hb80: begin position = mcycleh;end//mcyleh
  default: begin
    position = 3'd3;
  end
  endcase
end


always@(posedge clock)begin
  if (reset) begin
    // 复位操作
    csr[1] <= 32'b0; // mepc
    csr[2] <= 32'b0; // mcause
  end else if (ecall_single) begin
    // 发生异常时，更新mepc和mcause
    csr[1] <= ecall_now_pc;
    csr[2] <= 32'd11;
  end else if (wen_csr & in_valid) begin
    // CSR写操作（注意：避免写入只读寄存器）
    if (position != mcycle && position != mcycleh) // 避免写入计数器
      csr[position] <= csr_wdata;
  end
end
assign csr_data_pc = (ecall_single)?csr[0]:csr[1];//ecall -> mtvec  mret -> mepc


assign csr_data = csr[position];


always @(posedge clock) begin
  if(reset)begin
    csr[3]         <= 32'h1800;      // mstatus
    csr[mvendorid] <= 32'h79737978;
    csr[marchid]   <= 32'd25030093;
    csr[mcycle] <= 32'd0;
    csr[mcycleh] <= 32'd0;
  end
  else begin
   csr[mcycle] <= csr[mcycle] + 32'd1;
   if(&csr[mcycle])begin
    csr[mcycle] <= 32'd0;
    csr[mcycleh] <= csr[mcycleh] + 32'd1;
    end
  end
end


endmodule
