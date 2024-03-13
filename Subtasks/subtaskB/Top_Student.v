`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input clk,
    input SW, //SW0
    input btnC, btnL, btnR,
    output [7:0] JC);
    
    
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
        .SW_in(SW), 
        .Master_Clock(clk),
        .Fast_Clock(FAST_CLOCK), 
        .Start(start_task));    
    //---------------------------------------------------    
        
        
    //OLED Driver -----------------------------------
    wire SPI_CLK;
    reg [15:0] oled_data = 16'h0000;
    wire frame_begin;
    wire [12:0] pixel_index;
    wire sending_pixels, sample_pixel;
    CustomClock clk6p25m(.CLOCK_IN(clk),
                         .COUNT_STOP(32'd7),
                         .CLOCK_OUT(SPI_CLK));
                          
    //---------------------------------------------------
    

    // OLED SQAURE DRAWING -------------------------------------/

    //000, 001, 010, 011, 
    //White, Red, Green, Blue
    reg [2:0] Square_state = 3'b000;

    //Changing square colour
    always@(posedge btnC_press)
    begin
        Square_state = (Square_state == 3'b011) ? 3'b000 : Square_state + 1;
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
                        
                        
    //PB Filtering, C, L, R -----------------------
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
    
    
    //Border Drawing --------------------------------------------------
    
    wire draw_border;
    wire [15:0] colour_border;
    Draw_Border my_border(.pixel_index(pixel_index),
                          .btnL_filtered(btnL_press),
                          .btnR_filtered(btnR_press),
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
            oled_data = colour_border;
        else if(start_task == 1)
          begin
              if(draw_mul_squares)
                oled_data = colour_square;
              else
                oled_data = COLOUR_BLACK;
          end
        else
            oled_data = COLOUR_BLACK;
    end    
    // ------------------------------------------------------/

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

endmodule