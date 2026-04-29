module Instruction_Memory(
    input wire [31:0] pc_addr,
    output wire [31:0] instruction
);

    // 定义一个深度为256、字长为32位的寄存器数组，用来模拟只读存储器(ROM)
    // 256个字意味着可以存放256条指令 (总共1KB大小)
    reg [31:0] rom [0:255];

    // initial块仅用于仿真阶段 (综合时通常由FPGA的BRAM初始化IP替代)
    // 这里我们将事先准备好的机器码文件加载到数组中
    initial begin
        // 假设 "inst.data" 文件中存放了汇编代码转换后的16进制机器码
        // 每行一条 32 位指令
        $readmemh("inst.data", rom);
    end

    // 组合逻辑读取指令：不需要时钟驱动，地址一变，指令立刻输出
    // 注意：取地址的高30位 pc_addr[31:2]，相当于将字节地址除以4转为字地址
    assign instruction = rom[pc_addr[31:2]];

endmodule