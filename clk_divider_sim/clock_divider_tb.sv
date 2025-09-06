`timescale 1ns / 1ps
module clock_divider_tb;

    reg clk = 0;
    reg reset = 0;
    reg speed_up_event = 0;
    reg speed_down_event = 0;
    reg speed_reset_event = 0;
    wire outclk;

    // Clock generation
    always #18.5 clk = ~clk;

    // Stimulus
    initial begin
        reset = 1;
        #100;           // Assert reset for a few clock cycles
        reset = 0;

        // Observe normal outclk for some time
        #5000;

        // Speed up (simulate button press)
        //speed_up_event = 1; #100; speed_up_event = 0;
        //#10000;  // Wait to observe faster outclk



        /*need to test these one at a time to give outclk enough time to adjust;

        // Speed down
        speed_down_event = 1; #100; speed_down_event = 0;
        #10000;

        // Reset speed
        speed_reset_event = 1; #100; speed_reset_event = 0;
        #10000;

       */



    end


    clock_divider DUT (
        .speed_reset_event(speed_reset_event),
        .speed_down_event(speed_down_event),
        .speed_up_event(speed_up_event),
        .clk(clk),
        .reset(reset),
        .outclk(outclk)
    );

endmodule
