module drawTriangle(
    input [12:0] pixel_index,
    input [7:0] center_X,
    input [7:0] center_Y,
    input [7:0] side_length,
    output reg draw
);

    wire [7:0] curr_X;
    wire [7:0] curr_Y;
    
    // Convert pixel_index to X and Y coordinates
    indexToXY curr_coord(
        .pixel_index(pixel_index),
        .X_coord(curr_X),
        .Y_coord(curr_Y)
    );
    
    // Calculate half side length and height of the equilateral triangle
    wire [15:0] half_side;
    wire [15:0] height;
    assign half_side = side_length >> 1; // Divide by 2 using right shift
    assign height = ((3 * side_length) >> 1); // Calculate 3/2 of side_length
    
    // Check if pixel is within the equilateral triangle
    always @(*) begin
        if (curr_X >= center_X - half_side && curr_X <= center_X + half_side &&
            curr_Y >= center_Y - height && curr_Y <= center_Y + height &&
            curr_Y <= (curr_X - center_X) + center_Y &&
            curr_Y >= -(curr_X - center_X) + center_Y) begin // Fix: Changed <= to >= in the last condition
            draw <= 1'b1;
        end else begin
            draw <= 1'b0;
        end
    end
endmodule