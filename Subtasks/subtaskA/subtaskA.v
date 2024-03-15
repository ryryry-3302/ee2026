`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module Top_StudentA (input sw1,input [12:0]pixel_index,input clk, input btnC,input btnD,output reg [15:0] oled_data = 0);
        wire CLOCKOUT6;
        wire CLOCKOUT25;
        wire fb;
        wire sendingpix;
        wire samplepix;

        reg pixeldata = 16'h07E0;
        wire [6:0]xcoor;
        wire [5:0]ycoor;
        
        wire CLOCKOUT1khz;
        wire CLOCKOUT10khz;
        wire CLOCKOUT1hz;
        
        CustomClock clock6mhz(clk, 7,CLOCKOUT6);
        CustomClock clock25m(clk, 1,CLOCKOUT25);
        CustomClock clock1khz(clk, 32'd50_000-1,CLOCKOUT1khz);
        CustomClock clock10khz(clk, 32'd5000 - 1,CLOCKOUT10khz);
        CustomClock clock1hz(clk, 32'd49999999,CLOCKOUT1hz);
        
        
        
        
        
//        Oled_Display display(.clk(CLOCKOUT6), .reset(0), .frame_begin(fb), .sending_pixels(sendingpix), .sample_pixel(samplepix), .pixel_index(pixel_index), .pixel_data(oled_data), .cs(JB[0]), .sdin(JB[1]), .sclk(JB[3]), .d_cn(JB[4]), .resn(JB[5]), .vccen(JB[6]), .pmoden(JB[7]));
        indexToXY indexToXY(.pixel_index(pixel_index), .X_coord(xcoor), .Y_coord(ycoor));
        
        reg enable = 0;
        always @ (posedge CLOCKOUT25)
        begin
            if(~sw1)begin
            enable <= 0;
            
            end
            else begin
            enable <= 1;
            end
        end
        
        
        //btnC press status     
        reg state = 0;
        always@(posedge CLOCKOUT25)
        begin
            if(~enable)begin
            state <= 1'b0;
            end
            if(btnC && enable)
            begin
                state <= 1;
            end
        end
        
        wire red;
        drawRectangleBorder red_border (.pixel_index(pixel_index), .X_coord_start(2), .Y_coord_start(2), .X_coord_end(93), .Y_coord_end(61), .thickness(1), .draw(red));
        
        wire orange;
        drawRectangleBorder orange_border (.pixel_index(pixel_index), .X_coord_start(4), .Y_coord_start(4), .X_coord_end(91), .Y_coord_end(59), .thickness(3), .draw(orange));
        
        wire clock2hzout;
        CustomClock clock2hz(clk, 24999999,clock2hzout);
        
        wire [3:0] stateofanimation;
        counterGreen counterGreen(.enable(state), .clock2hz(clock2hzout), .state(stateofanimation));
        
        wire drawanimation;
         borderAnimationControl borderAnimationControl_inst (.clock25mhz(CLOCKOUT25), .state(stateofanimation), .pixel_index(pixel_index), .draw(drawanimation));
         
         wire btnDpress;
         // Instantiate PB_PressDetect module
         PB_PressDetect PB_Instance_name (
             .Clock_1kHz(CLOCKOUT1khz),     // Connect to your Clock_1kHz signal
             .Clock_10kHz(CLOCKOUT10khz),    // Connect to your Clock_10kHz signal
             .btn(btnD),            // Connect to your btn signal
             .btn_press(btnDpress)       // Connect to your btn_press signal
         );

        reg drawobject;
        reg [15:0] objectcolor;

         
         // shapes instances
         wire redSquare;
         drawRectangle drawRectangle_inst (.pixel_index(pixel_index), .X_coord_start(((96/2)-4)), .Y_coord_start((64/2)-4), .X_coord_end(((96/2)+4)), .Y_coord_end((64/2)+4), .draw(redSquare));
         
         wire orangeCircle;
         // Instantiate drawCircle module
         drawCircle drawCircle_inst (.clock(CLOCKOUT25), .pixel_index(pixel_index), .center_X(96/2), .center_Y(64/2), .radius(6), .draw(orangeCircle));
         
         wire greenTriangle;
         // Instantiate drawEquilateralTriangle module
         drawTriangle drawTriangle_inst (.pixel_index(pixel_index), .center_X(96/2-7), .center_Y(64/2), .side_length(14), .draw(greenTriangle));
         
         
         //toggle state only if state 1 is 1
         reg [1:0]state2 = 2'b00;
         always @ (posedge (btnDpress| ~enable)) 
         begin
         if (state && enable )begin
             begin
                 if (state2 < 2'b11) 
                 begin
                     state2 <= state2 + 1;
                 end 
                 else 
                 begin
                     state2 <= 2'b01;
                 end         
             end
         end
         else begin
            state2 <=2'b00;
         end
         end
         
         always @ (posedge CLOCKOUT25) 
         begin
           if (state)begin
           case (state2)
               2'b01 : begin
                   drawobject <= redSquare; // Red square
                   objectcolor <= 16'hF800; // Set oled_data to red color
               end
               2'b10 : begin
                   drawobject <= orangeCircle; // Orange circle
                   objectcolor <= 16'hFD20; // Set oled_data to orange color
               end
               2'b11 : begin
                   drawobject <= greenTriangle; // Green triangle
                   objectcolor <= 16'h07E0; // Set oled_data to green color
               end
               default : begin
                   drawobject <= 0; // No output
                   objectcolor <= 16'h0000; // Set oled_data to black
               end
           endcase
           end
       
        end
                 
        always@(posedge CLOCKOUT25) begin
           if (red && enable)
           begin
                oled_data <= 16'hF800;
           end 
           else 
           begin
               if ((state) && (orange))
                   begin
                        oled_data <= 16'hFD20;
                   end 
               else 
               begin 
                   if ((state) && (drawanimation))
                       begin
                            oled_data <= 16'h07e0;
                       end 
               else 
               begin 
                   if (drawobject) 
                       begin
                            oled_data <= objectcolor;//objectcolor;
                       end
                   else 
                       begin
                            oled_data <= 16'h0000;
                       end
               end
           end
           end
        end
        

endmodule