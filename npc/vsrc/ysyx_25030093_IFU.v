
module ysyx_25030093_IFU(
    input                 in_valid,
    input                 clock,
    input                 reset,
    output                valid,
    input                 ready,
    output  reg  [31:0]   inst_wire,
    input        [31:0]   pc,
 //------------------SimpleBus-------------------//
    output  reg  [31:0]   IFU_addr,
    input        [31:0]   IFU_rdata,
    output  reg           IFU_reqValid,
    input                 IFU_respValid
);


//------------------------------------------//
parameter IDLE =2'b00,Prepare_data = 2'b01,Occurrence_data = 2'b10;

reg [1:0] state;
reg IFU_single;

always@(posedge clock)begin
    if(reset)begin
        state <= IDLE;
        IFU_reqValid <= 1'b0;
        IFU_single <= 1'b1;
    end
    else begin
        case(state)
        IDLE:begin
           if((ready & in_valid)||(IFU_single)) begin
                state <= Prepare_data;
                IFU_addr <= pc;
                IFU_reqValid <= 1'b1;
                IFU_single <= 1'b0;
           end
           else state <= IDLE;
        end
        Prepare_data:begin
            IFU_reqValid <= 1'b0;
            if(IFU_respValid) begin
                 inst_wire <= IFU_rdata;
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






endmodule