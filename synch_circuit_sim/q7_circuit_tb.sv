
`timescale 1ns/1ps

module q7_circuit_tb;

  // Inputs
  logic outclk;
  logic async_sig;
  logic vcc;
  logic gnd;

  // Output
  logic out_sync_sig;

  // Instantiate the Unit Under Test (UUT)
  q7_circuit uut (
    .outclk(outclk),
    .async_sig(async_sig),
    .vcc(vcc),
    .gnd(gnd),
    .out_sync_sig(out_sync_sig)
  );

  // Clock generation (100 MHz => period = 10ns)
  initial begin
    outclk = 0;
    forever #10 outclk = ~outclk;  // Toggles every 5ns
  end

  // VCC toggles every 40ns (25 MHz)
  initial begin
    vcc = 1;
    
  end

  // GND toggles every 100ns (10 MHz)
  initial begin
    gnd = 0;
  
  end

  // Async signal: irregular toggling pattern
  initial begin
    #500;
    async_sig = 1;
    forever #22727.2
     async_sig = ~async_sig;
  end

endmodule
