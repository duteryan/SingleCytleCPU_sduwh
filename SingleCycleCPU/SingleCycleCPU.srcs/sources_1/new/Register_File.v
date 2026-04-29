module Register_File(
    input wire clk,
    input wire we,          // 写使能 RWEN
    input wire [4:0] ra1,   // 读地址1 (通常来源于指令的 rs 字段)
    input wire [4:0] ra2,   // 读地址2 (通常来源于指令的 rt 字段)
    input wire [4:0] wa,    // 写地址
    input wire [31:0] wd,   // 要写入的数据
    output wire [31:0] rd1, // 输出数据1
    output wire [31:0] rd2  // 输出数据2
);

    // 定义32个32位的寄存器数组
    reg [31:0] rf [31:0];
    
    integer i;
    initial begin
        // 初始化所有寄存器为0 (仿真使用)
        for (i = 0; i < 32; i = i + 1) begin
            rf[i] = 32'b0;
        end
    end

    // 写操作：同步写（在时钟上升沿进行写入）
    always @(posedge clk) begin
        // 只有写使能有效，且写入地址不为0（0号寄存器常数为0，不可写）时才写入
        if (we && wa != 5'b00000) begin
            rf[wa] <= wd;
        end
    end

    // 读操作：异步组合逻辑读（地址给到，数据立刻输出）
    // 为了防止读取未初始化的0号寄存器产生未知状态，直接硬连线0号寄存器输出0
    assign rd1 = (ra1 == 5'b00000) ? 32'b0 : rf[ra1];
    assign rd2 = (ra2 == 5'b00000) ? 32'b0 : rf[ra2];

endmodule