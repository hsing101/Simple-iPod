 module flash_memory_tb;


reg clk;
reg rst;
reg [22:0] address_from_handler; 
reg start;

reg flash_mem_waitrequest;
reg [31:0] flash_mem_readdata; 
reg flash_mem_readdatavalid;
reg edge_trigger;

wire finish;
wire flash_mem_write;  //not part of the state encoded bits
wire [5:0] flash_mem_burstcount; //not part of the state encoded bits 
wire flash_mem_read;
wire [8:0] audio_output;
wire [22:0] flash_mem_address;

wire [4:0] state;

 
initial begin 
    clk=0;
    #10;
    forever begin 
        clk=1;
        #10;
        clk=0;
        #10;
    end 
end 


initial begin 

start=0;
flash_mem_readdatavalid=0;
flash_mem_waitrequest=0;




rst=1;
#30;

rst=0;

#100; //wait for the start signal 

address_from_handler = 22'd1001; //some arbitary address provided by the address handler 
start=1;

#45;


#100; 

flash_mem_waitrequest = 1;
#100;
flash_mem_waitrequest =0;
#5;

flash_mem_readdata = 32'h007B2;
#5;
flash_mem_readdatavalid = 1;







end 
 
 
 
 
 
 
 
 
 
 
 
 
 
flash_memory DUT (.flash_mem_write(flash_mem_write),.rst(rst),.address_from_handler(address_from_handler),.clk(clk),.finish(finish),
                        .audio_output(audio_output),
                        .state(state),
                        .start(start),
                        .flash_mem_read(flash_mem_read), 
                        .flash_mem_address(flash_mem_address),  
                        .flash_mem_waitrequest(flash_mem_waitrequest), 
                        .flash_mem_readdata(flash_mem_readdata),
                        .flash_mem_readdatavalid(flash_mem_readdatavalid));


endmodule