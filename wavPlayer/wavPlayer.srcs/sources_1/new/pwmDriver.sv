module pwmDriver(input logic clk, input logic filterOn, input logic [4:0] volume, output logic SPKL, output logic SPKR, output logic [7:0] dout);
    logic [20:0] index = 0;
    logic [7:0] out;
    logic [12:0] sout; //scaled output (2^8 (output) * 2^5 (volume) = 2^13 (max duty cycle interval value))
    logic [12:0] pwmCounter = 0; // 13-bit counter for PWM generation (represents one full period (12207 Hz artifact frequency (100MHz / 2^13 Hz)))
    //because the pwm frequency is around 12.2 kHz (which is audible to humans) we hear this sound in the background 
    logic [31:0] slowCounter = 0; //should be used to count around 48 kHz

    // Instance of the waveform generation module
    //wavFile wavInstance(.index(index), .out(out));
    blk_mem_gen_0 wavInstance (
        .clka(clk),          // Clock
        .addra(index),       // Address
        .douta(out)          // Data output
    );
    
    assign dout = out; //for hex display
    
    logic [12:0] filteredOut;
    logic readyO, validO;
    
    logic [15:0] filteredOut_internal; // Full FIR output width
    fir_compiler_0 lpf (
        .aclk(clk),                              // Input clock
        .s_axis_data_tvalid(1'b1),               // FIR input valid
        .s_axis_data_tready(readyO),             // FIR input ready
        .s_axis_data_tdata({3'b0, sout}),       // FIR input data
        .m_axis_data_tvalid(validO),             // FIR output valid
        .m_axis_data_tdata(filteredOut_internal) // FIR output data
    );
    //filters below 4kHz...
    
    assign filteredOut = filteredOut_internal[15:3];
    
    always_ff @(posedge clk) begin
        slowCounter = slowCounter + 1;
        if(slowCounter == 2083) begin //(100MHz / sampling frequency)
            index = index + 1; //no need to worry about modulus since the wavFile will handle this exception
            slowCounter = 0;
        end
        sout = ((volume == 0) ? 8'd0 : (out * volume)); //if volume is 0, set sout to 0. else set sout to out*volume (righ shift by 5 to keep in 8 bit range)
                
        pwmCounter = pwmCounter + 1;
        if (validO && filterOn) begin
            SPKL <= (pwmCounter < filteredOut);
            SPKR <= (pwmCounter < filteredOut);
        end
        else begin
            SPKL <= (pwmCounter < sout);
            SPKR <= (pwmCounter < sout);
        end
    end
endmodule
