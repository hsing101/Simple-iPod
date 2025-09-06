`timescale 1ns / 1ps
module clock_divider (speed_reset_event,speed_down_event,speed_up_event,clk,reset,outclk);

input clk,reset;
output outclk;
reg outclk;

reg [31:0] counter;
reg [31:0] b = 32'd1216; //initial value of the clock

input speed_up_event;
input speed_down_event;
input speed_reset_event;

always_ff @(posedge clk) begin


    if (reset) begin 
            outclk<=0;
            counter<=0;
	end

    else if (counter >= b ) begin
            outclk<= ~outclk;
            counter <= 0;
	end

    else counter<= counter+ 1'b1;
    
end


always_ff @(posedge clk) begin   //changing the speed of the song based on inputs from KEY[0],KEY[1],KEY[2]

    if ( speed_up_event) b <= b - 32'd100;

    else if (speed_down_event) b<= b+32'd100;

    else if (speed_reset_event) b<= 32'd1216;

    else b<= b;



end 

endmodule