`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2024 20:41:22
// Design Name: 
// Module Name: subtask_c_module
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


module subtask_c_module(input enable, input clk, input btnD, input [12:0] pixel_index, output reg [15:0] oled_data);

//// <COLOURS> //////////////////////////////////////////////////
    reg [15:0] COLOUR_RED   = 16'b11111_000000_00000; 
    reg [15:0] COLOUR_GREEN = 16'b00000_111111_00000;
    reg [15:0] COLOUR_BLACK = 16'b00000_000000_00000;
    reg [15:0] COLOUR_DEBUG = 16'b11111_111111_11111;
    
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
//    my_custom_clk my_clk_20hz (clk, 2499999, clk_20hz);
    
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
        if (enable == 1) begin
            if (btnD == 1) begin
                start_movement <= 1;
            end
            
            else begin
                start_movement <= start_movement;
            end
            
            //Case 1: Start_up (DONE)
            if ((is_initialised == 0) && (start_movement == 0)) begin
                if ((x >= 46) && (x <= 50) && (y >= 0) && (y <= 4)) begin
                    oled_data = COLOUR_RED;
                end
                
                else begin
                    oled_data = COLOUR_BLACK;
                end
            end
                
            //Case 2: First Movement
            else if ((is_initialised == 0) && (start_movement == 1)) begin
            COUNT <= (COUNT == count_convert_20hz) ? 0 : COUNT + 1; //At every interval of 1/20 s
            if (COUNT == 4'b0000) begin
                if (CURR_STEP != TOTAL_MOVEMENT_STEP) begin
                    CURR_STEP <= CURR_STEP + 1;
                end
                
                //Movement complete
                else begin
                    CURR_STEP <= 0;
                    is_initialised <= 1;
                    start_movement <= 0;
                end
            end
            //CURR_STEP <= (COUNT == 4'b0000) ? ((CURR_STEP != TOTAL_MOVEMENT_STEP) ? CURR_STEP + 1 : 0 ) : CURR_STEP ;
            
            //Down the Column          
            if ((CURR_STEP >= 0) && (CURR_STEP <= 29)) begin
                if ((x >= 46) && (x <= 50) && (y >= 0) && (y <= (CURR_STEP + 4))) begin
                    oled_data = COLOUR_RED;
                end
                
                else begin
                    oled_data = COLOUR_BLACK;
                end
            end
            
            //Right to the Row
            else if ((CURR_STEP >= 30) && (CURR_STEP <= 44)) begin
                if ((x >= 46) && (x <= 50) && (y >= 0) && (y <= 34)) begin
                    oled_data = COLOUR_RED;
                end
                
                else if ((x >= 51) && (x <= (50 + CURR_STEP - 30)) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_RED;
                end
                
                else begin
                    oled_data = COLOUR_BLACK;
                end
            end
            
            //Stationary 0.5 seconds as RED
            else if ((CURR_STEP >= 45) && (CURR_STEP <= 54)) begin
                if ((x >= 46) && (x <= 50) && (y >= 0) && (y <= 34)) begin
                    oled_data = COLOUR_RED;
                end
                
                else if ((x >= 51) && (x <= 65) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_RED;
                end
                
                else begin
                    oled_data = COLOUR_BLACK;
                end
            end
            
            //Stationary 0.5 seconds as GREEN
            else if ((CURR_STEP >= 55) && (CURR_STEP <= 64)) begin
                if ((x >= 46) && (x <= 50) && (y >= 0) && (y <= 34)) begin
                    oled_data = COLOUR_RED;
                end
                
                else if ((x >= 51) && (x <= 60) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_RED;
                end
                
                else if ((x >= 61) && (x <= 65) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_GREEN;
                end
                
                else begin
                    oled_data = COLOUR_BLACK;
                end
            end            
            
            //Left to the row
            else if ((CURR_STEP >= 65) && (CURR_STEP <= 94)) begin
                if ((x >= 46) && (x <= 50) && (y >= 0) && (y <= 29)) begin
                    oled_data = COLOUR_RED;
                end
                
                //Touched by GREEN (now GREEN)
                else if ((x >= (61 - ((CURR_STEP - 65)/2))) && (x <= 65) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_GREEN;
                end
                
                //Not yet touched by GREEN (still RED)
                else if ((x >= 46) && (x <= (61 - ((CURR_STEP - 65)/2))) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_RED;
                end
                
                else begin
                    oled_data = COLOUR_BLACK;
                end
            end 
            
            //Up to the column
            else if ((CURR_STEP >= 95) && (CURR_STEP <= 154)) begin
                //Column  touched by Green (Now GREEN)
                if ((x >= 46) && (x <= 50) && (y >= (29 - ((CURR_STEP - 95)/2))) && (y <= 29)) begin
                    oled_data = COLOUR_GREEN;
                end
                
                //Column not touched by Green (Still RED)
                else if ((x >= 46) && (x <= 50) && (y >= 0) && (y <= (29 - ((CURR_STEP - 95)/2)))) begin
                    oled_data = COLOUR_RED;
                end
                
                //Full Bottom Row now GREEN
                else if ((x >= 46) && (x <= 65) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_GREEN;
                end
                
                else begin
                    oled_data = COLOUR_BLACK;
                end
            end 
            
            //Stationary 0.5s as GREEN
            else if ((CURR_STEP >= 155) && (CURR_STEP <= 164)) begin
                //Full down Column  touched  (Now GREEN)
                if ((x >= 46) && (x <= 50) && (y >= 0) && (y <= 34)) begin
                    oled_data = COLOUR_GREEN;
                end
                        
                //Extension Bottom Row now GREEN
                else if ((x >= 51) && (x <= 65) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_GREEN;
                end
                
                else begin
                    oled_data = COLOUR_BLACK;
                end
            end                                
            end
                
            //Case 3: Further Movement
            else if ((is_initialised == 1) && (start_movement == 1)) begin
            COUNT <= (COUNT == count_convert_20hz) ? 0 : COUNT + 1; //At every interval of 1/20 s
            if (COUNT == 4'b0000) begin
                if (CURR_STEP != TOTAL_MOVEMENT_STEP) begin
                    CURR_STEP <= CURR_STEP + 1;
                end
                
                //Movement complete
                else begin
                    CURR_STEP <= 0;
                    is_initialised <= 1;
                    start_movement <= 0;
                end
            end
            //CURR_STEP <= (COUNT == 4'b0000) ? ((CURR_STEP != TOTAL_MOVEMENT_STEP) ? CURR_STEP + 1 : 0 ) : CURR_STEP ;
            
            //Down the Column          
            if ((CURR_STEP >= 0) && (CURR_STEP <= 29)) begin
                if ((x >= 46) && (x <= 50) && (y >= 0) && (y <= (CURR_STEP + 4))) begin
                    oled_data = COLOUR_RED;
                end
                
                else if ((x >= 46) && (x <= 50) && (y >= (CURR_STEP + 4)) && (y <= 34)) begin
                    oled_data = COLOUR_GREEN;
                end
                
                else if ((x >= 51) && (x <= 65) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_GREEN;
                end             
                
                else begin
                    oled_data = COLOUR_BLACK;
                end
            end
            
            //Right to the Row
            else if ((CURR_STEP >= 30) && (CURR_STEP <= 44)) begin
                if ((x >= 46) && (x <= 50) && (y >= 0) && (y <= 34)) begin
                    oled_data = COLOUR_RED;
                end
                
                else if ((x >= 51) && (x <= (50 + CURR_STEP - 30)) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_RED;
                end
                
                else if ((x >= (50 + CURR_STEP - 30)) && (x <= 65) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_GREEN;
                end
                
                else begin
                    oled_data = COLOUR_BLACK;
                end
            end
            
            //Stationary 0.5 seconds as RED
            else if ((CURR_STEP >= 45) && (CURR_STEP <= 54)) begin
                if ((x >= 46) && (x <= 50) && (y >= 0) && (y <= 34)) begin
                    oled_data = COLOUR_RED;
                end
                
                else if ((x >= 51) && (x <= 65) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_RED;
                end
                
                else begin
                    oled_data = COLOUR_BLACK;
                end
            end
            
            //Stationary 0.5 seconds as GREEN
            else if ((CURR_STEP >= 55) && (CURR_STEP <= 64)) begin
                if ((x >= 46) && (x <= 50) && (y >= 0) && (y <= 34)) begin
                    oled_data = COLOUR_RED;
                end
                
                else if ((x >= 51) && (x <= 60) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_RED;
                end
                
                else if ((x >= 61) && (x <= 65) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_GREEN;
                end
                
                else begin
                    oled_data = COLOUR_BLACK;
                end
            end            
            
            //Left to the row
            else if ((CURR_STEP >= 65) && (CURR_STEP <= 94)) begin
                if ((x >= 46) && (x <= 50) && (y >= 0) && (y <= 29)) begin
                    oled_data = COLOUR_RED;
                end
                
                //Touched by GREEN (now GREEN)
                else if ((x >= (61 - ((CURR_STEP - 65)/2))) && (x <= 65) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_GREEN;
                end
                
                //Not yet touched by GREEN (still RED)
                else if ((x >= 46) && (x <= (61 - ((CURR_STEP - 65)/2))) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_RED;
                end
                
                else begin
                    oled_data = COLOUR_BLACK;
                end
            end 
            
            //Up to the column
            else if ((CURR_STEP >= 95) && (CURR_STEP <= 154)) begin
                //Column  touched by Green (Now GREEN)
                if ((x >= 46) && (x <= 50) && (y >= (29 - ((CURR_STEP - 95)/2))) && (y <= 29)) begin
                    oled_data = COLOUR_GREEN;
                end
                
                //Column not touched by Green (Still RED)
                else if ((x >= 46) && (x <= 50) && (y >= 0) && (y <= (29 - ((CURR_STEP - 95)/2)))) begin
                    oled_data = COLOUR_RED;
                end
                
                //Full Bottom Row now GREEN
                else if ((x >= 46) && (x <= 65) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_GREEN;
                end
                
                else begin
                    oled_data = COLOUR_BLACK;
                end
            end 
            
            //Stationary 0.5s as GREEN
            else if ((CURR_STEP >= 155) && (CURR_STEP <= 164)) begin
                //Full down Column  touched  (Now GREEN)
                if ((x >= 46) && (x <= 50) && (y >= 0) && (y <= 34)) begin
                    oled_data = COLOUR_GREEN;
                end
                        
                //Extension Bottom Row now GREEN
                else if ((x >= 51) && (x <= 65) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_GREEN;
                end
                
                else begin
                    oled_data = COLOUR_BLACK;
                end
            end 
            end
                
            //Case 4: Movement Completed (DONE)
            else if ((is_initialised == 1) && (start_movement == 0)) begin
                //Just inital square position is RED
                if ((x >= 46) && (x <= 50) && (y >= 0) && (y <= 4)) begin
                    oled_data = COLOUR_RED;
                end
                
                //Rest of L is GREEN
                else if ((x >= 46) && (x <= 50) && (y >= 5) && (y <= 34)) begin
                    oled_data = COLOUR_GREEN;
                end
                        
                else if ((x >= 51) && (x <= 65) && (y >= 30) && (y <= 34)) begin
                    oled_data = COLOUR_GREEN;
                end
                
                else begin
                    oled_data = COLOUR_BLACK;
                end
            end
        end

        else begin
            is_initialised <= 0;
            start_movement <= 0;
            COUNT <= 0;
            CURR_STEP <= 0;
        end
    end
    
endmodule
