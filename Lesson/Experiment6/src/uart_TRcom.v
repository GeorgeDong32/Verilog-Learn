module uart_TRcom(
	input wire reset, clock,
	input rxd,
	output txd
);

	wire trans_start;
	wire[7:0] dataparal;
	wire clk_9600;

	uart_receiver DUTrx (.rxd(rxd), .rst(reset), .clk(clk_9600), .data_i(dataparal), .receive_ack(trans_start));
	uart_transmitter DUTtx (.data_o (dataparal), .rst(reset), .trans_ack(trans_start), .clk(clk_9600), .txd(txd));
	clk_div DUTclk (clock, clk_9600);
	
endmodule