module audio_controller_tb;

    reg clk, rst;
    wire flash_mem_read, flash_mem_write;
    wire [22:0] flash_mem_address;
    wire [3:0] flash_mem_byteenable;
    wire [31:0] flash_mem_writedata;
    wire [5:0] flash_mem_burstcount;
    wire [7:0] audio_output;

    reg flash_mem_waitrequest;
    reg [31:0] flash_mem_readdata;
    reg flash_mem_readdatavalid;

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Stimulus
    initial begin
        rst = 1;
        flash_mem_waitrequest = 0;
        flash_mem_readdata = 32'h00_00_AB_CD; // audio1 = 0xCD, audio2 = 0xAB
        flash_mem_readdatavalid = 0;
        #30 rst = 0;

        // Simulate valid read response
        #100 flash_mem_readdatavalid = 1;
        #20  flash_mem_readdatavalid = 0;

        // Wait and check new samples
        #200;

        // Simulate another read response
        flash_mem_readdata = 32'h00_00_12_34;
        flash_mem_readdatavalid = 1;
        #20 flash_mem_readdatavalid = 0;

        #200 $stop;
    end

    // DUT
    audio_controller DUT (
        .clk(clk),
        .rst(rst),
        .flash_mem_read(flash_mem_read),
        .flash_mem_write(flash_mem_write),
        .flash_mem_address(flash_mem_address),
        .flash_mem_byteenable(flash_mem_byteenable),
        .flash_mem_writedata(flash_mem_writedata),
        .flash_mem_burstcount(flash_mem_burstcount),
        .flash_mem_waitrequest(flash_mem_waitrequest),
        .flash_mem_readdata(flash_mem_readdata),
        .flash_mem_readdatavalid(flash_mem_readdatavalid),
        .audio_output(audio_output)
    );

endmodule
