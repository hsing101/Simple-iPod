module fsm_manager(
    input clk,
    input rst,
    
    // Flash memory interface (passed through to external Avalon-MM)
    output        flash_mem_read,
    output        flash_mem_write,
    output [22:0] flash_mem_address,
    output [3:0]  flash_mem_byteenable,
    output [31:0] flash_mem_writedata,
    output [5:0]  flash_mem_burstcount,

    input         flash_mem_waitrequest,
    input  [31:0] flash_mem_readdata,
    input         flash_mem_readdatavalid,

    // Output audio data
    output [7:0] audio_output
);

// Internal signals between modules
wire [22:0] address_from_handler;
wire [4:0]  flash_state;
wire [3:0]  addr_state;
wire        start;
wire        finish;

// Handle Address FSM
handle_addr addr_fsm (
    .clk(clk),
    .rst(rst),
    .wait_request(flash_mem_waitrequest),
    .start(start),
    .finish(finish),
    .address(address_from_handler),
    .state(addr_state)
);

// Flash Memory FSM
flash_memory flash_fsm (
    .clk(clk),
    .rst(rst),
    .start(start),
    .address_from_handler(address_from_handler),
    .finish(finish),
    .flash_mem_read(flash_mem_read),
    .flash_mem_write(flash_mem_write),
    .flash_mem_address(flash_mem_address),
    .flash_mem_byteenable(flash_mem_byteenable),
    .flash_mem_burstcount(flash_mem_burstcount),
    .flash_mem_writedata(flash_mem_writedata),
    .flash_mem_waitrequest(flash_mem_waitrequest),
    .flash_mem_readdata(flash_mem_readdata),
    .flash_mem_readdatavalid(flash_mem_readdatavalid),
    .audio_output(audio_output),
    .state(flash_state)
);

endmodule
