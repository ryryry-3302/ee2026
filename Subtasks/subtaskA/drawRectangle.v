`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2024 09:01:52 AM
// Design Name: 
// Module Name: drawRectangle
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2024 08:05:09 AM
// Design Name: 
// Module Name: PB_PressDetect
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



module drawRectangleBorder(
    input [12:0] pixel_index,
    input [7:0] X_coord_start,
    input [7:0] Y_coord_start,
    input [7:0] X_coord_end,
    input [7:0] Y_coord_end,
    input [7:0] thickness,
    output draw
);

    wire [7:0] curr_X;
    wire [7:0] curr_Y;
    
    indexToXY curr_coord(.pixel_index(pixel_index),
                         .X_coord(curr_X),
                         .Y_coord(curr_Y));


    assign draw = (curr_X >= X_coord_start) && (curr_X <= X_coord_end) && (curr_Y >= Y_coord_start) && (curr_Y <= Y_coord_end) && 
    (curr_X> X_coord_end-thickness || curr_X< X_coord_start+thickness || curr_Y> Y_coord_end-thickness || curr_Y< Y_coord_start+thickness ); 
                  



endmodule


/*
// Port instantiation
// Instantiate the drawRectangleBorder module
drawRectangleBorder rectangle_inst (
    .pixel_index(pixel_index),       // Input: pixel index
    .X_coord_start(X_coord_start),   // Input: X coordinate start
    .Y_coord_start(Y_coord_start),   // Input: Y coordinate start
    .X_coord_end(X_coord_end),       // Input: X coordinate end
    .Y_coord_end(Y_coord_end),       // Input: Y coordinate end
    .thickness(thickness),           // Input: thickness
    .draw(draw)                      // Output: draw signal
);
*/

