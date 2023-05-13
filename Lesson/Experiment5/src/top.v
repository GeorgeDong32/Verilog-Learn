module top (
        input clk,
        input rst,
        input trigger,
        output [`DataBus] dout
    );

    wire [`AddrBus] raddr;
    wire [`AddrBus] waddr;
    wire wen;
    wire[`DataBus] wdata;
    wire ena;
    wire enb;

    sorting u_sorting(
        .clk(clk),
        .ena(ena),
        .enb(enb),
        .raddr(raddr),
        .rdata(dout),
        .rst(rst),
        .trigger(trigger),
        .waddr(waddr),
        .wdata(wdata),
        .wen(wen)
    );

    blk_mem_gen_0 u_blk_mem_gen_0(
        .addra(waddr),
        .clka(clk),
        .dina(wdata),
        .ena(ena),
        .wea(wen),
        .addrb(raddr),
        .clkb(clk),
        .doutb(dout),
        .enb(enb)
    );
endmodule