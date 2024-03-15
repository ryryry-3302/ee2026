`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2024 22:25:19
// Design Name: 
// Module Name: PB_PressDetect
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


module PB_PressDetect(
    input Clock_1kHz, //Counting
    input Clock_10kHz, //Detection
    input btn,
    output reg btn_press = 0
    );
    
    //Timers
    reg [7:0]  debounce = 8'd0;
    
    //State
    /* 00 -> Unpressed
       01 -> Press Timing
       10 -> Debounce delay  */
       
    reg [1:0] state = 2'b00;
    
    //Timers based on state
    always @(posedge Clock_1kHz)
    begin
        if(state == 2'b01)
            debounce = 0;
        else if(state == 2'b10)
            debounce = debounce + 1;
        else//state = 0;
            debounce = 0;
    end
    
    always @(posedge Clock_10kHz)
    begin
        if(state==2'b00 && btn==1)
            state <= 2'b01;
        
        if(state==2'b01 && btn==0)
            begin
            btn_press <= 1;
            state <= 2'b10;
            end
        
        if(state==2'b10 && debounce>=200)
            begin
            state=2'b00;
            btn_press <= 0;
            end    
    end         
    
    
endmodule
