module MController(
    input wire [5:0] opcode,
    output reg RegWrite,  // 寄存器写使能
    output reg RegDst,    // 写寄存器地址选择 (0: rt, 1: rd)
    output reg ALUSrc,    // ALU源B选择 (0: 寄存器RD2, 1: 立即数)
    output reg Branch,    // 分支指令标志 (beq)
    output reg Jump,      // 无条件跳转标志 (j)
    output reg MemWrite,  // 内存写使能
    output reg MemtoReg,  // 寄存器写回数据选择 (0: ALU结果, 1: 内存数据)
    output reg [1:0] ALUOp // 传递给ALU控制器的粗略操作码
);

    always @(*) begin
        // 默认初始化所有控制信号为0，防止产生锁存器(Latch)
        RegWrite = 1'b0; RegDst   = 1'b0; ALUSrc   = 1'b0;
        Branch   = 1'b0; Jump     = 1'b0; MemWrite = 1'b0;
        MemtoReg = 1'b0; ALUOp    = 2'b00;

        case (opcode)
            // R型指令 (addu, subu, and, sltu 等) 
            6'b000000: begin
                RegWrite = 1'b1; RegDst = 1'b1; ALUOp = 2'b10;
            end
            // lw (Load Word) 读取内存指令 
            6'b100011: begin
                RegWrite = 1'b1; ALUSrc = 1'b1; MemtoReg = 1'b1; ALUOp = 2'b00;
            end
            // sw (Store Word) 写入内存指令 
            6'b101011: begin
                ALUSrc = 1'b1; MemWrite = 1'b1; ALUOp = 2'b00;
            end
            // beq (Branch on Equal) 分支指令 
            6'b000100: begin
                Branch = 1'b1; ALUOp = 2'b01;
            end
            // j (Jump) 无条件跳转指令 
            6'b000010: begin
                Jump = 1'b1;
            end
            // ori (Or Immediate) 扩展指令中经常用到的逻辑或立即数 
            6'b001101: begin
                RegWrite = 1'b1; ALUSrc = 1'b1; ALUOp = 2'b11;
            end
            default: ; // 遇到未知指令保持全0
        endcase
    end

endmodule