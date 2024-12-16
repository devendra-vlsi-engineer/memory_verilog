// TestBench1 Memory1
    module tb1_memory;
        // parameter decleration
        parameter WIDTH = 8;
        parameter DEPTH = 16;
        parameter ADDR_WIDTH = $clog2(DEPTH);

        // port decleration
        reg clk_i, rst_i, valid_i, rd_wr_i;
        reg [ADDR_WIDTH-1:0]addr_i;
        reg [WIDTH-1:0] wdata_i;
        wire ready_o;
        wire [WIDTH-1:0]rdata_o;

        // decleration of the memory
        reg [WIDTH-1:0] mem1 [DEPTH-1:0];
        integer i;

        memory1 dut (clk_i, rst_i, valid_i, ready_o, rd_wr_i, addr_i, rdata_o, wdata_i);

        // generate a clock
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

    initial begin
        clk_i = 0;
        rst_i = 1;
        valid_i = 0;
        rd_wr_i = 0;
        addr_i = 0;
        wdata_i = 0;
        #25;
        rst_i = 0;
        fd_write();
        fd_read();  
    end
    // Writing the Data 
    task fd_write(); begin
        for (i=0; i<DEPTH; i=i+1) begin
            @(posedge clk_i);
            valid_i = 1;
            wait (ready_o == 1);
            rd_wr_i = 1;
            addr_i = i;
            wdata_i = $random; 
        end
        @(posedge clk_i);
        valid_i = 0;
        rd_wr_i = 0;
        addr_i = 0;
        wdata_i = 0;
    end
    endtask

    // Reading the Data
    task fd_read(); begin
        for (i=0; i<DEPTH; i=i+1) begin
            @(posedge clk_i);
            valid_i = 1;
            wait (ready_o == 1);
            rd_wr_i = 0;
            addr_i = i;
        end
        @(posedge clk_i);
        valid_i = 0;
        rd_wr_i = 0;
        addr_i = 0;
    end
    endtask

    initial begin
        #500;
        $finish;
    end

    endmodule
