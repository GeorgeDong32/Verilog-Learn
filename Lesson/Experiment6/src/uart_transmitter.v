module uart_transmitter(
	input [7:0] data_o,
	input clk,
	input rst,
	input trans_ack,
	output reg txd
);
	localparam IDLE=0, SEND_START=1, SEND_DATA=2, SEND_END=3;
	reg [3:0] cur_st, nxt_st;
	reg [4:0] count;
	reg [7:0] data_o_tmp;
	
	always @ (posedge clk) begin
		if(rst==0)
			cur_st<=IDLE;
		else
			cur_st<=nxt_st;
	end
	
	
	always @ (*) begin
		nxt_st<=cur_st;
		case (cur_st)
			IDLE: if (trans_ack) nxt_st<=SEND_START;
			SEND_START: nxt_st<=SEND_DATA;
			SEND_DATA: if (count==7) nxt_st<=SEND_END;
			SEND_END: if (trans_ack) nxt_st<=SEND_START;
			default: nxt_st<=IDLE;
		endcase
	end
	
	always @ (posedge clk) begin
		if(cur_st==SEND_DATA)
			count<=count+1;
		else if (cur_st==IDLE|cur_st==SEND_END)
			count<=0;
	end
	
	always @ (posedge clk) begin
		if(cur_st==SEND_START)
			data_o_tmp<=data_o;
		else if (cur_st<=SEND_DATA)
			data_o_tmp [6:0] <=data_o_tmp[7:1];
	end
	
	always @ (posedge clk) begin
		if (cur_st==SEND_START)
			txd<=0;
		else if (cur_st==SEND_DATA)
			txd<=data_o_tmp[0];
		else if (cur_st==SEND_END)
			txd<=1;
		else
			txd<=1;
	end
	endmodule