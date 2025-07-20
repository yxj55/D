module ysyx_25030093_alu(
    input [4:0] alu_single,
    input wire [31:0] rs2_data,
    output reg [31:0] rd_data,
    output reg B_single,
    input wire [31:0] csr_data,
    output reg [31:0] csr_wdata,
    input [31:0] alu_data2,
    input [31:0] alu_data1
    );
   import "DPI-C" function int paddr_read(input int raddr,input int len);
   import "DPI-C" function void paddr_write(
  input int waddr, input int len,input int wdata);
reg [7:0] lb_temp; 
reg [15:0] lh_temp;
reg [31:0] t;

always@(*)begin
    //$display("now alu_data1 = %h alu_data2 = %h",alu_data1,alu_data2);
    case(alu_single)
    5'd0: rd_data = alu_data1 + alu_data2;
    5'd1: B_single= (alu_data1 == alu_data2);
    5'd2: rd_data = alu_data1 < alu_data2 ? 32'd1 : 32'd0;
    5'd3: B_single= (alu_data1 != alu_data2);
    5'd4: rd_data = alu_data1 - alu_data2;
    5'd5: rd_data = alu_data1 | alu_data2;
    5'd6: rd_data = alu_data1 ^ alu_data2;
    5'd7: B_single = ($signed(alu_data1)  >= $signed(alu_data2)) ;
    5'd8: rd_data = alu_data1 << alu_data2[4:0];
    5'd9: rd_data = alu_data1 & alu_data2;
    5'd10: rd_data = alu_data1 >> alu_data2[4:0];
    5'd11: rd_data = ($signed(alu_data1) < $signed(alu_data2)) ? 32'd1 : 32'd0;
    5'd12: B_single= ($signed(alu_data1) < $signed(alu_data2));
    5'd13: B_single= (alu_data1 < alu_data2);
    5'd14: B_single= (alu_data1 >= alu_data2);
    5'd15: rd_data = alu_data1 << alu_data2;
    5'd16: rd_data = $signed(alu_data1) >>> alu_data2[4:0];
    5'd17: paddr_write(alu_data1 + alu_data2,4,rs2_data);//sw
    5'd18: rd_data = paddr_read(alu_data1 + alu_data2,4); 
    5'd19: rd_data = $signed(alu_data1) >>> alu_data2;
    5'd20: rd_data = alu_data1 >> alu_data2;
    5'd21: rd_data = paddr_read(alu_data1 + alu_data2,1);//lbu
    5'd22: paddr_write(alu_data1 + alu_data2,2,rs2_data);//sh
    5'd23: paddr_write(alu_data1 + alu_data2,1,rs2_data);//sb
    5'd24: rd_data = paddr_read(alu_data1 + alu_data2,2);//lhu
    5'd25: begin
        lb_temp = paddr_read(alu_data1 + alu_data2 ,1);//lb
         rd_data = {{24{lb_temp[7]}},lb_temp};
    end
    5'd26: begin
        lh_temp = paddr_read(alu_data1 + alu_data2 ,2);//lh
         rd_data = {{16{lh_temp[15]}},lh_temp};
    end
    5'd27: begin
        t = csr_data;
        rd_data = t;
        csr_wdata = alu_data1;
    end
    5'd28: begin
        t = csr_data;
        rd_data = t; 
        csr_wdata = alu_data1 | t;
    end
    default: rd_data = 32'd0;
    endcase
end



/*
always@(*)begin
    
 case(alu_single)
    6'd0:begin 
        rd_data = rs1_data + imm_data;//addi
      // $display("addi rd_data %h rs1_data %h imm_data %h",rd_data,rs1_data,imm_data);
    end
    6'd1:begin 
        rd_data = pc + imm_data;//auipc
        //$display("auipc rd_data %h pc %h imm_data %h",rd_data,pc,imm_data);
    end
    6'd2:begin 
        rd_data = imm_data; //lui
    end
    6'd3:begin 
        rd_data = pc + 32'd4;//jalr jal
    end
    6'd4:begin
        B_single = (rs1_data == rs2_data);//beq
    end
    6'd5:begin
       // $display("rs1_data =%h imm_data =%h rs2_data =%h pc=%h",rs1_data,imm_data,rs2_data,pc);
        paddr_write(rs1_data + imm_data,4,rs2_data);//sw
    end
    6'd6:begin
        rd_data = paddr_read(imm_data + rs1_data,4);//lw
    end
    6'd7:begin
        rd_data = rs1_data < imm_data ? 32'd1 : 32'd0;//sltiu
    end
    6'd8:begin
        B_single = (rs1_data != rs2_data);//bne
    end
    6'd9:begin
        rd_data = rs1_data + rs2_data;//add
    end
    6'd10:begin
        rd_data = rs1_data - rs2_data;//sub
    end
    6'd11:begin
        rd_data = rs1_data | rs2_data;//or
    end
    6'd12:begin
        rd_data = rs1_data ^ rs2_data;//xor
    end
    6'd13:begin
        rd_data = (rs1_data < rs2_data)? 32'd1 : 32'd0;//sltu
    end
    6'd14:begin
        B_single = ($signed(rs1_data)  >= $signed(rs2_data)) ;//bge
    end
    6'd15:begin
        rd_data = rs1_data << imm_data[4:0];//slli
    end
    6'd16:begin
        rd_data = rs1_data & imm_data;//andi
    end
    6'd17:begin
        rd_data = rs1_data >> imm_data[4:0];//srli
    end
    6'd18:begin
        rd_data = ($signed(rs1_data) < $signed(imm_data)) ? 32'd1 : 32'd0;//slti
    end
    6'd19:begin
        B_single = ($signed(rs1_data) < $signed(rs2_data));//blt
    end
    6'd20:begin
        B_single = (rs1_data < rs2_data);//bltu
    end
    6'd21:begin
        B_single = (rs1_data >= rs2_data);//bgeu
    end
    6'd22:begin
        rd_data = rs1_data << rs2_data;//sll
    end
    6'd23:begin
        rd_data = ($signed(rs1_data) < $signed(rs2_data)) ? 32'd1 : 32'd0;//stl
    end
    6'd24:begin
        rd_data = rs1_data ^ imm_data;//xori
    end
    6'd25:begin
        rd_data = rs1_data | imm_data;//ori
    end
    6'd26:begin
       
       rd_data = paddr_read(rs1_data + imm_data,1);//lbu
    end
    6'd27:begin
        rd_data = $signed(rs1_data) >>> imm_data[4:0];//srai
    end
    6'd28:begin
        paddr_write(rs1_data + imm_data ,1,rs2_data);//sb
    end
    6'd29:begin
        paddr_write(rs1_data + imm_data,2,rs2_data);//sh
    end
    6'd30:begin
        rd_data = rs1_data & rs2_data;//and
    end
    6'd31:begin
         lb_temp = paddr_read(rs1_data + imm_data ,1);//lb
         rd_data = {{24{lb_temp[7]}},lb_temp};
    end
    6'd32:begin
         lh_temp = paddr_read(rs1_data + imm_data ,2);//lh
         rd_data = {{16{lh_temp[15]}},lh_temp};
    end
    6'd33:begin
        rd_data = rs1_data >> rs2_data;//srl
    end
    6'd34:begin
        rd_data = $signed(rs1_data) >>> rs2_data;//sra
    end
    6'd35:begin
        rd_data = paddr_read(rs1_data + imm_data,2);//lhu
    end
    6'd36:begin
        t = csr_data;
        rd_data = t;
        csr_wdata = rs1_data;
    end
    6'd37:begin
       // $display("csr_data = %h",csr_data);
        t = csr_data;
        rd_data = t; 
        csr_wdata = rs1_data | t;
    end
    default rd_data = 32'b0;
 endcase
 //$display("end rd_data %h alu_single %h",rd_data,alu_single);
end
*/
endmodule
