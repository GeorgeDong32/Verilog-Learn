`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/02 16:48:25
// Design Name: 
// Module Name: vga_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_tb();
reg rst,clk;
initial begin
    rst=0;
    #20 rst=1;
    #20 rst=0;
end
initial clk=1;
always begin
    #20 clk=~clk;
end
vga_colorbar vga_colorbar(
    .clk(vga_clk),
    .rst(rst_n)
);
endmodule
