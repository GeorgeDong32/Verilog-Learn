`timescale 1ns/1ps
module  test();
    //测试三元乘加器

    reg [31,0] ina, inb;
    reg [63,0] inc;
    wire [63,0] out;

    multiply_accumulate ma1(
        .a(ina),
        .b(inb),
        .c(inc),
        .out(out)
    );

    //开始测试
    initial begin
       
        
    end

endmodule