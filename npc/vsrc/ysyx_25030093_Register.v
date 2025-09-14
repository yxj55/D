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

  reg [DATA_WIDTH-1:0] rf [2**ADDR_WIDTH-1:0];
  always @(posedge clock) begin

     if ((wen & waddr != 0) & in_valid) begin
  //  $display("Write: addr=%d, wdata=%h, stored=%h wen=%d", waddr, wdata, rf[waddr],wen);
       rf[waddr] <= wdata;
    end
  end

  assign rs1_data =((rs1_addr == 0)&(wen_read == 1'b1))?0:rf[rs1_addr];
  assign rs2_data =((rs2_addr == 0)&(wen_read == 1'b1))?0:rf[rs2_addr];
 


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
  localparam mtvec = 3'd0,mepc = 3'd1, mcause = 3'd2,mstatus = 3'd3,
            mvendorid = 3'd4 ,marchid = 3'd5,mcycle = 3'd6,mcycleh = 3'd7;
  always@(*)begin
  case(imm_csr)
  32'h305: begin position = mtvec;end//mtvec 
  32'h341: begin position = mepc;end//mepc
  32'h342: begin position = mcause;end //mcause
  32'h300: begin position = mstatus;end//mstatus
  32'hf11: begin position = mvendorid;end//mvendorid
  32'hf12: begin position = marchid;end//marchid
  32'hb00: begin position = mcycle;end//mcyle
  32'hb80: begin position = mcycleh;end//mcyleh
  default: begin
    position = 3'd3;
  end
  endcase
end
initial begin
  csr[3] = 32'h1800;
end
always@(posedge clock)begin
  if(wen_csr & in_valid) begin
    csr[position] <= csr_wdata;
  end
  
end
always@(*)begin
  if(ecall_single)begin
    csr[2] = 32'd11;
    csr[1] = ecall_now_pc;
  end
  else begin
    csr[2] = 32'd0;
    csr[1] = 32'b0;
  end
end
assign csr_data_pc = (ecall_single)?csr[0]:csr[1];//ecall -> mtvec  mret -> mepc


assign csr_data = csr[position];


always @(posedge clock) begin
  if(reset)begin
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
