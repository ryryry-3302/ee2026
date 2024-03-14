`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2024 20:31:28
// Design Name: 
// Module Name: SubTaskB
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


module SubTaskB(
    input clk,
    input SW0, task_active,
    input btnC, btnL, btnR,
    input [12:0] pixel_index,
    output reg [15:0] oled_colour
    );
    

    //Colours ----------------------------------------------
    reg [15:0] COLOUR_RED   = 16'b11111_000000_00000; 
    reg [15:0] COLOUR_GREEN = 16'b00000_111111_00000;
    reg [15:0] COLOUR_BLUE  = 16'b00000_000000_11111;
    reg [15:0] COLOUR_BLACK = 16'b00000_000000_00000;
    reg [15:0] COLOUR_WHITE = 16'hFFFF;    
    //---------------------------------------------------    
    
     //Generic Fast Clock > for SWs -------------------------
     wire FAST_CLOCK; //10kHz                    
     CustomClock clk10khz(.CLOCK_IN(clk),
                          .COUNT_STOP(32'd5000 - 1),
                          .CLOCK_OUT(FAST_CLOCK)); 
    //---------------------------------------------------
 
     //SW 4s Detect -----------------------------------
    wire start_task;
    SW_StartDetect sw_start(
        .SW_in(SW0), 
        .Master_Clock(clk),
        .Fast_Clock(FAST_CLOCK),
        .task_active(task_active), 
        .Start(start_task));    
    //---------------------------------------------------   
 
     //PB Filtering, C, L, R -----------------------
     //Should top level filtering be done instead of within the subtask?
    //Posedge for button pres
    
    wire PB_CLOCK; //For debounce counters
    CustomClock clk1kHz(.CLOCK_IN(clk),
                        .COUNT_STOP(32'd50_000-1),
                        .CLOCK_OUT(PB_CLOCK));
                        
    wire btnC_press;                        
    PB_PressDetect pb_press_u(.Clock_1kHz(PB_CLOCK),
                              .Clock_10kHz(FAST_CLOCK),
                              .btn(btnC),
                              .btn_press(btnC_press));
 
    wire btnL_press;                        
    PB_PressDetect pb_press_l(.Clock_1kHz(PB_CLOCK),
                              .Clock_10kHz(FAST_CLOCK),
                              .btn(btnL),
                              .btn_press(btnL_press));    
    wire btnR_press;                        
    PB_PressDetect pb_press_r(.Clock_1kHz(PB_CLOCK),
                              .Clock_10kHz(FAST_CLOCK),
                              .btn(btnR),
                              .btn_press(btnR_press));    
                                   
    //--------------------------------------------------- 
          
    
    // OLED SQAURE DRAWING -------------------------------------/

    //000, 001, 010, 011, 
    //White, Red, Green, Blue
    //Changing square colour
    reg [2:0] Square_state = 3'b000;
    always@(posedge (btnC_press | ~task_active) )
    begin
        if(btnC_press)
            Square_state = (Square_state >= 3'b011) ? 3'b000 : Square_state + 1;
        else
            Square_state = 3'b000;
    end    
    
    wire draw_mul_squares;
    wire [15:0] colour_square;                    
    Draw_MulSquares start_squares(
                            .start(start_task),
                            .pixel_index(pixel_index),
                            .state(Square_state),
                            .draw(draw_mul_squares),
                            .colour(colour_square));

    //-------------------------------------------------------   

    //Border Drawing --------------------------------------------------
    
    wire draw_border;
    wire [15:0] colour_border;
    Draw_Border my_border(.pixel_index(pixel_index),
                          .btnL_filtered(btnL_press),
                          .btnR_filtered(btnR_press),
                          .task_active(task_active),
                          .draw(draw_border),
                          .colour(colour_border));
    
    //------------------------------------------------------------------

    // Main OLED Drawing Loop ------------------------------------------/
    wire OLED_DRAW_CLK; //25Hz for updating the OLED Screen
    CustomClock clk25hz(.CLOCK_IN(clk),
                        .COUNT_STOP(32'd1),
                        .CLOCK_OUT(OLED_DRAW_CLK));   
                                                    
    always@(posedge OLED_DRAW_CLK)
    begin 
        if(draw_border)
            oled_colour = colour_border;
        else if(start_task == 1)
          begin
              if(draw_mul_squares)
                oled_colour = colour_square;
              else
                oled_colour = COLOUR_BLACK;
          end
        else
            oled_colour = COLOUR_BLACK;
        
        if (!task_active)
            oled_colour = COLOUR_BLACK;       
            
    end    
    // ------------------------------------------------------/         

           
endmodule
