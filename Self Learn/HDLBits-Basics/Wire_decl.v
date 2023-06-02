//声明电线Wire decl
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n   ); 
    wire abin;
    wire cdin;
    wire mid;
    assign abin = a & b;
    assign cdin = c & d;
    assign mid = abin | cdin;
    assign out = mid;
    assign out_n = !mid;
endmodule