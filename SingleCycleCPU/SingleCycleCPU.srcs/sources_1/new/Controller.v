module Controller(
    input wire [5:0] opcode,
    input wire [5:0] funct,
    output wire RegWrite,
    output wire RegDst,
    output wire ALUSrc,
    output wire Branch,
    output wire Jump,
    output wire MemWrite,
    output wire MemtoReg,
    output wire [2:0] ALUControl
);

    wire [1:0] alu_op;

    // 实例化主控制器
    MController u_MController (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .Jump(Jump),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .ALUOp(alu_op)
    );

    // 实例化ALU控制器
    ALU_Controller u_ALU_Controller (
        .ALUOp(alu_op),
        .funct(funct),
        .ALUControl(ALUControl)
    );

endmodule