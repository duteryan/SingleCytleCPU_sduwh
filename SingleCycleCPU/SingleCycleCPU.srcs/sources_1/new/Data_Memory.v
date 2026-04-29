module Data_Memory(
    input wire clk,
    input wire we,          // MemWrite 写使能
    input wire [31:0] addr, // 访存地址 (ALU运算结果)
    input wire [31:0] wd,   // 写数据
    output wire [31:0] rd   // 读数据
);

    // 定义深度为 256、字长为 32 位的 RAM 数组 (1KB 大小)
    reg [31:0] ram [0:255];
    
    integer i;
    initial begin
        // 将内存初始值清零
        for (i = 0; i < 256; i = i + 1) begin
            ram[i] = 32'b0;
        end
    end

    // 同步写操作：在时钟上升沿且写使能为 1 时，将数据写入指定地址
    always @(posedge clk) begin
        if (we) begin
            // 同样取地址的高30位，实现字对齐
            ram[addr[31:2]] <= wd;
        end
    end

    // 异步读操作：只要地址一改变，立马输出该地址对应的数据
    assign rd = ram[addr[31:2]];

endmodule