`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2024 01:23:06 PM
// Design Name: 
// Module Name: objectSelector
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

//// Instantiate objectSelector module
//objectSelector objectSelector_inst (
//    .fastclock()
//    .pixel_index()
//    .enable(enable),
//    .btnDpress(btnDpress),
//    .object(object),
//    .oled_data(oled_data)
//);

module objectSelector(
    input fastclock,
    input pixel_index,
    input enable,
    input btnDpress,
    output reg object = 0,
    output reg [15:0] oled_data = 0
    );
    
    reg [1:0]state = 2'b00;
    
    always @ (posedge btnDpress) 
    begin
        if (state < 2'b11) 
        begin
            state <= state + 1;
        end 
        else 
        begin
            state <= 2'b01;
        end         
    end
    
    wire redSquare;
    drawRectangle drawRectangle_inst (
         .pixel_index(pixel_index),
         .X_coord_start(((96/2)-4)),
         .Y_coord_start((64/2)-4),
         .X_coord_end(((96/2)+4)),
         .Y_coord_end((64/2)+4),
         .draw(redSquare)
     );
    
    wire orangeCircle;
    // Instantiate drawCircle module
    drawCircle drawCircle_inst (
        .pixel_index(pixel_index),
        .center_X(96/2),
        .center_Y(64/2),
        .radius(6),
        .draw(orangeCircle)
    );
    
    
    wire greenTriangle;
    // Instantiate drawEquilateralTriangle module
    drawTriangle drawTriangle_inst (
        .pixel_index(pixel_index),
        .center_X(96/2-7),
        .center_Y(64/2),
        .side_length(14),
        .draw(greenTriangle)
    );
    
      always @ (posedge fastclock) begin
      
          case (state)
              2'b01 : begin
                  object <= redSquare; // Red square
                  oled_data <= 16'hF800; // Set oled_data to red color
              end
              2'b10 : begin
                  object <= orangeCircle; // Orange circle
                  oled_data <= 16'hFD20; // Set oled_data to orange color
              end
              2'b11 : begin
                  object <= greenTriangle; // Green triangle
                  oled_data <= 16'h07E0; // Set oled_data to green color
              end
              default : begin
                  object <= 0; // No output
                  oled_data <= 16'h0000; // Set oled_data to black
              end
          endcase
       end


endmodule
