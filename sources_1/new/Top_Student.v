`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME: Yow Keng Yee Samuel
//  STUDENT C NAME: Lim Yee Kian
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input clk,                //100MHz
    input [15:0] sw,          //SW0 (Tasks) SW1,2,3,4 (ABCD) SW5 GRP
    input btnC, btnL, btnR, btnU, btnD,
    output [4:0] led,         //1234 for subtask ABCD
    output [7:0] JC, 
    output [6:0] seg,         //7 Segment
    output dp,
    output [3:0] an,
    inout PS2Clk, PS2Data     //Mouse
);

    //OLED Driver -----------------------------------
    reg [15:0] oled_colour;
    wire frame_begin;
    wire [12:0] pixel_index;
    wire sending_pixels, sample_pixel;

    wire CLK_6MHz25;
    CustomClock clk6p25m(.CLOCK_IN(clk),
                         .COUNT_STOP(32'd7),
                         .CLOCK_OUT(CLK_6MHz25));
                          
    //Celebration Module -----------------------------------
    wire [15:0] celebration_oled_colour;
    reg celebrationState = 0;
    congrats_modules my_congrats (.clk(clk), .celebrationState(celebrationState), .pixel_index(pixel_index), .oled_data(celebration_oled_colour));

    //Mouse Driver---------------------------------------
    wire [11:0] xpos; wire [11:0] ypos; wire [3:0] zpos;
    wire newevent;
    wire left_click, centre_click, right_click;
    reg reset_canvas;

    //---------------------------------------------------

    //Paintv Driver--------------------------------------
    wire CLK_25MHz;   
    CustomClock clk25mhz(.CLOCK_IN(clk),
                         .COUNT_STOP(1),
                         .CLOCK_OUT(CLK_25MHz)); 
    wire CLK_12MHz5;
    CustomClock clk12mhz5(.CLOCK_IN(clk),
                          .COUNT_STOP(3),
                          .CLOCK_OUT(CLK_12MHz5)); 
    wire CLK_10KHz;                 
    CustomClock clk10khz(.CLOCK_IN(clk),
                         .COUNT_STOP(32'd5000 - 1),
                         .CLOCK_OUT(CLK_10KHz));

    wire [15:0] LED_Num_Paint;
    reg [3:0] Num_Detected = 15;
    wire [6:0] paint_v_seg; //Dummy wire var
    wire [15:0] paint_colour_chooser;
    //---------------------------------------------------
    
    //Task Switching
    reg task_a_active   = 0;
    reg task_b_active   = 0;
    reg task_c_active   = 0;
    reg task_d_active   = 0;
    reg task_grp_active = 0;
    
    assign led[0] = task_a_active;
    assign led[1] = task_b_active;
    assign led[2] = task_c_active;
    assign led[3] = task_d_active;
    
    always@(posedge CLK_10KHz)
    begin
        task_a_active <= 0;
        task_b_active <= 0;
        task_c_active <= 0;
        task_d_active <= 0;
        task_grp_active <= 0;
        
        if(sw[1])
            task_a_active   <= 1;
        else if(sw[2])
            task_b_active   <= 1;
        else if(sw[3])
            task_c_active   <= 1;
        else if(sw[4])
            task_d_active   <= 1;
        else if(sw[5])
            task_grp_active <= 1;                            
  
        /*
        task_a_active   = sw[1];
        task_b_active   = sw[2] && !sw[1];
        task_c_active   = sw[3] && !sw[2:1];
        task_d_active   = sw[4] && !(sw[3:1]);
        task_grp_active = sw[5] && !(sw[4:1]);*/
    end
    
    wire [15:0] oled_coloura;
    wire [15:0] oled_colourb;
    wire [15:0] oled_colourc;    
    wire [15:0] oled_colourd;
    
    SubTaskA taska(.sw1(task_a_active),.pixel_index(pixel_index), .clk(clk), .btnC(btnC), .btnD(btnD), .oled_data(oled_coloura));

    SubTaskB taskb(.clk(clk), .SW0(sw[0]), .task_active(task_b_active), .btnC(btnC),.btnL(btnL),.btnR(btnR),  .pixel_index(pixel_index), .oled_colour(oled_colourb));
    
    subtask_c_module taskc(.enable(task_c_active), .clk(clk), .btnD(btnD), .pixel_index(pixel_index), .oled_data(oled_colourc));
    
    subtaskDonut taskD( .enable(task_d_active),.clk(clk),.sw(sw[0]),.btnC(btnC),.btnU(btnU),.btnR(btnR), .btnL(btnL),.btnD(btnD), .currentPixel(pixel_index), .pixelOutput(oled_colourd));
    
    always@(*)
    begin
        if(task_a_active)
            oled_colour = oled_coloura;
        else if(task_b_active)
            oled_colour = oled_colourb;
        else if(task_c_active)
            oled_colour = oled_colourc;
        else if(task_d_active)
            oled_colour = oled_colourd;
        else if(celebrationState)
            oled_colour = celebration_oled_colour;
        else if(task_grp_active) //Paint.v
            oled_colour = paint_colour_chooser;
        else
            oled_colour = 16'h0000; //Force it to be white first
    end

    //7 seg control--------------------------------------------------
   
    reg en;
    reg [3:0] anode_0; reg [3:0] anode_1; reg [3:0] anode_2; reg [3:0] anode_3;

    //Dp, Seg, and An driver
    SevenSeg_Control seg_control(
            .clk(clk),
            .en(en), //Write 0 to turn off 7 seg
            .digit_0(anode_3),  //Write 3'b111 (15) to turn off digit
            .digit_1(anode_2),  //Anode numbering for proj is right to left lol
            .digit_2(anode_1),
            .digit_3(anode_0),
            .dp(dp),
            .seg(seg),
            .an(an)
        );
    
    always @(LED_Num_Paint)
    begin
        case (LED_Num_Paint)
        11'b00000000001: Num_Detected=4'd0;
        11'b00000000010: Num_Detected=4'd1;
        11'b00000000100: Num_Detected=4'd2;
        11'b00000001000: Num_Detected=4'd3;
        11'b00000010000: Num_Detected=4'd4;
        11'b00000100000: Num_Detected=4'd5;
        11'b00001000000: Num_Detected=4'd6;
        11'b00010000000: Num_Detected=4'd7;
        11'b00100000000: Num_Detected=4'd8;
        11'b01000000000: Num_Detected=4'd9;
        default: Num_Detected=4'd15; 
        //By default show nothing if num detected is uncertain?
        endcase     
    end    
    
    always @ (posedge clk) 
    begin 
        if ( task_a_active || task_b_active || task_c_active || task_d_active || ~task_grp_active)
            begin
            en <= 0 ; //Turn seg if task active, or the grp task is not active
            reset_canvas <= 1; //Reset canvas if any task is active or grp task not active
            anode_1 <= 15; anode_0 <= 15;  //clear all anodes
            anode_3 <= 15; anode_2 <= 15;   //4.E4     
            end
        else
            begin
            en <= 1;
            reset_canvas <= right_click;
            end
            
        
        if(sw[15]) //AN3, AN2, AN0 not affected
            begin
            anode_1 <= Num_Detected;  //AN1 > Paint,v
            end
        else if(sw[14]) //AN3, AN2, AN1 not affected
            begin
            anode_0 <= Num_Detected; //AN0 > Paint,v
            end
        else if(sw[13])
            begin
            anode_1 <= 15; anode_0 <= 15;  //Off
            anode_3 <= 5;  anode_2 <= 3;   //4.E4            
            end
        else
            begin
            anode_1 <= 0; anode_0 <= 6;   //Grp Number
            anode_3 <= 5; anode_2 <= 3;  //5, Wed PM            
            end
    end
    //--------------------------------------------------
    
    //Celebration detection ----------------------------
    always @ (posedge clk)
    begin
        if (anode_0 ==  6 && anode_1 == 0 && btnC && en) begin
            celebrationState <= 1;
        end
        else if (en == 0) begin
            celebrationState <= 0;
        end
    end
    
    //Insantiate Imported Modules -----------------------

    Oled_Display myoled(
        .clk(CLK_6MHz25), 
        .reset(0),
        .frame_begin(frame_begin),
        .sending_pixels(sending_pixels),
        .sample_pixel(sample_pixel),
        .pixel_index(pixel_index),
        .pixel_data(oled_colour),
        .cs(JC[0]),
        .sdin(JC[1]),
        .sclk(JC[3]),
        .d_cn(JC[4]),
        .resn(JC[5]),
        .vccen(JC[6]),
        .pmoden(JC[7]));

    MouseCtl test_mouse(
        .clk(clk), 
        .rst(0),
        .xpos(xpos),
        .ypos(ypos),
        .zpos(zpos),
        .left(left_click),
        .middle(centre_click),
        .right(right_click),
        .new_event(newevent),
        .value(11'b0000_0000_000), //No clue what this is for
        .setx(0),
        .sety(0),
        .setmax_x(0),
        .setmax_y(0),
        .ps2_clk(PS2Clk),
        .ps2_data(PS2Data));

  
    paint paint_mod(
        .clk_100M(clk),
        .clk_25M(CLK_25MHz),
        .clk_12p5M(CLK_12MHz5),
        .clk_6p25M(CLK_6MHz25),
        .slow_clk(CLK_10KHz),
        .mouse_l(left_click), .reset(reset_canvas), .enable(1),  
        .mouse_x(xpos), .mouse_y(ypos),
        .pixel_index(pixel_index),
        .led(LED_Num_Paint),       
        .seg(paint_v_seg), 
        .colour_chooser(paint_colour_chooser)
    );     

    //---------------------------------------------------

endmodule
