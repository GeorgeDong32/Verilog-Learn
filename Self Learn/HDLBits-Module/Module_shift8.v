module top_module ( 
    input clk, 
    input [7:0] d, 
    input [1:0] sel, 
    output [7:0] q 
);
    wire q1, q2, q3;
    my_dff8 dff1(clk, d, q1);
    my_dff8 dff2(clk, q1, q2);
    my_dff8 dff3(clk, q2, q3);
    assign q = (sel == 2'b00) ? d : (sel == 2'b01) ? q1 : (sel == 2'b10) ? q2 : q3;

endmodule
