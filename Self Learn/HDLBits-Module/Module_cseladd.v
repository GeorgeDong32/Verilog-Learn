module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);

    wire [15:0] sum_lo, sum_hi, sum_h1, sum_h2;
    wire hc;
    wire [15:0] a_lo, a_hi, b_lo, b_hi;
    assign a_lo = a[15:0];
    assign a_hi = a[31:16];
    assign b_lo = b[15:0];
    assign b_hi = b[31:16];

    add16 adder1( .a(a_lo), .b(b_lo), .sum(sum_lo), .cin(0), .cout(hc));
    add16 adder2( .a(a_hi), .b(b_hi), .sum(sum_h1), .cin(0), .cout());
    add16 adder3( .a(a_hi), .b(b_hi), .sum(sum_h2), .cin(1), .cout());

    assign sum = (hc == 1'b0) ? {sum_h1, sum_lo} : {sum_h2, sum_lo};

endmodule