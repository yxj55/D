
module ysyx_25030093_IDU(
    output wire             out_valid,
    output wire             out_ready,
    input                   in_valid,
    input                   in_ready,
    output      [1:0]       alu_single,
    output      [1:0]       pc_single,
    output                  wen,
    output                  wen_read,
    input       [31:0]      inst_wire,
    output      [31:0]      imm_data,
    output      [4:0]       rd,
    output      [4:0]       rs1,
    output      [4:0]       rs2,
    output                  ecall_single,
    output                  wen_csr,
    output      [1:0]       imm_or_rs2_other,
    output      [1:0]       rs1_pc_other,
    input                   clock,
    input                   reset,
    output      [2:0]       LSU_single,
    output                  rd_or_LSU_single
);
import "DPI-C" function void npc_ebreak();


reg [31:0] inst;

parameter IDLE =2'b00,Prepare_data = 2'b01,Occurrence_data = 2'b10;

reg [1:0] state;



always@(posedge clock)begin
    if(reset)begin
        state <= IDLE;
    end
    else begin
        case(state)
        IDLE:begin
           if(in_ready & in_valid) begin
                state <= Prepare_data;
           end
           else state <= IDLE;
        end
        Prepare_data:begin
            inst <= inst_wire;
            state <= Occurrence_data;
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


wire [1:0] imm_type;


assign rd  = inst[11:7];
assign rs1 = inst[19:15];
assign rs2 = inst[24:20];



//------------------------------------------//opcode
//R-type opcode
wire RISCV_ADD_OP                               = (inst[6:0] == 7'b0110011);


//U-type opcode
wire RISCV_LUI_OP                               = (inst[6:0] == 7'b0110111);

//I-type opcode
wire RISCV_ADDI_OP                              = (inst[6:0] == 7'b0010011);
wire RISCV_JALR_OP                              = (inst[6:0] == 7'b1100111);
wire RISCV_LW_OP                                = (inst[6:0] == 7'b0000011);
wire RISCV_LBU_OP                               = (inst[6:0] == 7'b0000011);

wire RISCV_ECALL_OP                             = (inst[6:0] == 7'b1110011);
wire RISCV_MRET_OP                              = (inst[6:0] == 7'b1110011);
wire RISCV_CSRRW_OP                             = (inst[6:0] == 7'b1110011);
wire RISCV_CSRRS_OP                             = (inst[6:0] == 7'b1110011);
//J-type opcode


//S-type opcode
wire RISCV_SW_OP                                = (inst[6:0] == 7'b0100011);
wire RISCV_SB_OP                                = (inst[6:0] == 7'b0100011);

//------------------------------------------//funt3
//R-type funt3
wire RISCV_ADD_FUNT3                            = (inst[14:12] == 3'b000);


//I-type funt3
wire RISCV_ADDI_FUNT3                           = (inst[14:12] == 3'b000);
wire RISCV_JALR_FUNT3                           = (inst[14:12] == 3'b000);
wire RISCV_LW_FUNT3                             = (inst[14:12] == 3'b010);
wire RISCV_LBU_FUNT3                            = (inst[14:12] == 3'b100);


wire RISCV_ECALL_FUNT3                          = (inst[14:12] == 3'b000);
wire RISCV_MRET_FUNT3                           = (inst[14:12] == 3'b000);
wire RISCV_CSRRW_FUNT3                          = (inst[14:12] == 3'b001);
wire RISCV_CSRRS_FUNT3                          = (inst[14:12] == 3'b010);
//S-type funt3
wire RISCV_SW_FUNT3                             = (inst[14:12] == 3'b010);
wire RISCV_SB_FUNT3                             = (inst[14:12] == 3'b000);

//------------------------------------------//funt7
//R-type funt7
wire RISCV_ADD_FUNT7                            = (inst[31:25] == 7'b0000000);



wire RISCV_ECALL_FUNT7                          = (inst[31:25] == 7'b0000000);
wire RISCV_MRET_FUNT7                           = (inst[31:25] == 7'b0011000);
//------------------------------------------//
//R-type
wire add                                        =(RISCV_ADD_OP & RISCV_ADD_FUNT3 & RISCV_ADD_FUNT7);

//U-type
wire lui                                        = RISCV_LUI_OP;

//I-type
wire addi                                       =(RISCV_ADDI_OP & RISCV_ADDI_FUNT3); 
wire jalr                                       =(RISCV_JALR_OP & RISCV_JALR_FUNT3);
wire lw                                         =(RISCV_LW_OP & RISCV_LW_FUNT3);
wire lbu                                        =(RISCV_LBU_OP & RISCV_LBU_FUNT3);
wire csrrw                                      =(RISCV_CSRRW_OP & RISCV_CSRRW_FUNT3);
wire csrrs                                      =(RISCV_CSRRS_OP & RISCV_CSRRS_FUNT3);
//N-type
wire ecall                                      =(RISCV_ECALL_OP & RISCV_ECALL_FUNT3 & RISCV_ECALL_FUNT7);
wire mret                                       =(RISCV_MRET_OP & RISCV_MRET_FUNT3 & RISCV_MRET_FUNT7);

//S-type
wire sw                                         =(RISCV_SW_OP & RISCV_SW_FUNT3);
wire sb                                         =(RISCV_SB_OP & RISCV_SB_FUNT3);

//------------------------------------------//

//00 -> rs2  01 -> imm  10 -> 4
assign imm_or_rs2_other[0] = addi | lui | lw | sw | lbu | sb;
assign imm_or_rs2_other[1] = jalr;

//00 rs1    01 pc 11 0
assign rs1_pc_other[0] = jalr | lui;
assign rs1_pc_other[1] = lui;

//------------------------------------------//

//00 + 01 csrrw 10 csrrs
assign alu_single[0] = csrrw;
assign alu_single[1] = csrrs;
    

//------------------------------------------//

//001 lw 010 lbu 011 sw 100 sb
assign LSU_single[0] = lw | sw;
assign LSU_single[1] = lbu | sw;
assign LSU_single[2] = sb;



//------------------------------------------//

assign rd_or_LSU_single                            =  lw | lbu  ;

//------------------------------------------//


assign wen                                         = addi | csrrw |csrrs| lui |jalr | lw |add |lbu;
assign wen_read                                    = addi |lw |csrrw|csrrs| sw  | add |lbu|sb;
assign wen_csr                                     = (csrrw | csrrs);
//00 I 01 U 10 S 11 ecall
assign imm_type[0]                                 = lui ;
assign imm_type[1]                                 = sw | sb ;

//01 jalr //10 ecall mret
assign pc_single[0]                                = jalr;    
assign pc_single[1]                                = ecall | mret;                


ysyx_25030093_imm u_ysyx_25030093_imm(
    .inst     	(inst      ),
    .imm_type 	(imm_type  ),
    .imm_ex   	(imm_data    )
);

assign ecall_single = ecall;









always@(inst)begin
    if(inst[31:20]==12'b000000000001&&inst[6:0]==7'b1110011)begin
        npc_ebreak();
    end
end




endmodule
