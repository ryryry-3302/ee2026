`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME: Yow Keng Yee Samuel
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input clk,                //100MHz
    input [15:0] sw,          //0,1,2,4 and 13,14,15 used
    input btnC, btnL, btnR, btnU, btnD,
    output [4:0] led,         //1234 for subtask ABCD
    output [7:0] JC, 
    output [6:0] seg,         //7 Segment
    output dp,
    output [3:0] an,
    inout PS2Clk, PS2Data     //Mouse
);

    //OLED Driver -----------------------------------
    reg [15:0] oled_colour;
    wire frame_begin;
    wire [12:0] pixel_index;
    wire sending_pixels, sample_pixel;

    wire CLK_6MHz25;
    CustomClock clk6p25m(.CLOCK_IN(clk),
                         .COUNT_STOP(32'd7),
                         .CLOCK_OUT(CLK_6MHz25));
                          
    //---------------------------------------------------


    //Mouse Driver---------------------------------------
    wire [11:0] xpos; wire [11:0] ypos; wire [3:0] zpos;
    wire newevent;
    wire left_click, centre_click, right_click;

    //---------------------------------------------------

    //Paintv Driver--------------------------------------
    wire CLK_25MHz;   
    CustomClock clk25mhz(.CLOCK_IN(clk),
                         .COUNT_STOP(1),
                         .CLOCK_OUT(CLK_25MHz)); 
    wire CLK_12MHz5;
    CustomClock clk12mhz5(.CLOCK_IN(clk),
                          .COUNT_STOP(3),
                          .CLOCK_OUT(CLK_12MHz5)); 
    wire CLK_10KHz; //10kHz                    
    CustomClock clk10khz(.CLOCK_IN(clk),
                         .COUNT_STOP(32'd5000 - 1),
                         .CLOCK_OUT(CLK_10KHz));

    wire [15:0] Num_Detected;
    wire [6:0] Seg_To_Draw;
    wire [15:0] paint_colour_chooser;
    //---------------------------------------------------


    //Insantiate Imported Modules -----------------------

    Oled_Display myoled(
        .clk(CLK_6MHz25), 
        .reset(0),
        .frame_begin(frame_begin),
        .sending_pixels(sending_pixels),
        .sample_pixel(sample_pixel),
        .pixel_index(pixel_index),
        .pixel_data(oled_colour),
        .cs(JC[0]),
        .sdin(JC[1]),
        .sclk(JC[3]),
        .d_cn(JC[4]),
        .resn(JC[5]),
        .vccen(JC[6]),
        .pmoden(JC[7]));

    MouseCtl test_mouse(
        .clk(clk), 
        .rst(0),
        .xpos(xpos),
        .ypos(ypos),
        .zpos(zpos),
        .left(left_click),
        .middle(centre_click),
        .right(right_click),
        .new_event(newevent),
        .value(11'b0000_0000_000), //No clue what this is for
        .setx(0),
        .sety(0),
        .setmax_x(0),
        .setmax_y(0),
        .ps2_clk(PS2Clk),
        .ps2_data(PS2Data));

    paint paint_mod(
        .clk_100M(clk),
        .clk_25M(CLK_25MHz),
        .clk_12p5M(CLK_12MHz5),
        .clk_6p25M(CLK_6MHz25),
        .slow_clk(CLK_10KHz),
        .mouse_l(left_click), .reset(right_click), .enable(1),  
        .mouse_x(xpos), .mouse_y(ypos),
        .pixel_index(pixel_index),
        .led(Num_Detected),       
        .seg(Seg_To_Draw), 
        .colour_chooser(paint_colour_chooser)
    );     

    //---------------------------------------------------

endmodule