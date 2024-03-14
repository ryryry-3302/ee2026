`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2024 01:58:08 PM
// Design Name: 
// Module Name: drawCircle
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

// Instantiate drawCircle module
//drawCircle drawCircle_inst (
//    .pixel_index(pixel_index),
//    .center_X(center_X),
//    .center_Y(center_Y),
//    .radius(radius),
//    .draw(draw)
//);


module drawCircle(input clock, input [12:0] pixel_index, input [7:0] center_X, input [7:0] center_Y, input [15:0] radius, output reg draw);

       wire [7:0] curr_X;
       wire [7:0] curr_Y;
       
       // Convert pixel_index to X and Y coordinates
       indexToXY curr_coord(.pixel_index(pixel_index), .X_coord(curr_X), .Y_coord(curr_Y));
   
       // Calculate distance from center
       reg [15:0] distance_X;
       reg [15:0] distance_Y;
       reg [15:0] distance_squared;
       
       always@(posedge clock)
       begin
       distance_X <= curr_X - center_X;
       distance_Y <= curr_Y - center_Y;
       
       // Calculate squared distance
       distance_squared <= (distance_X * distance_X) + (distance_Y * distance_Y);
       
       // Check if pixel is within the circle
       draw <= distance_squared < (radius * radius) ? 1 : 0;
       end

    endmodule