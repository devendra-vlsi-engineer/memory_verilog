// Design memory
    module memory1(clk_i, rst_i, valid_i, ready_o, rd_wr_i, addr_i, rdata_o, wdata_i);
        // parameter decleration
        parameter WIDTH = 8;
        parameter DEPTH = 16;
        parameter ADDR_WIDTH = $clog2(DEPTH);

        // port decleration
        input clk_i, rst_i, valid_i, rd_wr_i;
        input [ADDR_WIDTH-1:0]addr_i;
        input [WIDTH-1:0] wdata_i;
        output reg ready_o;
        output reg [WIDTH-1:0]rdata_o;

        // decleration of the memory
        reg [WIDTH-1:0] mem1 [DEPTH-1:0];
        integer i;

    always @(posedge clk_i ) begin
        if (rst_i) begin
            rdata_o = 0;
            ready_o = 0;
            for (i=0; i<DEPTH; i=i+1) mem1[i] = 0;
        end
        else begin
            if (valid_i) begin
                ready_o = 1;
                if(rd_wr_i) mem1[addr_i] = wdata_i;
                else rdata_o = mem1[addr_i];
            end
            else ready_o = 0;
        end
    end
    endmodule
