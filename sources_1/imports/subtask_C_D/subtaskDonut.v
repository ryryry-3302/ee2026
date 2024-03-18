`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2024 14:04:51
// Design Name: 
// Module Name: subtaskDonut
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


module subtaskDonut(
    input enable,

    input clk,
    input [0:0]sw,
    input btnC,
    input btnU,
    input btnR,
    input btnL,
    input btnD,
    
    
    input [12:0]currentPixel,
    output [15:0]pixelOutput
    
    
//    output [7:0]JC
    );
    
    wire [15:0]pixelOutput;
    reg [15:0]pixelOutputReg = 0;
    assign pixelOutput = pixelOutputReg;
    
    wire [15:0]allRed;
    assign allRed = 16'b1111100000000000;
    wire [15:0]allGreen;
    assign allGreen = 16'b0000011111100000;
    wire [15:0]allBlue;
    assign allBlue = 16'b0000000000011111;
    wire [15:0]allWhite;
    assign allWhite = 16'b1111111111111111;
    wire [15:0]allBlack;
    assign allBlack = 0;
    
    
    wire my6p25MhzSig;
    CustomClock my6p25Mhz(clk, 7, my6p25MhzSig);
    
    
    //playerChar
    reg [7:0]xValPlayer = 0;
    reg [7:0]yValPlayer = 0;
    
    
    reg [7:0]yValPlayer15 = 0;
    
    reg [7:0]xValPlayer30 = 0;
    
    reg [7:0]xValPlayer45 = 0;
    reg [7:0]yValPlayer45 = 0;
    
    reg currMoveRight = 0;
    reg currMoveLeft = 0;
    reg currMoveUp = 0;
    reg currMoveDown = 0;
    wire currMoving;
    assign currMoving = (currMoveRight || currMoveLeft || currMoveUp || currMoveDown);
    reg currWhite = 0;
    reg justEnabled = 1;
    

    wire my25MhzSig;
    CustomClock my25Mhz(clk, 2, my25MhzSig);
    //reg [12:0]my25MhzCounter = 0;
    wire [12:0]currentPixel;
    wire [7:0]currX; wire [7:0]currY; 
    assign currX = currentPixel%96;
    assign currY = currentPixel/96; 
    
    always @ (posedge my25MhzSig) begin
    
        //render PlayerChar
        if ((currX >= xValPlayer) && (currX <(xValPlayer + 5)) && (currY >= yValPlayer) && (currY < (yValPlayer +5)))begin
            pixelOutputReg = (currWhite)? allWhite: allBlue;
        end else begin
            pixelOutputReg = allBlack;
        end
        
        if (btnC && !currMoving && enable) begin 
            xValPlayer = 46;
            yValPlayer = 59;
    //        yValPlayer45 = 59; yValPlayer15 = 59;
    //        xValPlayer45 =46; xValPlayer30 = 46;
            currMoveRight <= 0; currMoveLeft <= 0; currMoveUp <= 0;
            currWhite = 1;
        end      
        if (enable)begin
            xValPlayer = sw[0]? xValPlayer30: xValPlayer45;
            yValPlayer = sw[0]? yValPlayer15: yValPlayer45;
        end else begin
            xValPlayer = 0;
            yValPlayer = 0;
            currMoveRight = 0;
            currMoveLeft = 0;
            currMoveUp = 0;
            currWhite = 0;
        end
        justEnabled = !enable;
    
        if (xValPlayer == 91) begin currMoveRight = 0; end
        if (xValPlayer == 0) begin currMoveLeft = 0;end
        if (yValPlayer == 0) begin currMoveUp = 0; end
        //read controls
    //    if (btnD && !currMoving && currWhite) begin currMoveDown = (yValPlayer >= 64-5)? 0: 1; end
        if (btnU && currWhite) begin currMoveUp = (yValPlayer <= 0)? 0: 1; currMoveRight = 0; currMoveLeft = 0; end
        if (btnR && currWhite) begin currMoveRight = (xValPlayer >= 91)? 0: 1;currMoveUp = 0; currMoveLeft = 0; end
        if (btnL && currWhite) begin currMoveLeft = (xValPlayer <= 0)? 0: 1;currMoveRight = 0; currMoveUp = 0; end
    
        
    
        
    
        
    end
    
    //always @ (sw[0]) begin 
    //    xValPlayer45 = xValPlayer;
    //    yValPlayer45 = yValPlayer;
    //    xValPlayer30 = xValPlayer;
    //    yValPlayer15 = yValPlayer;
    //end
    
    reg allowedToMove15 = 1;
    wire my15HzSig;
    CustomClock my15HzClock(clk, 3333332, my15HzSig);
    always @ (posedge (my15HzSig)) begin
        yValPlayer15 = yValPlayer;
        if (btnC && !currMoving && enable) begin yValPlayer15 = 59; end
    //    if (currMoveDown) begin yValPlayer = (yValPlayer >= 64-5)? yValPlayer: yValPlayer+1; end
        if (currMoveUp && sw[0] && enable) begin if(yValPlayer15 > 0 && enable)
            begin yValPlayer15 = yValPlayer - 1; allowedToMove15 = 1; end
            end 
    //    if (currMoveRight && sw[0]) begin xValPlayer = (xValPlayer >=96-5)? xValPlayer: xValPlayer+1; end
    //    if (currMoveLeft && sw[0]) begin xValPlayer = (xValPlayer <= 0)? xValPlayer: xValPlayer-1; end
    end
    
    reg allowedToMove30 = 1;
    wire my30HzSig;
    CustomClock my30HzClock(clk, 1666666, my30HzSig);
    always @ (posedge my30HzSig) begin
       xValPlayer30 = xValPlayer;
        if (btnC && !currMoving && enable) begin xValPlayer30 = 46; end
    //    if (currMoveDown) begin yValPlayer = (yValPlayer >= 64-5)? yValPlayer: yValPlayer+1; end
    //    if (currMoveUp) begin yValPlayer = (yValPlayer <= 0)? yValPlayer: yValPlayer-1; end
        if (currMoveRight && sw[0] && enable) begin if(xValPlayer < 91 && enable) begin xValPlayer30 = xValPlayer+1; allowedToMove30 = 1; end end
        if (currMoveLeft && sw[0] && enable) begin if (xValPlayer > 0 && enable) begin xValPlayer30 = xValPlayer-1; allowedToMove30 = 1; end end
    end
    
    reg allowedToMove45 = 1;
    wire my45HzSig;
    CustomClock my45HzClock(clk, 1111110, my45HzSig);
    always @ (posedge my45HzSig) begin
        xValPlayer45 = xValPlayer;
        yValPlayer45 = yValPlayer;
        if (btnC && !currMoving && enable) begin yValPlayer45 = 59; allowedToMove45 = 0; end
        if (btnC && !currMoving && enable) begin xValPlayer45 = 46; end
    //    if (currMoveDown && !sw[0]) begin yValPlayer = (yValPlayer >= 64-5)? yValPlayer: yValPlayer+1; end
        if (currMoveUp && !sw[0] && enable) begin if (yValPlayer > 0 && enable)begin yValPlayer45 =  yValPlayer -1; allowedToMove45 = 1; end end
        if (currMoveRight && !sw[0] && enable) begin if(xValPlayer < 91 && enable)begin xValPlayer45 =  xValPlayer + 1; allowedToMove45 = 1;  end end
        if (currMoveLeft && !sw[0] && enable) begin if(xValPlayer > 0 && enable) begin xValPlayer45 = xValPlayer -1; allowedToMove45 = 1; end end
    end
    
//    Oled_Display screen(
//        .clk(my6p25MhzSig),
//        .pixel_data(pixelOutput),
//        .reset(0),
//        .cs(JC[0]),
//        .sdin(JC[1]), 
//        .sclk(JC[3]), 
//        .d_cn(JC[4]), 
//        .resn(JC[5]), 
//        .vccen(JC[6]),
//        .pmoden(JC[7]),
//        .pixel_index(currentPixel)
//        );
    
    
    endmodule
