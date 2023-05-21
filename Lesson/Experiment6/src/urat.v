module uart_transmitter(
    input [7:0] data_out,
    input clk,
    input rst,
    input trans_ack,
    output reg txd
);

    localparam IDLE=0,SEND_START=1,SEND_DATA=2,SEND_END=3;
    
    reg [3:0] cur_state,next_state;
    reg [4:0] count;
    reg [7:0] data_out_temp;

    always @(posedge clk) begin
        if (rst == 0)
            cur_state <= IDLE;
        else
            cur_state <= next_state;
    end

    always @(*) begin
        next_state <= cur_state;
        case (cur_state)
            IDLE: if(trans_ack) next_state = SEND_START;
            SEND_START: next_state <= SEND_DATA;
            SEND_DATA: if(count == 7) next_state <= SEND_END;
            SEND_END: if(trans_ack) next_state <= SEND_START;
            default: next_state <= IDLE;
        endcase
    end

    always @(posedge clk) begin
        if(cur_state == SEND_DATA)
            count <= count + 1;
        else if(cur_state == IDLE | cur_state == SEND_END)
            count <= 0;
    end

    always @(posedge clk) begin
        if(cur_state == SEND_START)
            data_out_temp <= data_out;
        else if(cur_state == SEND_DATA)
            data_out_temp[6:0] <= data_out_temp[7:1];
    end

    always @(posedge clk) begin
        if(cur_state == SEND_START)
            txd <= 0;
        else if(cur_state == SEND_DATA)
            txd <= data_out_temp[0];
        else if(cur_state == SEND_END)
            txd <= 1;
        else
            txd <= 1;
    end

endmodule

module uart_receiver(
    input rxd,
    input clk,
    input rst,
    output receive_ack,
    output reg [7:0] data_in
);

    localparam IDLE=0, RECEIVE=1, RECEIVE_END=2;
    reg [3:0] cur_state,next_state;
    reg [4:0] count;

    always @(posedge clk) begin
        if (rst == 0)
            cur_state <= IDLE;
        else
            cur_state <= next_state;
    end

    always @(*) begin
        next_state = cur_state;
        case (cur_state)
            IDLE: if(!rxd) next_state <= RECEIVE;
            RECEIVE: if(count == 7) next_state <= RECEIVE_END;
            RECEIVE_END: next_state <= IDLE;
            default: next_state <= IDLE;
        endcase
    end

    always @(posedge clk) begin
        if(cur_state == RECEIVE)
            count <= count + 1;
        else if(cur_state == IDLE | cur_state == RECEIVE_END)
            count <= 0;
    end

    always @(posedge clk) begin
        if(cur_state == RECEIVE) begin
            data_in [6:0] <= data_in [7:1];
            data_in [7] <= rxd;
        end
    end

    assign receive_ack = (cur_state == RECEIVE_END)?1:0;

endmodule
