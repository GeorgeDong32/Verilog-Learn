module STD1(X,Y,Z);
    input X,Y;
    output Z;

    assign Z = X & ~Y;
endmodule

module test();
    reg dinl ,din2;
    wire dout;
    STD1 DUT (.X(din1), .Y(din2), .Z(dout));
    initial begin
        #10 din1 = 0; din2 = 0;
        #10 din1 = 1; din2 = 0;
    end
endmodule