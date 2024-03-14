`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2024 17:38:36
// Design Name: 
// Module Name: Draw_MulSquares
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


module Draw_MulSquares(
    input start,
    input [12:0] pixel_index,
    input [2:0] state,
    output reg draw,
    output reg [15:0] colour);
 
    reg [15:0] COLOUR_RED    = 16'b11111_000000_00000; 
    reg [15:0] COLOUR_GREEN  = 16'b00000_111111_00000;   
    reg [15:0] COLOUR_BLUE   = 16'b00000_000000_11111;
    reg [15:0] COLOUR_WHITE  = 16'hFFFF;
    
    reg [15:0] COLOUR_BLACK = 16'b00000_000000_00000;
    reg [15:0] COLOUR_YELLOW = 16'b00000_111111_11111;
    
    reg [7:0] SQUARE_LEN = 6;
    reg [7:0] X_COOR_1 = 10;
    reg [7:0] Y_COOR_1 = 27;
    reg [7:0] GAP = 10;
    reg [7:0] SEP = 16; //SQUARE_LEN + GAP
    
    wire DrawSquare1;
    Draw_Square square1(.pixel_index(pixel_index),
                        .X_coord_start(X_COOR_1),
                        .Y_coord_start(Y_COOR_1),
                        .length(SQUARE_LEN),
                        .draw(DrawSquare1));
 
     wire DrawSquare2;
     Draw_Square square2(.pixel_index(pixel_index),
                        .X_coord_start(X_COOR_1 + SEP),
                        .Y_coord_start(Y_COOR_1),
                        .length(SQUARE_LEN),
                        .draw(DrawSquare2));

     wire DrawSquare3;
     Draw_Square square3(.pixel_index(pixel_index),
                        .X_coord_start(X_COOR_1 + 2*SEP),
                        .Y_coord_start(Y_COOR_1),
                        .length(SQUARE_LEN),
                        .draw(DrawSquare3));
 
      wire DrawSquare4;
      Draw_Square square4(.pixel_index(pixel_index),
                           .X_coord_start(X_COOR_1 + 3*SEP),
                           .Y_coord_start(Y_COOR_1),
                           .length(SQUARE_LEN),
                           .draw(DrawSquare4));
  
      wire DrawSquare5;
      Draw_Square square5(.pixel_index(pixel_index),
                          .X_coord_start(X_COOR_1 + 4*SEP),
                          .Y_coord_start(Y_COOR_1),
                          .length(SQUARE_LEN),
                          .draw(DrawSquare5));
                          
                          
    
    always @(*)
    begin
    if(start)
        begin
            draw = (DrawSquare1 || DrawSquare2 || DrawSquare3 || DrawSquare4 || DrawSquare5);
            if(draw)
                begin
                case(state)
                    3'b000:  colour  = COLOUR_WHITE;
                    3'b001:  colour  = COLOUR_RED;
                    3'b010:  colour  = COLOUR_GREEN;
                    3'b011:  colour  = COLOUR_BLUE;
                    default: colour  = COLOUR_YELLOW;
                 endcase
                 end
            else
                colour = COLOUR_BLACK;
        
        end
    end
    
endmodule
