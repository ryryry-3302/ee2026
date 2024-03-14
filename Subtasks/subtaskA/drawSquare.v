`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2024 01:30:07 PM
// Design Name: 
// Module Name: drawSquare
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

//drawRectangle drawRectangle_inst (
//    .pixel_index(pixel_index),
//    .X_coord_start(),
//    .Y_coord_start(),
//    .X_coord_end(),
//    .Y_coord_end(),
//    .draw()
//);


module drawRectangle(
    input [12:0] pixel_index,
    input [7:0] X_coord_start,
    input [7:0] Y_coord_start,
    input [7:0] X_coord_end,
    input [7:0] Y_coord_end,
    output draw
    );

    wire [7:0] curr_X;
    wire [7:0] curr_Y;
    
    indexToXY curr_coord(.pixel_index(pixel_index),
                         .X_coord(curr_X),
                         .Y_coord(curr_Y));

    assign draw = (curr_X >= X_coord_start) && (curr_X <= X_coord_end) && (curr_Y >= Y_coord_start) && (curr_Y <= Y_coord_end);
    
endmodule