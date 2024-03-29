`timescale 1ns / 1ps

module vga_char(
    input sys_clk,
    input rst_n,
    output hsync,
    output vsync,
    output [3:0] vga_r,
    output [3:0] vga_g,
    output [3:0] vga_b
);
    parameter CLK_CNT=2;
    
    parameter hsync_n=96,
    hback_porch=48,
    hactive_vedio=640,
    hfront_porch=16,
    hpixel_total=800,
    
    vsync_n=2,
    vback_porch=33,
    vactive_vedio=480,
    vfront_porch=10,
    vline_total=525;
    
    reg [CLK_CNT-1:0]cnt=0;
    reg vga_clk;
    always @ (posedge sys_clk) begin
        cnt<=cnt+1;
        vga_clk<=cnt[CLK_CNT-1];
    end
    
    reg [9:0] hcnt;
    always @ (posedge vga_clk) begin
        if(!rst_n)begin
            hcnt<=10'b0;
        end
        else if(hcnt==hpixel_total-1)begin
            hcnt<=10'b0;
        end
        else begin
            hcnt<=hcnt+1;
        end 
    end
    
    reg[9:0] vcnt;

    always @ (posedge vga_clk) begin
        if(!rst_n)begin
            vcnt<=10'b0;
        end   
        else if(hcnt==hpixel_total-1)begin
             if(vcnt==vline_total-1)begin
                vcnt<=10'b0;
             end
             else begin
                vcnt<=vcnt+1;
             end
        end
        else begin
            vcnt<=vcnt;
        end
    end        


    wire hvalid;
    wire vvalid;
    wire vga_vaild;
    
    assign hvalid=(hcnt >= hsync_n + hback_porch-1 && hcnt< hsync_n + hback_porch + hactive_vedio-1);
    assign vvalid=(vcnt >= vsync_n + vback_porch-1 &&vcnt < vsync_n + vback_porch + vactive_vedio-1);
    assign vga_valid=hvalid&&vvalid;
    
    assign hsync=(hcnt>hsync_n-1);
    assign vsync=(vcnt>vsync_n-1);
    
    wire [9:0] x;
    wire [9:0] y;
    assign x=hcnt-hsync_n-hback_porch+2;
    assign y=vcnt-vsync_n-vback_porch+2;
    
    parameter
    line00=128'h00000000000000000000000000000000,
    line01=128'h00000000000000000000000000000000,
    line02=128'h00000000000000000000000000000000,
    line03=128'h00000000000000000000000000000000,
    line04=128'h00000000000000000000000000000000,
    line05=128'h00038000000000000000000000000000,
    line06=128'h00FFFFE07FF80FFC007FF8407FF007FE,
    line07=128'h07E01FE00F8000E003800FC00F800060,
    line08=128'h0F8007E007C000C0070003C00F800060,
    line09=128'h1F0001E003C001800E0000C00F800060,
    line10=128'h1E0000E001E003001E0000600F800060,
    line11=128'h1E00004000F006001E0000000F800060,
    line12=128'h1F000000007804001E0000000F800060,
    line13=128'h1FE0000000780C000F8000000F800060,
    line14=128'h0FFC0000003C180007F800000F800060,
    line15=128'h01FFE000001E300000FF80000F800060,
    line16=128'h003FFE00000E2000000FF8000F800060,
    line17=128'h0003FF80000F60000000FF000F800060,
    line18=128'h00003FE00007C00000000FC00F800060,
    line19=128'h000007F00003C000000003E00F800060,
    line20=128'h000001F80003C000000000F00F800060,
    line21=128'h380000F80003C000100000700F800060,
    line22=128'h3C0000F80003C000180000700F800060,
    line23=128'h1E0000F80003C0001C0000F007800060,
    line24=128'h1F0001F00003C0000E0000E0078000C0,
    line25=128'h1FC003E00003C0000F8001C003C00180,
    line26=128'h0FFFFF800007C0000FF00F0000F81E00,
    line27=128'h0E3FFC00007FFC00000FF000000FE000,
    line28=128'h00000000000000000000000000000000,
    line29=128'h00000000000000000000000000000000,
    line30=128'h00000000000000000000000000000000,
    line31=128'h00000000000000000000000000000000;
    
    reg [6:0] char_bit;
    always @ (posedge vga_clk) begin
        if(!rst_n)begin
            char_bit<=7'd127;
        end
        else if(x>10'd256&&x<=10'd384)begin
            char_bit<=char_bit-1;
        end
        else begin
            char_bit<=char_bit;
        end
    end
    
    reg [11:0] data;
    always @ (posedge vga_clk)begin
        if(!rst_n)begin
            data<=12'hfff;
        end
        else if(x>10'd256&&x<10'd384)begin
            case(y)
                10'd225:data<=line00[char_bit]?12'h000:12'hfff;
                10'd226:data<=line01[char_bit]?12'h000:12'hfff;
                10'd227:data<=line02[char_bit]?12'h000:12'hfff;
                10'd228:data<=line03[char_bit]?12'h000:12'hfff;
                10'd229:data<=line04[char_bit]?12'h000:12'hfff;
                10'd230:data<=line05[char_bit]?12'h000:12'hfff;
                10'd231:data<=line06[char_bit]?12'h000:12'hfff;
                10'd232:data<=line07[char_bit]?12'h000:12'hfff;
                10'd233:data<=line08[char_bit]?12'h000:12'hfff;
                10'd234:data<=line09[char_bit]?12'h000:12'hfff;
                10'd235:data<=line10[char_bit]?12'h000:12'hfff;
                10'd236:data<=line11[char_bit]?12'h000:12'hfff;
                10'd237:data<=line12[char_bit]?12'h000:12'hfff;
                10'd238:data<=line13[char_bit]?12'h000:12'hfff;
                10'd239:data<=line14[char_bit]?12'h000:12'hfff;
                10'd240:data<=line15[char_bit]?12'h000:12'hfff;
                10'd241:data<=line16[char_bit]?12'h000:12'hfff;
                10'd242:data<=line17[char_bit]?12'h000:12'hfff;
                10'd243:data<=line18[char_bit]?12'h000:12'hfff;
                10'd244:data<=line19[char_bit]?12'h000:12'hfff;
                10'd245:data<=line20[char_bit]?12'h000:12'hfff;
                10'd246:data<=line21[char_bit]?12'h000:12'hfff;
                10'd247:data<=line22[char_bit]?12'h000:12'hfff;
                10'd248:data<=line23[char_bit]?12'h000:12'hfff;
                10'd249:data<=line24[char_bit]?12'h000:12'hfff;
                10'd250:data<=line25[char_bit]?12'h000:12'hfff;
                10'd251:data<=line26[char_bit]?12'h000:12'hfff;
                10'd252:data<=line27[char_bit]?12'h000:12'hfff;
                10'd253:data<=line28[char_bit]?12'h000:12'hfff;
                10'd254:data<=line29[char_bit]?12'h000:12'hfff;
                10'd255:data<=line30[char_bit]?12'h000:12'hfff;
                10'd256:data<=line31[char_bit]?12'h000:12'hfff;
                default:data<=12'hfff;
            endcase
        end
    end

    wire [11:0]disp_data;
    assign disp_data=vga_valid?data:12'b0;
    assign vga_r=disp_data[11:8];
    assign vga_g=disp_data[7:4];
    assign vga_b=disp_data[3:0];

endmodule     
