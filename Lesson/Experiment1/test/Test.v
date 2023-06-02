`timescale 1ns / 100ps

module test_d3z();

    reg rst, clk;
    reg din;
    wire result;
    reg gold;
    wire trace;
    
    detect_3zero DUT (.clock(clk), .reset(rst), .bitin(din), .indicator(result));
    
    initial begin
        clk = 1'b0;
        rst = 1'b1;
        din = 1'b0;
        gold = 1'b0;
    end
    
    always begin
        #5 clk = 1'b0;
        #5 clk = 1'b1;
    end
    
    initial begin
        #1 rst = 1'b0;
        #4 rst = 1'b1; din = 1'b1;
        #5 gold = 1'b0;
        #5 din = 1'b1; 
        #5 gold = 1'b0;
        #5 din = 1'b0;
        #5 gold = 1'b0;
        #5 din = 1'b0; 
        #5 gold = 1'b0;
        #5 din = 1'b1;
        #5 gold = 1'b0;
        #5 din = 1'b0;
        #5 gold = 1'b0;
        #5 din = 1'b0;
        #5 gold = 1'b0;
        #5 din = 1'b0; 
        #5 gold = 1'b1;
        #5 din = 1'b1;
        #5 gold = 1'b0; 
        #5 din = 1'b1;
        #5 gold = 1'b0; 
        #5 din = 1'b0;
        #5 gold = 1'b0; 
        #5 din = 1'b0;
        #5 gold = 1'b0; 
        #5 din = 1'b0;
        #5 gold = 1'b1; 
        #5 din = 1'b0;
        #5 gold = 1'b1; 
        #5 din = 1'b0;
        #5 gold = 1'b1;   
        end
        
        assign trace = (result & gold) | (~result & ~gold);
    
endmodule