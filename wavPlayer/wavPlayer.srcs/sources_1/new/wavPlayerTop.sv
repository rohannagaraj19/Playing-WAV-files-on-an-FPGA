module wavPlayerTop(
    input clk_100MHz,
    output SPKL,
    output SPKR,
    input [15:0] sw_i,
    input reset_rtl_0,
    input UART_TXD,
    output UART_RXD,
    input leButton,
    input buttonThree,
    output [3:0] hex_gridA,
    output [7:0] hex_segA,
    output [3:0] hex_gridB,
    output [7:0] hex_segB,
    output [15:0] LED
    );
  
  logic [4:0] volume;
  logic [15:0] frequency;
  mb_block mb_block_i
   (.clk_100MHz(clk_100MHz),
    .gpio_rtl_1_tri_i(sw_i),
    .gpio_rtl_2_tri_i(leButton),
    .reset_rtl_0(~reset_rtl_0),
    .uart_rtl_0_rxd(UART_TXD),
    .uart_rtl_0_txd(UART_RXD));
      
   logic [7:0] dout;
   logic [3:0] inA[4];
   assign inA[0] = dout[7:4];
   assign inA[1] = dout[3:0];
   assign inA[2] = {3'b0, clk_100MHz};
   assign inA[3] = {3'b0, UART_RXD};
   
   hex_driver hex_driverA (
    .clk(clk_100MHz),
    .reset(reset_rtl_0),

    .in(inA),

    .hex_seg(hex_segA),
    .hex_grid(hex_gridA)
    );
    

   logic [3:0] inB[4];
   assign inB[0] = {3'b0, SPKL};
   assign inB[1] = {3'b0, SPKR};
   assign inB[2] = {3'b0, leButton};
   assign inB[3] ={1'b0, volume[2:0]} ;
     
   hex_driver hex_driverB (
    .clk(clk_100MHz),
    .reset(reset_rtl_0),

    .in(inB),

    .hex_seg(hex_segB),
    .hex_grid(hex_gridB)
    );
    
    assign volume = sw_i[4:0];
    pwmDriver pwmDriver(
     .clk(clk_100MHz),
     .volume(volume),
     .filterOn(sw_i[15]),
     .SPKL,
     .SPKR,
     .dout
    );   

endmodule
