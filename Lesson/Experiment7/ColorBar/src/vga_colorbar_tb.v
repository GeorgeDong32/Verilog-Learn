module vga_colorbar_tb();

    reg sys_clk=0;
    reg rst_n=0;

    initial begin
        #10 forever #5 sys_clk=~sys_clk;
    end

    initial begin
        #100 rst_n=1'b1;
    end

    wire hsync;
    wire vsync;
    wire [3:0]vga_r;
    wire [3:0]vga_g;
    wire [3:0]vga_b;
    vga_colorbar vga_colorbar_0(
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .switch(2'b00),
        .hsync(hsync),
        .vsync(vsync),
        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b)
    );
    
endmodule