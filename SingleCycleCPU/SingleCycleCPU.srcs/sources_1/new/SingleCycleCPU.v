module SingleCycleCPU(
    input wire clk,
    input wire rst
);

    // --- 内部连接导线声明 ---
    wire [5:0] opcode;
    wire [5:0] funct;
    
    wire RegWrite;
    wire RegDst;
    wire ALUSrc;
    wire Branch;
    wire Jump;
    wire MemWrite;
    wire MemtoReg;
    wire [2:0] ALUControl;

    // 1. 实例化控制单元 
    Controller u_Controller (
        .opcode(opcode),
        .funct(funct),
        .RegWrite(RegWrite),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .Jump(Jump),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .ALUControl(ALUControl)
    );

    // 2. 实例化数据通路 (躯体)
    DataPath u_DataPath (
        .clk(clk),
        .rst(rst),
        // 接收控制信号
        .RegWrite(RegWrite),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .Jump(Jump),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .ALUControl(ALUControl),
        // 输出指令特征给控制器
        .opcode(opcode),
        .funct(funct)
    );

endmodule