module sorting_tb();
    reg clk;
    reg rst;
    reg trigger;
    wire [`DataBus] dout;

    top u_top(
        .clk(clk),
        .rst(rst),
        .trigger(trigger),
        .dout(dout)
    );

    always begin
        #5 clk = 1'b0;
        #5 clk = 1'b1;
    end

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        trigger = 1'b0;
        #1 rst = 1'b0;
        #4 rst = 1'b1;
        #30 trigger = 1'b1;
        #10 trigger = 1'b0;
        #300 trigger = 1'b1;
        #10 trigger = 1'b0;
        #300 trigger = 1'b1;
        #10 trigger = 1'b0;
    end

endmodule