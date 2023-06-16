module vga_char_tb();
    reg clk=0;
    reg rst_n=0;
    wire hsync;
    wire vsync;
    wire [3:0]VGA_R;
    wire [3:0]VGA_G;
    wire [3:0]VGA_B;

    initial begin
        #10 forever #10 clk=~clk;
    end

    initial begin
        #100 rst_n=1'b1;
    end

    vga_char vga_char_0(
        .sys_clk(clk),
        .rst_n(rst_n),
        .hsync(hsync),
        .vsync(vsync),
        .vga_r(VGA_R),
        .vga_g(VGA_G),
        .vga_b(VGA_B)
    );
    
endmodule
