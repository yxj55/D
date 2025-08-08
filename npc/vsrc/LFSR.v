// 基于LFSR的随机延迟生成器
module random_delay_generator (
    input wire [LFSR_WIDTH-1:0] dynamic_seed,  // 新增种子输入
    input wire clk,          // 时钟信号
    input wire reset,      // 异步低电平复位
    input wire request,       // 使能信号，开始生成随机延迟
    output reg ready    // 延迟完成标志
);

    // LFSR参数
    parameter LFSR_WIDTH = 8;           // LFSR位宽
    parameter MAX_DELAY = 20;          // 最大延迟值
    // parameter INIT_SEED = 8'b1101_1010; // 初始种子值（不可全零）
    
    // 内部寄存器
    reg [LFSR_WIDTH-1:0] lfsr;         // LFSR寄存器
    reg [LFSR_WIDTH-1:0] delay_counter; // 延迟计数器
    reg [LFSR_WIDTH-1:0] target_delay;  // 目标延迟值
    reg delay_active;                   // 延迟激活标志
    
    // LFSR的反馈多项式：x^8 + x^6 + x^5 + x^4 + 1 (根据位宽选择)
    wire lfsr_feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];
    
    // 主逻辑
    always @(posedge clk ) begin
        if (reset) begin
            // 异步复位
            lfsr <= dynamic_seed;
            delay_counter <= 0;
            target_delay <= 0;
            delay_active <= 0;
            ready <= 0;
        end else begin
            // 正常操作
            if (request && !delay_active) begin
                // 当使能且当前没有激活的延迟时，启动新延迟
                delay_active <= 1;
                ready <= 0;
                // 使用LFSR当前值作为目标延迟（取模限制最大延迟）
                target_delay <= lfsr % (MAX_DELAY + 1);
                // 更新LFSR
                lfsr <= {lfsr[LFSR_WIDTH-2:0], lfsr_feedback};
            end
            
            if (delay_active) begin
                // 延迟进行中
                if (delay_counter < target_delay) begin
                    delay_counter <= delay_counter + 1;
                end else begin
                    // 延迟完成
                    delay_counter <= 0;
                    delay_active <= 0;
                    ready <= 1;
                end
            end else begin
                ready <= 0;
            end
        end
    end

endmodule