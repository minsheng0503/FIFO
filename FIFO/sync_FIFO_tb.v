`timescale 1ns/1ns
    module FIFO_sync_top;

    reg clk, rst, w_en, r_en;
    reg[2:0] data_in;

    wire[2:0] count;
    wire[2:0] data_out;

    reg[2:0]i;

    initial begin
        clk = 0;
        rst = 1;
        data_in = 3'b000;
        w_en = 0;
        r_en = 0;

        #25
        rst = 0;
        #50
        rst = 1;
        #25
        w_en = 1;
        #100
        w_en = 0;
        r_en = 0;
        #100
        w_en = 1;
        #400
        r_en = 1;
    end

    initial begin
        for(i=0; i<=50; i=i+1)
            #100 data_in = i;
    end

    always #50 clk = ~clk;

sync_FIFO #(.FIFO_data_size(3), .FIFO_addr_size(2)) ut(
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .data_out(data_out),
    .w_en(w_en),
    .r_en(r_en),
    .count(count),
    .full(full),
    .empty(empty)
);
    endmodule