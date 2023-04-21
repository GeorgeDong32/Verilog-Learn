//三元乘加器基本模块

//无符号32位移位乘法器
module unsigned_multi32(
    input [31,0] ina, inb,
    output reg [63,0] out
);

    integer i;
    reg [63,0] shifta;
    reg [31,0] shiftb;
    always @(ina or inb) begin
        shifta = ina;
        shiftb = inb;
        out = 0;
        for (i = 0; i < 32; i = i + 1) begin
            if(shiftb[0])
                out = out + shifta;
            else
                out = out;

            shifta = shifta << 1;
            shiftb = shiftb >> 1;
        end
    end

endmodule

//4位超前进位加法器
module CLA_4(
    input [3:0] a, b;       // 4位输入
    input cin;             // 进位输入 
    output [3:0] sum;      // 4位输出和
    output cout;           // 进位输出
);
    wire [3:0] p, g;      // 生成和进位信号
    wire [2:0] c;         // 进位信号
    // 计算生成和进位信号
    assign p[0] = a[0] ^ b[0]; 
    assign g[0] = a[0] & b[0];
    assign p[1] = a[1] ^ b[1];
    assign g[1] = a[1] & b[1]; 
    assign p[2] = a[2] ^ b[2];  
    assign g[2] = a[2] & b[2];
    assign p[3] = a[3] ^ b[3];
    assign g[3] = a[3] & b[3];

    // 第一级进位  
    assign c[0] = g[0] | (p[0] & cin);

    // 第二级进位
    assign c[1] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);  

    // 第三级进位 
    assign c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                (p[2] & p[1] & p[0] & cin);

    // 最后一级进位          
    assign cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & cin);
                
    // 求和        
    assign sum[0] = p[0] ^ cin; 
    assign sum[1] = p[1] ^ c[0];
    assign sum[2] = p[2] ^ c[1];
    assign sum[3] = p[3] ^ c[2]; 

endmodule

//16位超前进位加法器
module CLA_16(
    input [15:0] a, b;    // 16位输入
    input cin;            // 进位输入
    output [15:0] sum;    // 16位输出和
    output cout;          // 进位输出
);
    wire [3,0] c;         // 进位信号

    CLA_4 add1(.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .cout(c[0]));
    CLA_4 add2(.a(a[7:4]), .b(b[7:4]), .cin(c[0]), .sum(sum[7:4]), .cout(c[1]));
    CLA_4 add3(.a(a[11:8]), .b(b[11:8]), .cin(c[1]), .sum(sum[11:8]), .cout(c[2]));
    CLA_4 add4(.a(a[15:12]), .b(b[15:12]), .cin(c[2]), .sum(sum[15:12]), .cout(cout));

endmodule

module CLA_64(
    input [63:0] a, b;    // 64位输入
    input cin;            // 进位输入
    output [63:0] sum;    // 64位输出和
    output cout;          // 进位输出
);
    wire [15:0] c;         // 进位信号

    CLA_16 add1(.a(a[15:0]), .b(b[15:0]), .cin(cin), .sum(sum[15:0]), .cout(c[0]));
    CLA_16 add2(.a(a[31:16]), .b(b[31:16]), .cin(c[0]), .sum(sum[31:16]), .cout(c[1]));
    CLA_16 add3(.a(a[47:32]), .b(b[47:32]), .cin(c[1]), .sum(sum[47:32]), .cout(c[2]));
    CLA_16 add4(.a(a[63:48]), .b(b[63:48]), .cin(c[2]), .sum(sum[63:48]), .cout(cout));

endmodule