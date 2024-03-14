`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2024 19:58:47
// Design Name: 
// Module Name: Draw_Border
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


module Draw_Border(
    input [12:0] pixel_index,
    input btnL_filtered,
    input btnR_filtered,
    input task_active,
    output reg draw,
    output reg [15:0] colour);
    
    reg [15:0] COLOUR_GREEN  = 16'b00000_111111_00000; 
    reg [15:0] COLOUR_BLACK  = 16'b00000_000000_00000;
    
    // 000, 001, 010, 011, 100
    reg [2:0] border_pos = 3'b010; //Start at the middle
    
    always@(posedge ( (btnL_filtered | btnR_filtered) | ~task_active) )
    begin
        if(btnL_filtered)
            border_pos = (border_pos == 3'b000) ? 3'b000 : border_pos - 1;
        else if(btnR_filtered)
            border_pos = (border_pos >= 3'b100) ? 3'b100 : border_pos + 1;
        else
            border_pos = 3'b010;
    end
    
    reg[7:0] start_x = 7'd00;
    reg[7:0] start_y = 7'd23;
    
    
    reg[7:0] start_x_1 = 7'd6;
    reg[7:0] x_sep = 7'd16;
    
    always@(border_pos)
    begin
    case(border_pos)
        3'b000: start_x = start_x_1;
        3'b001: start_x = start_x_1 + 1*x_sep;
        3'b010: start_x = start_x_1 + 2*x_sep;
        3'b011: start_x = start_x_1 + 3*x_sep;
        3'b100: start_x = start_x_1 + 4*x_sep;
        default: start_x = 0;
    endcase
    end
    
    wire green_draw;
    Draw_Square green_sq(.pixel_index(pixel_index),
                         .X_coord_start(start_x),
                         .Y_coord_start(start_y),
                         .length(14),
                         .draw(green_draw));
    wire black_draw;                         
    Draw_Square  black_sq(.pixel_index(pixel_index),
                          .X_coord_start(start_x + 3 ),
                          .Y_coord_start(start_y + 3 ),
                          .length(8),
                          .draw(black_draw));
    
    always@(*)
    begin
        if(black_draw && green_draw) //Overlap
            draw = 1'b0;
        else if(green_draw)          //Border
            begin
            colour = COLOUR_GREEN;                     
            draw = 1'b1;
            end
         else
            draw = 1'b0;
    end
    
endmodule
