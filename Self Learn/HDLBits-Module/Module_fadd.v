module top_module (
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);//

    wire [15:0] sum_lo, sum_hi;
    wire jinwei;
    wire [15:0] a_lo, a_hi, b_lo, b_hi;
    assign a_lo = a[15:0];
    assign a_hi = a[31:16];
    assign b_lo = b[15:0];
    assign b_hi = b[31:16];

    add16 adder1( .a(a_lo), .b(b_lo), .sum(sum_lo), .cin(0), .cout(jinwei));
    add16 adder2( .a(a_hi), .b(b_hi), .sum(sum_hi), .cin(jinwei), .cout());

    assign sum = {sum_hi, sum_lo};

endmodule

module add1 ( input a, input b, input cin,   output sum, output cout );

    assign sum = a ^ b ^ cin; // 异或运算
    assign cout = (a & b) | (a & cin) | (b & cin); // 与或运算

endmodule
