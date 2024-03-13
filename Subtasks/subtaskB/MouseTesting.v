`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2024 14:23:29
// Design Name: 
// Module Name: MouseTesting
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


module MouseTesting(
    input clk,
    input SW, //SW0
    input btnC, btnL, btnR,
    output [7:0] JC,
    
    inout PS2Clk,
    inout PS2Data,
    output [15:0] led,
    
    output [6:0] seg,
    output [3:0] an);
    
    wire [11:0] xpos;
    wire [11:0] ypos;
    wire [3:0] zpos;
    wire newevent;
    
    wire [2:0] mouse_buts;
    MouseCtl test_mouse(
    .clk(clk), 
    .rst(0),
    .xpos(xpos),
    .ypos(ypos),
    .zpos(zpos),
    .left(mouse_buts[2]),
    .middle(mouse_buts[1]),
    .right(mouse_buts[0]),
    .new_event(newevent),
    .value(11'b0000_0000_000),
    .setx(0),
    .sety(0),
    .setmax_x(0),
    .setmax_y(0),
    .ps2_clk(PS2Clk),
    .ps2_data(PS2Data));
    
    wire SPI_CLK;
    CustomClock clk6p25m(.CLOCK_IN(clk),
                     .COUNT_STOP(32'd7),
                     .CLOCK_OUT(SPI_CLK));
     wire FAST_CLOCK; //10kHz                    
     CustomClock clk10khz(.CLOCK_IN(clk),
                          .COUNT_STOP(32'd5000 - 1),
                          .CLOCK_OUT(FAST_CLOCK)); 
    wire CLOCK_25MHZ;
    CustomClock clk25mhz(.CLOCK_IN(clk),
                      .COUNT_STOP(1),
                      .CLOCK_OUT(CLOCK_25MHZ)); 
    wire CLOCK_12MHZ5;
    CustomClock clk12mhz5(.CLOCK_IN(clk),
                      .COUNT_STOP(3),
                      .CLOCK_OUT(CLOCK_12MHZ5));  
                      
                      
    wire [15:0] oled_data;
    wire frame_begin;
    wire [12:0] pixel_index;
    wire sending_pixels, sample_pixel;
              
    Oled_Display myoled(
                      .clk(SPI_CLK), 
                      .reset(0),
                      .frame_begin(frame_begin),
                      .sending_pixels(sending_pixels),
                      .sample_pixel(sample_pixel),
                      .pixel_index(pixel_index),
                      .pixel_data(oled_data),
                      .cs(JC[0]),
                      .sdin(JC[1]),
                      .sclk(JC[3]),
                      .d_cn(JC[4]),
                      .resn(JC[5]),
                      .vccen(JC[6]),
                      .pmoden(JC[7]));    
                                           
    assign an = 4'b1010;                      

    paint paint_mod(
        .clk_100M(clk),
        .clk_25M(CLOCK_25MHZ),
        .clk_12p5M(CLOCK_12MHZ5),
        .clk_6p25M(SPI_CLK),
        .slow_clk(FAST_CLOCK),
        .mouse_l(mouse_buts[2]), .reset(mouse_buts[0]), .enable(1),  
        .mouse_x(xpos), .mouse_y(ypos),
        .pixel_index(pixel_index),
        .led(led),       
        .seg(seg), 
        .colour_chooser(oled_data)
    );   
    

    
endmodule
