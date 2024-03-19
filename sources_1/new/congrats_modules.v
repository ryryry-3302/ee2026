`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2024 07:28:30
// Design Name: 
// Module Name: congrats_modules
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


module congrats_modules(input clk, input celebrationState, input [12:0] pixel_index, output reg [15:0] oled_data);

//// <COLOURS> //////////////////////////////////////////////////
    reg [15:0] COLOUR_RED   = 16'b11111_000000_00000; 
    reg [15:0] COLOUR_GREEN = 16'b00000_111111_00000;
    reg [15:0] COLOUR_BLUE = 16'b00000_000000_11111;

    reg [15:0] COLOUR_HOTPINK   = 16'b11111_011010_10110; 
    reg [15:0] COLOUR_BLACK = 16'b00000_000000_00000;
    reg [15:0] COLOUR_DEBUG = 16'b11111_111111_11111;
    parameter font_width = 4; 
    
    parameter char_yaxis_translation = 16; //To centre wrt height
    parameter first_y_char_xaxis_translation = 8; //To centre wrt height
    parameter A_char_xaxis_translation = 36; //To centre wrt width
    parameter second_y_char_xaxis_translation = 68; //To centre wrt width

//// </COLOURS> //////////////////////////////////////////////////

//// <COORDINATE CONVERTOR> //////////////////////////////////////    
    wire [6:0] x;
    wire [5:0] y;
    indexToXY my_coord_convertor (pixel_index, x, y);
//// </COORDINATE CONVERTOR> /////////////////////////////////////

//// <CLOCKS> ////////////////////////////////////////////////////    
    wire clk_20hz;
    reg [31:0] COUNT = 0;
    reg [31:0] CURR_STEP = 0;
    parameter TOTAL_MOVEMENT_STEP = 164;
    parameter count_convert_20hz = 312500;
//    CustomClock my_clk_20hz (clk, 2499999, clk_20hz);
    
    wire clk6p25m;
    CustomClock clock_6_25MHz (clk, 7, clk6p25m); 
//// </CLOCKS> ///////////////////////////////////////////////////    

//// <BOUNDS> ////////////////////////////////////////////////////    
    reg [6:0] left_col_bound = 0;
    reg [6:0] right_col_bound = 0;
    reg [5:0] top_col_bound = 0;
    reg [5:0] bottom_col_bound = 0;
//// </BOUNDS> ///////////////////////////////////////////////////

//// <STIMULI> ///////////////////////////////////////////////////
    reg is_initialised = 0;
    reg start_movement = 0;
//// </STIMULI> //////////////////////////////////////////////////


    always @ (posedge clk6p25m) begin
        if (celebrationState == 0) begin
            oled_data = COLOUR_HOTPINK;
        end
        
        else begin
            // <A symbol in GREEN> /////////////////////////////////////////////////////////
            if ((x >= 2 * font_width + A_char_xaxis_translation) && (x < (3 + 1) * font_width + A_char_xaxis_translation) && (y >= 0 + char_yaxis_translation) && (y < (1 + 1) * font_width + char_yaxis_translation)) begin
                oled_data = COLOUR_GREEN;
            end
            
            else if ((x >= 1 * font_width + A_char_xaxis_translation) && (x < (1 + 1) * font_width + A_char_xaxis_translation) && (y >= 2 * font_width + char_yaxis_translation) && (y < (4 + 1) * font_width + char_yaxis_translation)) begin
                oled_data = COLOUR_GREEN;
            end
            
            else if ((x >= 4 * font_width + A_char_xaxis_translation) && (x < (4 + 1) * font_width + A_char_xaxis_translation) && (y >= 2 * font_width + char_yaxis_translation) && (y < (4 + 1) * font_width + char_yaxis_translation)) begin
                oled_data = COLOUR_GREEN;
            end
            
            else if ((x >= 0 + A_char_xaxis_translation) && (x < (5 + 1) * font_width + A_char_xaxis_translation) && (y >= 5 * font_width + char_yaxis_translation) && (y < (5 + 1) * font_width + char_yaxis_translation)) begin
                oled_data = COLOUR_GREEN;
            end        
            
            else if ((x >= 0 + A_char_xaxis_translation) && (x < (0 + 1) * font_width + A_char_xaxis_translation) && (y >= 6 * font_width + char_yaxis_translation) && (y < (7 + 1) * font_width + char_yaxis_translation)) begin
                oled_data = COLOUR_GREEN;
            end 
            
            else if ((x >= 5 * font_width + A_char_xaxis_translation) && (x < (5 + 1) * font_width + A_char_xaxis_translation) && (y >= 6 * font_width + char_yaxis_translation) && (y < (7 + 1) * font_width + char_yaxis_translation)) begin
                oled_data = COLOUR_GREEN;
            end

            //// <1ST Y symbol in RED> /////////////////////////////////////////////////////////
            else if ((x >= 0 * font_width + first_y_char_xaxis_translation) && (x < (0 + 1) * font_width + first_y_char_xaxis_translation) && (y >= 0 + char_yaxis_translation) && (y < (1 + 1) * font_width + char_yaxis_translation)) begin
                oled_data = COLOUR_RED;
            end
            
            else if ((x >= 4 * font_width + first_y_char_xaxis_translation) && (x < (4 + 1) * font_width + first_y_char_xaxis_translation) && (y >= 0 + char_yaxis_translation) && (y < (1 + 1) * font_width + char_yaxis_translation)) begin
                oled_data = COLOUR_RED;
            end
            ////
            else if ((x >= 1 * font_width + first_y_char_xaxis_translation) && (x < (1 + 1) * font_width + first_y_char_xaxis_translation) && (y >= 2 * font_width + char_yaxis_translation) && (y < (3 + 1) * font_width + char_yaxis_translation)) begin
                oled_data = COLOUR_RED;
            end

            else if ((x >= 3 * font_width + first_y_char_xaxis_translation) && (x < (3 + 1) * font_width + first_y_char_xaxis_translation) && (y >= 2 * font_width + char_yaxis_translation) && (y < (3 + 1) * font_width + char_yaxis_translation)) begin
                oled_data = COLOUR_RED;
            end
            
            else if ((x >= 2 * font_width + first_y_char_xaxis_translation) && (x < (2 + 1) * font_width + first_y_char_xaxis_translation) && (y >= 4 * font_width + char_yaxis_translation) && (y < (7 + 1) * font_width + char_yaxis_translation)) begin
                oled_data = COLOUR_RED;
            end
            
            //// <2nd Y symbol in RED> /////////////////////////////////////////////////////////
            else if ((x >= 0 * font_width + second_y_char_xaxis_translation) && (x < (0 + 1) * font_width + second_y_char_xaxis_translation) && (y >= 0 + char_yaxis_translation) && (y < (1 + 1) * font_width + char_yaxis_translation)) begin
                oled_data = COLOUR_BLUE;
            end
            
            else if ((x >= 4 * font_width + second_y_char_xaxis_translation) && (x < (4 + 1) * font_width + second_y_char_xaxis_translation) && (y >= 0 + char_yaxis_translation) && (y < (1 + 1) * font_width + char_yaxis_translation)) begin
                oled_data = COLOUR_BLUE;
            end
            ////
            else if ((x >= 1 * font_width + second_y_char_xaxis_translation) && (x < (1 + 1) * font_width + second_y_char_xaxis_translation) && (y >= 2 * font_width + char_yaxis_translation) && (y < (3 + 1) * font_width + char_yaxis_translation)) begin
                oled_data = COLOUR_BLUE;
            end

            else if ((x >= 3 * font_width + second_y_char_xaxis_translation) && (x < (3 + 1) * font_width + second_y_char_xaxis_translation) && (y >= 2 * font_width + char_yaxis_translation) && (y < (3 + 1) * font_width + char_yaxis_translation)) begin
                oled_data = COLOUR_BLUE;
            end
            
            else if ((x >= 2 * font_width + second_y_char_xaxis_translation) && (x < (2 + 1) * font_width + second_y_char_xaxis_translation) && (y >= 4 * font_width + char_yaxis_translation) && (y < (7 + 1) * font_width + char_yaxis_translation)) begin
                oled_data = COLOUR_BLUE;
            end
            
            ////<Background Colour>/////////////////////////////////////////////////////////
            else begin
                oled_data = COLOUR_BLACK;
            end
        end
    end

endmodule
