module SevenSeg_Control(
    input clk,
    input en, //Write 0 to turn off 7 seg
    input [3:0] digit_0, //Write 3'b111 (15) to turn off digit
    input [3:0] digit_1,
    input [3:0] digit_2,
    input [3:0] digit_3,
    output reg dp,
    output reg [6:0] seg,
    output reg [3:0] an
);

    //00, 01, 10, 11
    reg [1:0] digit_pos = 2'b00;
    reg [3:0] display_num = 4'b000;
    
    /* //Was used for testing the code
    reg en = 0;
    reg [3:0] digit_0 = 4;
    reg [3:0] digit_1 = 15;
    reg [3:0] digit_2 = 0;
    reg [3:0] digit_3 = 1;
    */
    // made slower to remove bleed
    wire CLK_5KHz; //100kHz                    
    CustomClock clk10khz(.CLOCK_IN(clk),
                         .COUNT_STOP(32'd2500 - 1),
                         .CLOCK_OUT(CLK_5KHz));
    
    always @(posedge CLK_5KHz)
        begin
            digit_pos <= digit_pos + 1;
        end
    
    //Cylcing between different digits
    always @(CLK_5KHz)
        begin
            case(digit_pos)
                2'b00: display_num <= digit_0;
                2'b01: display_num <= digit_1;
                2'b10: display_num <= digit_2;
                2'b11: display_num <= digit_3;
            endcase
         end
    
    
     //Segements     
    always @(CLK_5KHz)
        begin   
           
            case (display_num)
                0: seg  <= 7'b1000000;
                1: seg  <= 7'b1111001;
                2: seg  <= 7'b0100100;
                3: seg  <= 7'b0110000;
                4: seg  <= 7'b0011001;
                5: seg  <= 7'b0010010;
                6: seg  <= 7'b0000010;
                7: seg  <= 7'b1111000;
                8: seg  <= 7'b0000000;
                9: seg  <= 7'b0010000;
                15: seg <= 7'b1111111; //Turn the segment off, display_num = 3'b111
                default : seg <= 7'b0001001; //Debugging
            endcase
        end
    
    //Annode
    always @(CLK_5KHz)
        begin
            if(!en)
                an <= 4'b1111;
            else
                begin
                case(digit_pos)
                    2'b00: an <= 4'b0111;
                    2'b01: an <= 4'b1011;
                    2'b10: an <= 4'b1101;
                    2'b11: an <= 4'b1110;
                endcase
        
                if(digit_pos == 2'b01)
                    dp <= 1'b0;
                else    
                    dp <= 1'b1;
                end
        end

endmodule