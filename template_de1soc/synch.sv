module q7_circuit (outclk , async_sig , vcc , gnd , out_sync_sig);



input outclk , async_sig , vcc , gnd;
output out_sync_sig;

reg FDC_out;
reg FDC_1_out;
reg FDC2_out;
reg FDC3_out;
reg FDC4_out;
reg out_sync_sig;


always_ff @(posedge outclk , posedge gnd) begin //FDC4

    if (gnd) out_sync_sig <= 0 ;
    else out_sync_sig <= FDC3_out;


end 


always_ff @(posedge outclk , posedge gnd) begin //FDC3 

    if (gnd) FDC3_out<=0;
    else FDC3_out<=FDC2_out; 




end 


always_ff @(posedge ~outclk , posedge gnd) begin  //FDC_1

    if (gnd) FDC_1_out<= 0 ;
    else FDC_1_out <= out_sync_sig;


end 



always_ff @(posedge async_sig , posedge FDC_1_out ) begin //FDC2

    if (FDC_1_out) FDC2_out <= 0; 
    else FDC2_out <= vcc;
    
end

endmodule 