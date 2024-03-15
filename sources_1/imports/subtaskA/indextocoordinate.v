`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2024 16:20:59
// Design Name: 
// Module Name: indextocoordinate
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

module indexToXY(
    input [12:0] pixel_index,
    output [7:0] X_coord,
    output [7:0] Y_coord
    );
    
    assign Y_coord = pixel_index / 96;
    assign X_coord = pixel_index % 96;
    
endmodule
