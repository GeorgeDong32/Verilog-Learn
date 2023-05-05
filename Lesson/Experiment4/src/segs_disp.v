module segs_disp (
    input clk,
    input rst_n,
    input [18:0] bcd,
    output reg [7:0] data_seg1,
    output [7: 0] select_n
);
    reg [3:0] bcd_reg [4:0];
    reg [7:0] data_led [4:0];

    //time devide
    reg[17:0] cnt=18'b0;
    reg clk_div=1'b0;
    always @ (posedge clk) begin
        cnt <= cnt+1;
        clk_div <= cnt[17];
    end

    //拆分BCD码，分别存储在寄存器�?
    always @(*)begin
        bcd_reg [0] =bcd[3:0];
        bcd_reg [1] =bcd [7:4];
        bcd_reg [2] =bcd[11:8];
        bcd_reg[3] =bcd [15:12];
        bcd_reg [4] = {1'b0,bcd[18: 16]};
    end

    //BCD->段码
    integer i;
    always @(*) begin
        for(i=0; i < 5; i = i+1) begin
            if(!rst_n) begin
                data_led [i] = 8'hff;
            end
            else begin
                case (bcd_reg [i] [3:0])
                    4'b0000: data_led [i] =8'hc0;
                    4'b0001: data_led [i] =8'hf9;
                    4'b0010: data_led [i]=8'ha4;
                    4'b0011: data_led [i]=8'hb0;
                    4'b0100: data_led [i] =8'h99;
                    4'b0101: data_led [i]=8'h92;
                    4'b0110: data_led [i]=8'h82;
                    4'b0111: data_led[i]=8'hf8;
                    4'b1000: data_led [i] =8'h80;
                    4'b1001: data_led [i] =8'h90;
                    default: data_led [i] =8'hff;
                endcase
            end
        end
    end

    //片�?�，低电平点�?
    reg [7:0] select;
    always @(posedge clk_div) begin
        if(!rst_n) begin
            select <= 8'b0000_1000;
        end
        else begin
            if(select == 8'b1000_0000) begin
                select <= 8'b0000_1000;
            end
            else begin
                select <= select << 1;
            end
        end
    end

    assign select_n = ~select;

    //扫描数码管并显示，同步更新信�?
    always @(*) begin
        case (select_n)
            8'b1111_0111: data_seg1 = data_led [0];
            8'b1110_1111: data_seg1 = data_led [1];
            8'b1101_1111: data_seg1 = data_led [2];
            8'b1011_1111: data_seg1 = data_led [3];
            8'b0111_1111: data_seg1 = data_led [4];
            default: data_seg1 = 8'hff; //关闭数码管显�?    
        endcase
    end
endmodule