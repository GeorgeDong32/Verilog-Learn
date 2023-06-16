module vga_disp_my (
    input sys_clk,
    input rst_n,
    input [1:0] switch,
    output hsync,
    output vsync,
    output [3:0] vga_r,
    output [3:0] vga_g,
    output [3:0] vga_b
);

    parameter CLK_CNT = 2;

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

    reg[CLK_CNT-1:0] cnt=0;
    reg vga_clk;
    always @(posedge sys_clk) begin
                cnt<=cnt+1;
                vga_clk<=cnt[CLK_CNT-1]; 
    end

    reg[9:0] hcnt;
    always @(posedge vga_clk) begin
        if(!rst_n) begin
            hcnt<=10'b0;
        end
        else if (hcnt==hpixel_total-1) begin
            hcnt<=10'b0;
        end
        else begin
            hcnt<=hcnt+1;
        end
    end

    reg[9:0] vcnt;

    always @(posedge vga_clk) begin
        if (!rst_n) begin
            vcnt<=10'b0;
        end
        else if (hcnt==hpixel_total-1) begin
            if (vcnt==vline_total-1) begin
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
    wire vga_valid;

    assign hvalid= (hcnt>=hsync_n+hback_porch-1&&hcnt<hsync_n+hback_porch+hactive_vedio-1);
    assign vvalid= (vcnt>=vsync_n+vback_porch-1&&vcnt<vsync_n+vback_porch+vactive_vedio-1);
    assign vga_valid=hvalid&&vvalid;

    assign hsync=(hcnt>hsync_n-1);
    assign vsync=(vcnt>vsync_n-1);

    reg[11:0] h_data;
    always @(posedge vga_clk) begin
        if (hcnt<(hsync_n+hback_porch-1+10'd80)) begin
            h_data <= 12'd0;
        end
        else if (hcnt<(hsync_n+hback_porch-1+10'd160)) begin
            h_data<=12'd585;
        end
        else if (hcnt<(hsync_n+hback_porch-1+10'd240)) begin
            h_data<=12'd1170;
        end
        else if (hcnt<(hsync_n+hback_porch-1+10'd320)) begin
            h_data<=12'd1755;
        end
        else if (hcnt<(hsync_n+hback_porch-1+10'd400)) begin
            h_data<=12'd2340;
        end
        else if (hcnt<(hsync_n+hback_porch-1+10'd480)) begin
            h_data<=12'd2925;
        end
        else if (hcnt<(hsync_n+hback_porch-1+10'd560)) begin
            h_data<=12'd3510;
        end
        else begin
            h_data<=12'd4095;
        end
    end

    reg[11:0] v_data;

    always @(posedge vga_clk) begin
        if (vcnt<(vsync_n+vback_porch-1+10'd60)) begin
            v_data <= 12'd0;
        end
        else if (vcnt<(vsync_n+vback_porch-1+10'd120)) begin
            v_data<=12'd585;
        end
        else if (vcnt<(vsync_n+vback_porch-1+10'd180)) begin
            v_data<=12'd1170;
        end
        else if (vcnt<(vsync_n+vback_porch-1+10'd240)) begin
            v_data<=12'd1755;
        end
        else if (vcnt<(vsync_n+vback_porch-1+10'd300)) begin
            v_data<=12'd2340;
        end
        else if (vcnt<(vsync_n+vback_porch-1+10'd360)) begin
            v_data<=12'd2925;
        end
        else if (vcnt<(vsync_n+vback_porch-1+10'd420)) begin
            v_data<=12'd3510;
        end
        else begin
            v_data<=12'd4095;
        end
    end

    reg[11:0] data;

    always @(posedge vga_clk) begin
        case (switch)
        2'b00: data<=h_data;
        2'b01: data<=v_data;
        2'b10: data<= h_data^v_data;
        default: data<=~(h_data^v_data);
        endcase
    end

    wire[11:0] disp_data;

    assign disp_data= vga_valid ?data: 12'b0;
    assign vga_r=disp_data[11:8];
    assign vga_g=disp_data[7:4];
    assign vga_b=disp_data[3:0];

endmodule