`define AddrBus 2:0
`define DataBus 15:0
`define BramDepth 8
`define BramWidth 16
`define AddrBusWidth 3
module sorting(
    input rst,
    input clk,
    input trigger,
    input [`DataBus] rdata,
    output reg [`AddrBus] raddr,
    output reg [`AddrBus] waddr,
    output reg wen,
    output reg [`DataBus] wdata,
    output reg ena,
    output reg enb
    );

    reg [1:0] cstate,nstate;
    parameter IDLE=2'b00,SORT=2'b01,VALIDATE=2'b10;
    reg flag_read;
    reg flag_write;

    always@(posedge clk or negedge rst)begin
        if(rst==1'b0)
            cstate<=IDLE;
        else
            cstate<=nstate;
    end

    always@(*)begin
        case(cstate)
            IDLE:begin 
                if(trigger==1'b1) nstate=SORT;
                else nstate=IDLE;
            end
            SORT:begin 
                if(waddr==`AddrBusWidth'd0) nstate= VALIDATE;
                else nstate=SORT;
            end
            VALIDATE:begin 
                if(raddr==`BramDepth-1) nstate=IDLE;
                else nstate=VALIDATE;
            end
            default: nstate=IDLE;
        endcase
    end

    always@(*)begin
        case(cstate)
            IDLE:begin 
                wen=1'b0;ena=1'b0;enb=1'b0;
            end
            SORT:begin
                ena=1'b1;
                enb=1'b1;
                if(flag_write==1'b1)
                    wen=1'b1;
                else
                    wen=1'b0;
            end
            VALIDATE:begin 
                wen=1'b0;ena=1'b0;enb=1'b1;
            end
            default:begin 
                wen=1'b0;ena=1'b0;enb=1'b0;
            end
        endcase
    end

    wire [`AddrBus] waddr_plus_1, raddr_plus_1;
    assign waddr_plus_1 = waddr+1;
    assign raddr_plus_1 = raddr+1;

    always@(posedge clk or negedge rst)begin
        if(rst==1'b0)begin
            wdata<=`BramWidth'd0;
            raddr<=`AddrBusWidth'd0;
            waddr<=`AddrBusWidth'd0;
            flag_read<=1'b0;
            flag_write<=1'b0;
        end 
        else begin
            wdata<=rdata;
            if(cstate==IDLE)begin
                raddr<=`AddrBusWidth'd0;
                waddr<=`AddrBusWidth'd1;
                flag_read<=1'b1;
                flag_write<=1'b0;
            end 
            else if(cstate==SORT) begin
                if(flag_read==1'b1) raddr<=raddr_plus_1;
                if(raddr==`AddrBusWidth'd7) flag_read<=1'b0;
                if(raddr==`AddrBusWidth'd1) flag_write<=1'b1;
                if(flag_write==1'b1) waddr<=waddr_plus_1;
            end 
            else if(cstate==VALIDATE)begin 
                raddr<=raddr_plus_1;
            end
        end
    end
endmodule