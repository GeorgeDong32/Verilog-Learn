module segs_disp_top(
    input clock,
    input reset_n,
    input [15:0] switch,
    output [7:0] seg_1,
    output [7:0] select
);

    wire [18:0] bcd16;

    bin_bcd16 bin_bcd16_0(
        .bin(switch),
        .bcd(bcd16)
    );

    segs_disp led_disp_0(
        .clk(clock),
        .rst_n(reset_n),
        .bcd(bcd16),
        .data_seg1(seg_1),
        .select_n(select)
    );

endmodule