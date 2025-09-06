module handle_addr_tb;

reg [7:0] new_kbd_input;
reg clk,rst;
reg finish; // we will receive this from the flash fsm
reg edge_trigger;

wire signed [3:0] state;
wire [22:0] address;

wire 
;
























initial begin 
    clk=0;
    #10;
    forever begin 
        clk=1;#10;
        clk=0;#10;
    end 
end 

initial begin 
    finish=0;
    rst =1;
    edge_trigger=0;
    new_kbd_input =  8'h45;
    #20;

    //should be in state idle 

    rst =0 ;
    #20; //should be in state FETCH_ADDR fetch_addr = 1;

    edge_trigger = 1;
    #35;
    edge_trigger =0;



    #30;

    finish = 1;
    #35;
    finish = 0;
    








end 



handle_addr DUT (.new_kbd_input(new_kbd_input),.clk(clk),.rst(rst),.start(start),.state(state),.address(address),.finish(finish),.edge_trigger(edge_trigger));

endmodule