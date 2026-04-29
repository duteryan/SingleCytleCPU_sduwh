module ALU_Controller(
    input wire [1:0] ALUOp,
    input wire [5:0] funct,
    output reg [2:0] ALUControl
);

    always @(*) begin
        case (ALUOp)
            // ALUOp = 00: lw/sw 需要进行加法运算计算地址 
            2'b00: ALUControl = 3'b010; // ADD
            
            // ALUOp = 01: beq 需要进行减法运算判断是否相等 
            2'b01: ALUControl = 3'b110; // SUB
            
            // ALUOp = 11: ori 扩展指令，强制执行逻辑或运算 
            2'b11: ALUControl = 3'b001; // OR
            
            // ALUOp = 10: R型指令，具体操作取决于 funct 字段 
            2'b10: begin
                case (funct)
                    6'b100000: ALUControl = 3'b010; // add
                    6'b100001: ALUControl = 3'b010; // addu (在此设计中无符号加等同于有符号加的硬件通路)
                    6'b100010: ALUControl = 3'b110; // sub
                    6'b100011: ALUControl = 3'b110; // subu
                    6'b100100: ALUControl = 3'b000; // and
                    6'b100101: ALUControl = 3'b001; // or
                    6'b101011: ALUControl = 3'b111; // sltu
                    default:   ALUControl = 3'b000;
                endcase
            end
            
            default: ALUControl = 3'b000;
        endcase
    end

endmodule