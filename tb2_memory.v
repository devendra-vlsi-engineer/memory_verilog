// TestBench2 - variable no. of reads and writes, Back and Front Door Access
    module tb2_memory;
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
        reg [100:1] testcase;

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
        $value$plusargs("testcase=%0s", testcase);
        case (testcase)
           "fd_wr_fd_rd" : begin
                fd_write(0,DEPTH);
                fd_read(0,DEPTH);
           end
           "bd_wr_bd_rd" : begin
                bd_write();
                bd_read();
           end
           "fd_wr_bd_rd" : begin
                fd_write(0,DEPTH);
                bd_read();
           end
           "bd_wr_fd_rd" : begin
                bd_write();
                fd_read(0,DEPTH);
           end
        endcase
    end
    
    // Writing the Data
        // 1. Using the Backdoor method
        task bd_write(); begin
            $readmemh("bd_data_write.h", dut.mem1);
        end
        endtask


        // 2.Using the front door method
        task fd_write(input reg [ADDR_WIDTH-1:0] start_loc, input [ADDR_WIDTH:0] count); begin
            for (i=start_loc; i<start_loc+count; i=i+1) begin
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
        // 1.Using the Backdoor method
        task bd_read(); begin
            $writememh("bd_read_data.h", dut.mem1);
        end
        endtask

        // 2.Using the Front door method
        task fd_read(input reg [ADDR_WIDTH-1:0] start_loc, input [ADDR_WIDTH:0] count); begin
            for (i=start_loc; i<start_loc+count; i=i+1) begin
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
