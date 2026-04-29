`timescale 1ns / 1ps

module tb_SingleCycleCPU();

    // 声明给CPU的激励信号
    reg clk;
    reg rst;

    // 实例化我们要测试的终极CPU
    SingleCycleCPU u_CPU (
        .clk(clk),
        .rst(rst)
    );

    // 生成时钟：每隔5ns翻转一次，周期为10ns (频率100MHz)
    always #5 clk = ~clk;

    // 测试主流程
    initial begin
        // 1. 初始化信号
        clk = 0;
        rst = 1; // 拉高复位信号，让PC归零，清理系统

        // 2. 保持复位一段时间
        #20;
        rst = 0; // 释放复位，CPU开始自动读取指令执行

        // 3. 让CPU运行一段时间 (比如运行200ns，执行大约20条指令)
        #200;

        // 4. 结束仿真
        $finish;
    end

endmodule