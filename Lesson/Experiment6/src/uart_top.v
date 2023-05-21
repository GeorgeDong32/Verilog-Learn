module uart_top(
    input wire reset, clock,
    input rxd,
    output txd
);

    wire trans_start;
    wire [7:0] dataparal;
    wire clk_9600;
    uart_receiver DUTrx(.rxd(rxd), .rst(reset), .clk(clk_9600), .data_in(dataparal), .receive_ack(trans_start));
    uart_transmitter DUTtx(.data_out(dataparal), .rst(reset), .trans_ack(trans_start), .clk(clk_9600), .txd(txd));
    clkdiv DUTclk(.clk_out(clk_9600), .clk(clock));

endmodule