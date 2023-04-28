module multiply_accumulate_tb ();

    reg [31:0] a;
    reg [31:0] b;
    reg [63:0] c;
    wire [63:0] result;
    reg clock;

    // 实例化multiply_accumulate模块
    multiply_accumulate multiply_accumulate_inst (
        .a(a),
        .b(b),
        .c(c),
        .out(result)
    );
    
    initial begin:toggeling
        clock = 0;
        #10 forever #10 clock = ~clock;
    end
    
    initial begin:stimulus
        a = 0;
        b = 0;
        c = 0;
        #300 disable toggeling;
        $display("simulation time is %t",$time);
    end
    always @(posedge clock) begin
        $monitor ($time,,"result=",result);
        #5 a = a+2;
             b = b+5;
             c = c+3;
    end
    // 生成测试用例
    /*initial begin
        $display("a, b, c, result");
        test_case(32'h00000001, 32'h00000002, 64'h0000000000000003);
        test_case(32'hFFFFFFFE, 32'h00000002, 64'h0000000000000000);
        test_case(32'h00000000, 32'h00000000, 64'hFFFFFFFFFFFFFFFF);
        //my test case
        
        $finish;
    end

    // 测试用例函数
    task test_case;
        input [31:0] test_a;
        input [31:0] test_b;
        input [63:0] test_c;
        begin
            a = test_a;
            b = test_b;
            c = test_c;
            #10;
            $display("32'h%h, 32'h%h, 64'h%h, 64'h%h", a, b, c, result);
        end
    endtask*/

endmodule