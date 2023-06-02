`timescale 1ns/1ps

module led_disp_tb();
    reg [15:0] bin;
    reg clock = 1'b0;
    reg reset_n = 1'b0;

    initial begin
        forever begin
            #10 clock = ~clock;
        end
    end

    initial begin
        #5000000 reset_n = 1'b1;
    end

    initial begin
        #5 bin = 16'b0010_1100_1010_0001;
        #30000 bin = 16'b0000_0000_0010_0010;
        #30000 bin = 16'b1111_1111_1010_0111;
        #30000 bin = 16'b0101_1101_0110_0100;
        #30000 bin = 16'b1001_1000_1110_0000;
    end

    wire [7:0] select;
    wire [7:0] seg_1;

    segs_disp_top led_disp_top_0(
        .clock(clock),
        .reset_n(reset_n),
        .switch(bin),
        .seg_1(seg_1),
        .select(select)
    );
    
endmodule