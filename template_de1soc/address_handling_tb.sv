module handle_addr_tb;

reg wait_request;
reg rst;
reg clk;
wire fetch_address;
wire [3:0] state;
wire [22:0] address;


initial begin 
    clk=0;
    #10;
    forever begin 
        clk=1;#10;
        clk=0;#10;
    end 
end 

initial begin 
    wait_request
    rst =1;
    #20;

    //should be in state idle 

    rst =0 ;
    #20; //should be in state FETCH_ADDR fetch_addr = 1;

    edge_trigger = 1;
    #5;
    edge_trigger =0;



    #30;

    finish = 1;
    #10;
    finish = 0;
    








end 



handle_addr DUT (.new_kbd_input(new_kbd_input),.clk(clk),.rst(rst),.start(start),.state(state),.address(address),.finish(finish),.edge_trigger(edge_trigger));

endmodule