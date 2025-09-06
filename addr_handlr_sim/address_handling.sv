module handle_addr(new_kbd_input,clk,rst,start,state,address,finish,edge_trigger);

parameter IDLE = 4'b0_0_00;
parameter SEND_ADDR = 4'b1_0_01;
parameter WAIT = 4'b0_010;
parameter INCREMENT = 4'b0_0_11;

parameter enable = 8'h45;
parameter disable_ = 8'h44;
parameter reset_ = 8'h52;
parameter forward_ = 8'h46;
parameter backwards_ = 8'h42;

//ask if it is okay to have address not as a state encoded bit ?
input [7:0] new_kbd_input;
input clk,rst;
input finish; // we will receive this from the flash fsm
input edge_trigger;

output signed [3:0] state;
output [22:0] address;

output start;
reg start;
reg [7:0] keyboard_input;

reg signed [22:0] address;
reg [3:0] state;
reg reset_button_pressed; //to handle the reset process

always_ff @(posedge clk or posedge rst) begin 

    if (rst) begin 

        state <= IDLE;
        address<=0;

    end 

    else begin 

        case(state) 
        
        IDLE :  begin 
            if (edge_trigger)
            state <= SEND_ADDR;
            else state<=IDLE;
        end 

        SEND_ADDR : begin 
            if (address >= 23'h7FFFF) address<=0;
            else if (address < 0 ) begin
                 address<= 23'h7FFFF;
                 state<=WAIT;
            end
            else begin 
                address<=address;
                state<= WAIT;
            end 
            //start <= 1'b1; // call the flash fsm to start its process

        end 

        WAIT : if(finish) state<= INCREMENT; //if flash fsm is finished increment the address
               else state<=WAIT; //otherwise stay in wait state

        INCREMENT : begin 
            
            
            if (((keyboard_input == enable)||(reset_button_pressed)) && (keyboard_input != disable_ ) && (keyboard_input != backwards_)) begin 
            address <= address + 1;
            state<=IDLE;
            end 

            else if (keyboard_input == disable_) begin 

            address <= address;
            reset_button_pressed<=0;
            state<=IDLE;
            end

            

            else if (keyboard_input == forward_) begin

                address<= address + 1;
                 reset_button_pressed<=0;
                state<=IDLE;

            end 

            else if (keyboard_input == backwards_) begin 
               
                address<= address - 1;
                 reset_button_pressed<=0;
                state<=IDLE;

            end 


            else if (keyboard_input == reset_) begin 

                    address <=0;
                    reset_button_pressed<=1;
                    
                    state<=IDLE;
            end 

            else begin 
                
                state <= INCREMENT;
             
            end 

                end 

        default : state<=IDLE;

         endcase

      
    end

end


assign start  = state[3]; //send signal to flash fsm to start


always_ff @(posedge clk) begin
    if ((new_kbd_input == enable) || (new_kbd_input == disable_) || (new_kbd_input == reset_)|| (new_kbd_input == forward_)|| ( new_kbd_input == backwards_)) begin
        keyboard_input <= new_kbd_input;
    end
    else keyboard_input<=keyboard_input;
end





endmodule

 




