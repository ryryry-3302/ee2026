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
    input task_active, 
    output reg Start = 1'b0);
    
    wire SW_CLK; //10Hz for SW    
    CustomClock clk1hz(.CLOCK_IN(Master_Clock),
                        .COUNT_STOP(32'd5_000_000 - 1),
                        .CLOCK_OUT(SW_CLK));
    
    reg [5:0] timer = 0; //Aim is to hit 40 for 10Hz Clock
                        
    always@(posedge SW_CLK)
    begin
        if(~task_active)
            timer = 0;
        else if(SW_in)
            timer = (timer < 40) ? timer + 1: timer;
        else 
            timer = 0;
    end
    
    always@(posedge Fast_Clock)
    begin
        if(timer >= 40)
            Start = 1'b1;
        else
            Start = 1'b0;
    end    
    
endmodule
