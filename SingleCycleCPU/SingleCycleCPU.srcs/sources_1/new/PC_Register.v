module PC_Register(
    input wire clk,
    input wire rst,
    input wire [31:0] next_pc,
    output reg [31:0] pc
);

    // 采用异步复位机制
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 复位时，PC通常指向内存的初始指令地址 (例如全0，或 0x00400000)
            pc <= 32'h00000000; 
        end else begin
            // 在时钟上升沿，将下一个地址锁存进来
            pc <= next_pc;      
        end
    end

endmodule