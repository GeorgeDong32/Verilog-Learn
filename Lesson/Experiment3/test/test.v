`timescale 1ns/1ps
module  test();
    //测试三元乘加器

    reg [31:0] ina, inb;
    reg [63:0] inc;
    wire [63:0] out;

    multiply_accumulate ma1(
        .a(ina),
        .b(inb),
        .c(inc),
        .out(out)
    );

    //开始测试
    initial begin
        #100 ina = 0; inb = 0; inc = 0;
        #100 ina = 2; inb = 3; inc = 5;
        #100 ina = 3; inb = 5; inc = 6;
    end

endmodule