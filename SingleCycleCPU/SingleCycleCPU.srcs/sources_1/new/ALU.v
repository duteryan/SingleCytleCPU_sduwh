module ALU(
    input wire [31:0] SrcA,
    input wire [31:0] SrcB,
    input wire [2:0] ALUControl,
    output reg [31:0] ALUResult,
    output wire Zero
);

    // ALUControl 操作码定义 (参照经典的 MIPS ALU 编码设计)
    localparam ALU_AND  = 3'b000;
    localparam ALU_OR   = 3'b001;
    localparam ALU_ADD  = 3'b010;
    localparam ALU_SUB  = 3'b110;
    localparam ALU_SLTU = 3'b111; // sltu: 无符号小于则置位 (Set on Less Than Unsigned)

    // 组合逻辑计算 ALUResult
    always @(*) begin
        case (ALUControl)
            ALU_AND:  ALUResult = SrcA & SrcB;
            ALU_OR:   ALUResult = SrcA | SrcB;
            ALU_ADD:  ALUResult = SrcA + SrcB;
            ALU_SUB:  ALUResult = SrcA - SrcB;
            ALU_SLTU: ALUResult = (SrcA < SrcB) ? 32'd1 : 32'd0; // 无符号比较
            default:  ALUResult = 32'd0; // 默认输出 0
        endcase
    end

    // 生成 Zero 标志位
    // 如果运算结果所有位都是0，Zero信号为1，用于beq等分支指令判断
    assign Zero = (ALUResult == 32'd0) ? 1'b1 : 1'b0;

endmodule