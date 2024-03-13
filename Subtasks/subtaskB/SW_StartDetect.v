`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2024 22:11:04
// Design Name: 
// Module Name: SW_StartDetect
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


module SW_StartDetect(
    input SW_in, 
    input Master_Clock,
    input Fast_Clock, 
    output reg Start = 1'b0);
    
    wire SW_CLK; //1Hz for SW    
    CustomClock clk1hz(.CLOCK_IN(Master_Clock),
                        .COUNT_STOP(32'd50_000_000 - 1),
                        .CLOCK_OUT(SW_CLK));
    
    reg [2:0] timer = 3'b000;
                        
    always@(posedge SW_CLK)
    begin
        if(SW_in)
            timer = (timer < 4) ? timer + 1: timer ;
        else 
            timer = 0;
    end
    
    always@(posedge Fast_Clock)
    begin
        if(timer >= 3'b100)
            Start = 1'b1;
    end    
    
endmodule
