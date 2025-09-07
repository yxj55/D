
module ysyx_25030093_IDU(
    output wire             out_valid,
    output wire             out_ready,
    input                   in_valid,
    input                   in_ready,
    output      [4:0]       alu_single,
    output      [2:0]       pc_single,
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
    output      [3:0]       LSU_single,
    output                  rd_or_LSU_single,
    output                  LOAD_single,
    output                  STORE_single
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


wire [2:0] imm_type;


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

//00 -> imm  01 -> rs2  10 -> 4
assign imm_or_rs2_other = (addi | auipc | lui | sltiu | andi | slli | srli | slti | xori | ori | srai | lw | sw | lbu | lb | lh | sb | sh | lhu) ? 2'b00 : //imm
                          (beq | bne | add | sub | OR | XOR | sltu | bge | blt | bltu | bgeu | sll | slt | AND | srl | sra) ? 2'b01: //rs2
                                (jal | jalr) ? 2'b10: //4
                                        2'b11;

assign rs1_pc_other     = (beq | bne | blt | bge | bltu | bgeu |
                                  lb | lh | lbu | lhu | lw | sb | sh | sw 
                                     |addi | slti | sltiu | xori | ori | andi |
                            slli | srli | srai | add | sub | sll| slt | sltu | XOR | srl | sra | OR | AND | csrrw) ? 2'b00 : //rs1
                            (auipc | jal | jalr) ? 2'b01 : //pc
                             (lui ) ? 2'b11 : 2'b11; //0

//------------------------------------------//



assign alu_single       =(addi | auipc | lui | jal | jalr | add | lb | lh | lw | lbu | lhu | sb | sh | sw)   ? 5'd0 : 
                          (beq)                                                                              ? 5'd1 :
                          (sltiu| sltu )                                                                     ? 5'd2 :
                          (bne)                                                                              ? 5'd3 :
                          (sub)                                                                              ? 5'd4 :
                          (OR   | ori)                                                                       ? 5'd5 :
                          (XOR  | xori )                                                                     ? 5'd6 :
                          (bge)                                                                              ? 5'd7 :
                          (slli )                                                                            ? 5'd8 :
                          (andi | AND)                                                                       ? 5'd9 :
                          (srli)                                                                             ? 5'd10:
                          (slti | slt)                                                                       ? 5'd11:
                          (blt )                                                                             ? 5'd12:
                          (bltu)                                                                             ? 5'd13:
                          (bgeu)                                                                             ? 5'd14:
                          (sll)                                                                              ? 5'd15:
                          (srai )                                                                            ? 5'd16:
                          (sra)                                                                              ? 5'd17:
                          (srl )                                                                             ? 5'd18: 
                          (csrrw)                                                                            ? 5'd19:
                          (csrrs)                                                                            ? 5'd20: 
                          5'd31;      


//------------------------------------------//


assign LSU_single = (lb)        ? 4'd0:
                    (lh)        ? 4'd1:
                    (lw)        ? 4'd2:
                    (lbu)       ? 4'd3:
                    (lhu)       ? 4'd4:
                    (sb)        ? 4'd5:
                    (sh)        ? 4'd6:
                    (sw)        ? 4'd7:
                    4'd8; 



//------------------------------------------//

assign rd_or_LSU_single = lb | lh | lw | lbu | lhu ;


assign LOAD_single = lb | lh | lw | lbu | lhu;
assign STORE_single = sb | sh | sw;

//------------------------------------------//


assign wen = addi | auipc|csrrw |csrrs| lui |jalr |jal|lb|lh|lw|sltiu|add|sub|OR|XOR|srl|sra|sltu|slli|andi|srli|slti|sll|slt|xori|ori|lbu|lhu|srai|AND;
assign wen_read = addi | beq | lb|lh|lw |csrrw|csrrs| sw | sltiu | add | sub | OR |XOR|srl|sra|sltu|slli|andi|srli|slti|blt|bltu|bgeu|sll|slt|xori|ori|lbu|lhu|srai|sb|sh|AND;
assign wen_csr  = (csrrw | csrrs);
assign imm_type                                 =(lui | auipc) ? 3'b001 :   //U-type imm
                                                 (jal)         ? 3'b010 :           //J-type imm
                                                 (sw|sh|sb)          ? 3'b011 :           //S-type imm
                                                 (beq | bne |bge |blt |bltu|bgeu)   ? 3'b100 : //B-type imm
                                                 (ecall | mret)                     ? 3'b101 :
                                                                3'b000;     //默认I-type

assign pc_single                                = jalr          ? 3'b001 :   // jalr
                                                  jal           ? 3'b010 :   // jal
                                                  (beq | bne |bge |blt |bltu|bgeu)  ? 3'b100 :   // B-type
                                                  (ecall | mret)         ? 3'b101 : 
                                                                3'b110 ;  // 默认



ysyx_25030093_imm u_ysyx_25030093_imm(
    .inst     	(inst      ),
    .imm_type 	(imm_type  ),
    .imm_ex   	(imm_data    )
);

assign ecall_single = ecall;

//imm_type 3'd1:U  3'd2:I
/*
always@(inst)begin
    case(opcode)
    //auipc
    7'b0010111:begin
        wen =1'b1;
        imm_type = 3'd1;
        Control_single =6'd1;
    end
    //lui
    7'b0110111:begin
        wen = 1'b1;
        imm_type = 3'd1;
        Control_single = 6'd2;
    end
    //I-type
    7'b0010011:begin
        case(funt)
        //addi
        3'b000:begin
            imm_type = 3'd0;
            wen = 1'b1;
            Control_single = 6'd0;
        end
        default:begin
            //TDOO()
            wen = 1'b0;
        end
        endcase
    end
    7'b1100111:begin
        case(funt)
        //jalr
        3'b000:begin
            wen = 1'b1;
            imm_type = 3'd0;
            Control_single = 6'd3;
        end
        default: wen = 1'b0;
        endcase
    end
    default:begin
        wen = 1'b0;
        //TD
    end
    endcase
end
*/







always@(inst)begin
    if(inst[31:20]==12'b000000000001&&inst[6:0]==7'b1110011)begin
        npc_ebreak();
    end
end




endmodule
