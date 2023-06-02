`timescale 1ns / 100ps
module urat_testbench_module ( );

    reg [7:0] datapc2bd;
    reg clock;
    reg reset;
    wire clk;
    wire receive_ack;
    reg trans_ack;
    wire txd;
    wire rxd;
    wire [7:0] datarxout;
    reg [7:0] databd2pc;
    reg [4:0] s;

    uart_receiver DUTrx(.rxd(rxd), .rst(reset), .clk(clk), .data_in(datarxout), .receive_ack(receive_ack));
    uart_transmitter DUTtx(.data_out(datapc2bd), .rst(reset), .trans_ack(trans_ack), .clk(clk), .txd(txd));
    clk_div DUTclk(.clk_out(clk), .clk(clock));

    assign rxd = txd;

    initial begin
        clock = 0;
        #10 forever #10 clock = ~clock;
    end

    initial begin
        reset = 0;
        datapc2bd = 0;
        trans_ack = 0;
        s = 0;
        #800_000 reset = 1;
    end

    always @(posedge clk) begin
        if(reset == 1) begin
            if(s == 10)
                s = 1;
            else
                s = s + 1;
        end
        else 
            s = 0;
    end

    always @(posedge clk) begin
        case(s)
            1: begin
                datapc2bd = $random %100;
                trans_ack = 1;
            end 
            2:begin
                databd2pc = datarxout;
                trans_ack = 0;
            end
            default: trans_ack = 0;
        endcase
    end

endmodule //urat_testbench
