`timescale 1ns/1ps
module  test();
    //初始化输入输出线
    reg E;
    reg [15:0] in;
    wire [65535:0] Y;

    decoder_16 d16(in, E, Y);
    integer i;
    //开始测试
    initial begin
        in = 0;
        E = 0;
        for (i = 0; i < 65536; i = i + 1) begin          
            #1;
            in = in + 1;
        end
    end

endmodule