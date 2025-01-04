module funFSM(input logic clk, input reset, input logic start, output logic [15:0] led);
    logic slowClk = 0;
    logic [31:0] counter = 0;
    always_ff @(posedge clk) begin
        if (counter == 5_000_000 - 1) begin // 50 million cycles for a full period (2 Hz)
            counter <= 0;
            slowClk <= ~slowClk; // Toggle slowClk
        end else begin
            counter <= counter + 1;
        end
    end

    
    typedef enum logic [2:0] {PAUSE, zero, three, six, nine, twelve, fifteen} state;
    state curr_state;
    state next_state;
    state prev_state;
    
    always_ff @(posedge slowClk or posedge reset) begin
        if(reset) begin
            curr_state <= zero;
            prev_state <= zero;
        end
        else if(!start) begin
            if(curr_state != PAUSE) prev_state <= curr_state;
        end
        else begin
            curr_state <= next_state;
            if(curr_state != PAUSE && !start) prev_state <= curr_state;
        end    
    end
    

    always_comb begin
        case(curr_state) 
            PAUSE: begin
                if(!start) next_state <= PAUSE;
                else next_state <= prev_state;
            end
            zero: begin
                led <= led & 16'h0000;
                led[0] <= 1;
                if(!start) begin
                    next_state <= PAUSE; end
                next_state <= three; end
            three: begin
                led <= led & 16'h0000;
                led[3] <= 1;
                if(!start) begin
                    next_state <= PAUSE; end                                
                next_state <= six; end
            six: begin
                led <= led & 16'h0000;
                led[6] <= 1;
                if(!start) begin
                    next_state <= PAUSE; end                
                next_state <= nine; end
            nine: begin
                led <= led & 16'h0000;
                led[9] <= 1;
                if(!start) begin
                    next_state <= PAUSE; end                
                next_state <= twelve; end
            twelve: begin
                led <= led & 16'h0000;
                led[12] <= 1;
                if(!start) begin
                    next_state <= PAUSE; end                
                next_state <= fifteen; end      
            fifteen: begin
                led <= led & 16'h0000;
                led[15] <= 1;
                if(!start) begin
                    next_state <= PAUSE; end                
                next_state <= zero; end           
        endcase
    end
    

endmodule
