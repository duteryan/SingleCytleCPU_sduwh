module DataPath(
    input wire clk,
    input wire rst,
    // --- 以下为预留给控制单元(Controller)的控制信号 ---
    input wire RegWrite,    // 寄存器写使能
    input wire RegDst,      // 写寄存器地址选择 (0: rt, 1: rd)
    input wire ALUSrc,      // ALU源B选择 (0: 寄存器RD2, 1: 符号扩展立即数)
    input wire Branch,      // 分支指令标志
    input wire Jump,        // 跳转指令标志
    input wire MemWrite,    // 内存写使能
    input wire MemtoReg,    // 写回数据选择 (0: ALU结果, 1: 内存读出数据)
    input wire [2:0] ALUControl, // ALU操作控制码
    
    // --- 供控制器解码的输出 ---
    output wire [5:0] opcode,
    output wire [5:0] funct
);

    // --- 内部信号连线声明 ---
    wire [31:0] pc_current, pc_next, pc_plus4;
    wire [31:0] instr;
    wire [4:0]  write_reg_addr;
    wire [31:0] write_reg_data;
    wire [31:0] rd1, rd2;
    wire [31:0] sign_imm, sign_imm_shifted;
    wire [31:0] alu_src_b;
    wire [31:0] alu_result;
    wire        zero_flag;
    wire [31:0] mem_read_data;
    wire [31:0] branch_target, jump_target_addr;
    wire        pc_src; // 决定是否发生分支跳转

    // 1. 指令解码分配
    assign opcode = instr[31:26];
    assign funct  = instr[5:0];
    
    // 2. PC 更新计算
    assign pc_plus4 = pc_current + 32'd4;
    // 符号扩展立即数 (16位 -> 32位)
    assign sign_imm = {{16{instr[15]}}, instr[15:0]};
    // 计算分支目标地址: PC+4 + (立即数左移2位)
    assign sign_imm_shifted = {sign_imm[29:0], 2'b00};
    assign branch_target = pc_plus4 + sign_imm_shifted;
    // 计算Jump目标地址: (PC+4)的高4位 拼接 26位目标地址左移2位
    assign jump_target_addr = {pc_plus4[31:28], instr[25:0], 2'b00};

    // MUX: 是否进行分支跳转? (当是Branch指令且ALU运算结果为0时)
    assign pc_src = Branch & zero_flag;
    wire [31:0] pc_next_branch = pc_src ? branch_target : pc_plus4;
    
    // MUX: 是否进行无条件跳转?
    assign pc_next = Jump ? jump_target_addr : pc_next_branch;

    // --- 实例化五大核心模块 ---

    // 1. 程序计数器 PC
    PC_Register u_PC (
        .clk(clk),
        .rst(rst),
        .next_pc(pc_next),
        .pc(pc_current)
    );

    // 2. 指令存储器 IM
    Instruction_Memory u_IM (
        .pc_addr(pc_current),
        .instruction(instr)
    );

    // MUX: 寄存器写入地址选择 (RegDst: 0->rt, 1->rd)
    assign write_reg_addr = RegDst ? instr[15:11] : instr[20:16];

    // MUX: 寄存器写入数据选择 (MemtoReg: 0->ALU, 1->Memory)
    assign write_reg_data = MemtoReg ? mem_read_data : alu_result;

    // 3. 寄存器堆 RF
    Register_File u_RF (
        .clk(clk),
        .we(RegWrite),
        .ra1(instr[25:21]), // rs
        .ra2(instr[20:16]), // rt
        .wa(write_reg_addr),
        .wd(write_reg_data),
        .rd1(rd1),
        .rd2(rd2)
    );

    // MUX: ALU源B选择 (ALUSrc: 0->RD2, 1->立即数)
    assign alu_src_b = ALUSrc ? sign_imm : rd2;

    // 4. 算术逻辑单元 ALU
    ALU u_ALU (
        .SrcA(rd1),
        .SrcB(alu_src_b),
        .ALUControl(ALUControl),
        .ALUResult(alu_result),
        .Zero(zero_flag)
    );

    // 5. 数据存储器 DM
    Data_Memory u_DM (
        .clk(clk),
        .we(MemWrite),
        .addr(alu_result), // 访存地址来自ALU计算结果
        .wd(rd2),          // 写入的数据来自寄存器 rt
        .rd(mem_read_data)
    );

endmodule