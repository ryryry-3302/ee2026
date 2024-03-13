`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2024 14:17:36
// Design Name: 
// Module Name: CustomClock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CustomClock(
    input CLOCK_IN,
    input [31:0] COUNT_STOP,
    output reg CLOCK_OUT = 0);
    
    reg [31:0] counter = 0;
    
    always@(posedge CLOCK_IN)
    begin
        counter <= ( counter >= COUNT_STOP ) ? 0: counter + 1;
        CLOCK_OUT <= (counter == 0) ? ~CLOCK_OUT : CLOCK_OUT;
    end


endmodule
