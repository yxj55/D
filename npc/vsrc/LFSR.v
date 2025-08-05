module random_delay_generator (
    input clk,          // 时钟信号
    input reset,        // 异步复位
    input request,      // 延迟请求信号 (高电平有效)
    output reg ready    // 延迟完成信号 (高电平有效)
);

// 10位LFSR寄存器 (最大周期长度1023)
reg [9:0] lfsr;

// LFSR反馈多项式: x^10 + x^7 + 1 (提供良好的随机性)
wire lfsr_feedback = lfsr[9] ^ lfsr[6];

// 延迟计数器
reg [3:0] delay_counter;  // 0-15计数器 (足够覆盖1-10延迟)

// 当前随机延迟值 (1-10)
reg [3:0] current_delay;

// 状态机状态
reg processing;  // 0: 空闲, 1: 处理中

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // 复位初始化
        lfsr <= 10'b10_1010_1010; // 非零种子值 (0x2AA)
        delay_counter <= 0;
        current_delay <= 0;
        processing <= 0;
        ready <= 0;
    end else begin
        // 每周期更新LFSR (即使不处理请求)
        lfsr <= {lfsr[8:0], lfsr_feedback};
        
        // 状态机
        if (!processing) begin
            // 空闲状态
            ready <= 0;
            
            if (request) begin
                // 新请求到达
                processing <= 1;
                
                // 生成1-10的随机延迟值
                // 方法: 取LFSR低4位, 模10后加1
                current_delay <= (lfsr[3:0] % 10) + 1; 
                
                // 初始化计数器
                delay_counter <= current_delay;
            end
        end else begin
            // 处理中状态
            if (delay_counter > 0) begin
                // 延迟计数
                delay_counter <= delay_counter - 1;
                ready <= 0;
            end else begin
                // 延迟结束
                ready <= 1;
                processing <= 0;
            end
        end
    end
end

// 可选: 输出当前延迟值用于调试
wire [3:0] debug_delay = current_delay;

endmodule