`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2024 10:13:55 AM
// Design Name: 
// Module Name: counterGreen
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

//counterGreen counterGreen(
//    .enable(),
//    .clock2hz(),
//    .state()
//    );

module counterGreen(
    input enable,
    input clock2hz,
    output reg [3:0] state = 3'b000
    );

reg[3:0] count;

always @(posedge clock2hz) 
begin

    if (enable && count<12) begin
        count = count + 1;
        case (count)
           4 : state <= 3'b001; // 1 pix green border
           7 : state <= 3'b010; // 2 pix green border
           9 : state <= 3'b011; // 3 pix green border
           11 : state <= 3'b000; // clear

            default: state <= state;
        endcase
    end
    else begin
        count <= 0;
        state <= 3'b000;
    end
end

    
    
endmodule
