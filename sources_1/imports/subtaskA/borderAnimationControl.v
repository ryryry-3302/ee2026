`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2024 10:24:46 AM
// Design Name: 
// Module Name: borderAnimationControl
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

/*
// borderAnimationControl borderAnimationControl_inst (
//     .clock25mhz(clock25mhz),
//     .state(state),
//     .pixel_index(pixel_index),
//     .draw(draw)
// );
*/

module borderAnimationControl(
    input clock25mhz,
    input [3:0] state,
    input [12:0] pixel_index,
    output reg draw = 0
    );



    wire green1pixout;
    drawRectangleBorder green1pix (
            .pixel_index(pixel_index),
            .X_coord_start(8),
            .Y_coord_start(8),
            .X_coord_end(87),
            .Y_coord_end(55),
            .thickness(1),
            .draw(green1pixout)
    );

    wire green2pixout;
    drawRectangleBorder green2pix (
            .pixel_index(pixel_index),
            .X_coord_start(11),
            .Y_coord_start(11),
            .X_coord_end(84),
            .Y_coord_end(51),
            .thickness(2),
            .draw(green2pixout)
    );

        wire green3pixout;
    drawRectangleBorder green3pix (
            .pixel_index(pixel_index),
            .X_coord_start(16),
            .Y_coord_start(16),
            .X_coord_end(79),
            .Y_coord_end(46),
            .thickness(3),
            .draw(green3pixout)
    );

    always @(posedge clock25mhz)
    begin
        case (state)
            3'b001 : draw <= green1pixout;
            3'b010 : draw <= green2pixout || green1pixout;
            3'b011 : draw <= green3pixout || green2pixout || green1pixout;
            default : draw <= 0;
        endcase
    end


endmodule
