module flash_memory (edge_trigger,flash_mem_write,rst,address_from_handler,clk,finish,audio_output,state,start,
                        flash_mem_burstcount,
                        flash_mem_read, 
                        flash_mem_address, 
                        flash_mem_writedata, 
                        flash_mem_byteenable,
                        flash_mem_waitrequest, 
                        flash_mem_readdata,
                        flash_mem_readdatavalid);
input clk;
input rst;
input [22:0] address_from_handler; 
input start;

input flash_mem_waitrequest;
input [31:0] flash_mem_readdata; 
input flash_mem_readdatavalid;
input edge_trigger;

output finish;
output flash_mem_write;  //not part of the state encoded bits
output [5:0] flash_mem_burstcount; //not part of the state encoded bits 
output flash_mem_read;
output audio_output;
output [22:0] flash_mem_address;
output [31:0]flash_mem_writedata;  //not part of the state encoded bits 
output [3:0] flash_mem_byteenable; 
output [4:0] state;


assign flash_mem_burstcount = 6'b000001;  //we are not using the burst count capabilities 
assign flash_mem_write = 1'b0; //we are not writing to flash 
assign flash_mem_writedata = 32'b0; //we are not writing to flash




reg [15:0] audio1; //the first audio sample 
reg [15:0] audio2; // the second audio sample 
reg [4:0] state;
reg [15:0] audio_output;
reg [22:0] flash_mem_address;

parameter INIT = 5'b0_0000;
parameter GET_ADDR = 5'b0_0001;
parameter INITIATE_READ = 5'b0_1010;
parameter RESPONSE_READY = 5'b0_0011;
parameter SEND_AUDIO_1 = 5'b0_0100;
//parameter BUFFER_STATE = 5'b0_0101;
parameter SEND_AUDIO_2 = 5'b1_0110;


always_ff @(posedge clk) begin 

    if (rst) begin 

        state <= INIT;

    end 

else begin
    
    case(state) 


            INIT : if(start) state<= GET_ADDR; //if the address handler has called this modules then start 
                    else state<= INIT; //otherwise stay 
            //flash_mem_read = 0;

            GET_ADDR :  begin 
                
                flash_mem_address <= address_from_handler; //get the address from the address handler
                state<= INITIATE_READ;
            end

            INITIATE_READ : //keep the signals constant until waitrequest is deasserted 
                //flash_mem_read <= 1'b1;
                if (~flash_mem_waitrequest)
                state<=RESPONSE_READY;
                else state<=INITIATE_READ;

                
            RESPONSE_READY :
                if (flash_mem_readdatavalid) begin 
                    audio1 <= flash_mem_readdata[15:0];
                    audio2 <= flash_mem_readdata[31:16]; 
                    state<=SEND_AUDIO_1;
                end 
                 //wait until the response is available
                else state<= RESPONSE_READY;

          

            SEND_AUDIO_1 : begin 
                audio_output <= audio1;
                state<= SEND_AUDIO_2;
            end

            SEND_AUDIO_2 : begin
                if (edge_trigger)   begin 
                audio_output <=audio2;
                //finish is 1 here
                state <= GET_ADDR;
                end

            end

            default : state<=INIT;
    endcase
end 
end





assign finish = state[4];
assign flash_mem_read = state[3];




endmodule