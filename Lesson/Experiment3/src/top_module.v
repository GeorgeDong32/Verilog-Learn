//三元乘加�?

module multiply_accumulate(
    input [31:0] a,b,
    input [63:0] c,
    output [63:0] out,
    output cout
);

    wire [63:0] product_temp;

    unsigned_multi32 um1(
        .ina(a),
        .inb(b),
        .out(product_temp)
    );

    CLA_64 cla1(
        .a(product_temp),
        .b(c),
        .cin(1'b0),
        .sum(out),
        .cout(cout)
    );

endmodule