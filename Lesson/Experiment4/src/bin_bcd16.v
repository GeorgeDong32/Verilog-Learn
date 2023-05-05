module bin_bcd16(
    input [15: 0] bin,
    output reg [18: 0] bcd
);
    //中间变量
    reg [34: 0] x;
    integer i;

    always @ (*) begin
        for ( i=0; i<35; i=i+1 ) begin//中间变量赋初值x
            x[i]=0;
        end

        x[18:3]=bin; //左移3位
        repeat (13)//总共左移16位，将16位bin全部移出

        begin
            if (x[19:16]>4) begin
                x[19:16] =x[19:16] +3;
            end                     
            if(x[23:20]>4) begin
                x[23:20] =x[23:20] +3;
            end
            if(x[27:24]>4)begin
                x[27:24] =x[27:24] +3;
            end
            if(x[31:28]>4)begin
                x[31:28] =x[31:28] +3;
            end
            if (x [34: 32] > 4) begin
                x[34:32] =x[34:32] +3;
            end
            x[34:1] =x[33:0];
        end
        
        bcd =x[34:16];
    end
endmodule