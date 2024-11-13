module sync_FIFO (
    clk,
    rst,
    w_en,
    r_en,
    data_in,
    data_out,
    count,
    full,
    empty,
);
    parameter FIFO_data_size = 3,       // data width
              FIFO_addr_size = 2;       // depth
    
    input clk,rst;
    input w_en, r_en;
    input[FIFO_data_size-1 : 0]  data_in;
    output reg[FIFO_data_size-1 : 0] data_out;
    output full, empty;
    output reg[FIFO_addr_size : 0]   count; //  empty if count = 0, full if count = depth

    reg [FIFO_addr_size-1 : 0] w_addr, r_addr;
    reg [FIFO_data_size-1:0]mem[{FIFO_addr_size{1'b1}}:0];
    integer i;

    //  memory initialize 
    //  write operate
    always @(posedge clk or negedge rst) begin
        if(!rst)begin
            w_addr <= 0;
            for(i=0; i<{FIFO_addr_size{1'b1}}; i=i+1)
                mem[i] <= {FIFO_data_size{1'b0}};
        end
        else if(w_en&(~full))begin
            mem[w_addr] <= data_in;
            w_addr <= w_addr+1;
        end
    end

    //  read operate
    always @(posedge clk or negedge rst) begin
        if(!rst)begin
            data_out <= {FIFO_data_size{1'b0}};
            r_addr <= 0;
        end
        else if(r_en&(~empty))begin
            data_out <= mem[r_addr];
            r_addr <= r_addr+1;
        end
    end

    //  count
    always @(posedge clk or negedge rst) begin
        if(!rst)
            count <= 0;
        else if(((w_en)&(~full)) & (~((r_en)&(~empty))))
            count <= count + 1;
        else if(((r_en)&(~empty)) & (~((w_en)&(~full))))
            count <= count - 1;
    end

    //  full & empty
    assign empty = (count == 0);
    assign full  = (count == {FIFO_addr_size{1'b1}}+1);

    
endmodule