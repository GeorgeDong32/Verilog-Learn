module clkdiv(
    input clk ,
    output reg clk_out
);
    localparam Baud_rate = 9600;
    localparam div_num='d100_000_000/Baud_rate;  //计算时钟分频�?
    reg[15:0] count; //存储当前计数
    initial
        count =0;
    always @ ( posedge clk) begin
        if ( count == div_num) begin
            count <= 0;
            clk_out <= 1;
        end
        else begin
            count <= count + 1;
            clk_out<=0;
        end
    end
endmodule