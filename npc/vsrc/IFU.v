
module ysyx_25030093_IFU(
    input                 in_valid,
    input                 clk,
    input                 rst,
    output                valid,
    input                 ready,
    output  reg  [31:0]   inst_wire,
    input        [31:0]   pc,
 //------------------------------------------//
    output  reg  [31:0]  IFU_SRAM_araddr,
    output  reg          IFU_SRAM_arvalid,
    output  reg          IFU_SRAM_rready,
    input                SRAM_IFU_arready,
    input                SRAM_IFU_rvalid,
    input        [31:0]  SRAM_IFU_rdata
    

);


//------------------------------------------//
parameter IDLE =2'b00,Prepare_data = 2'b01,Occurrence_data = 2'b10;

reg [1:0] state;


always@(posedge clk)begin
    if(rst)begin
        state <= Prepare_data;
    end
    else begin
        case(state)
        IDLE:begin
           if(ready & in_valid ) begin
                state <= Prepare_data;
           end
           else state <= IDLE;
        end
        Prepare_data:begin
            if(SRAM_IFU_rvalid & IFU_SRAM_rready) begin
                 inst_wire <= SRAM_IFU_rdata;
                 state <= Occurrence_data;
            end
            else state <= Prepare_data;
        end
        Occurrence_data:begin
            state <= IDLE;
        end
        endcase
    end
end

     assign valid = (state == Occurrence_data);
//------------------------------------------//

always@(posedge clk)begin
    if(SRAM_IFU_rvalid)begin
        IFU_SRAM_rready <= 1'b1;
    end
    else begin
        IFU_SRAM_rready <=1'b0;
    end
end


// output declaration of module random_delay_generator
wire IFU_arready;

random_delay_generator u_random_delay_generator(
    .dynamic_seed (8'd211),
    .clk     	(clk      ),
    .reset   	(rst    ),
    .request 	(state == Prepare_data  ),
    .ready   	(IFU_arready    )
);


always@(posedge clk)begin
    if((state == Prepare_data)&IFU_arready)begin
        IFU_SRAM_araddr <= pc;
        IFU_SRAM_arvalid <= 1'b1;
    end
    else  if(SRAM_IFU_arready) IFU_SRAM_arvalid <= 1'b0;
end








//------------------------------------------//





endmodule