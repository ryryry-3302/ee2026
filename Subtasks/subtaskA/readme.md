# Modules

## CustomClock
Create a clock that runs at frequency Fd. COUNT_STOP or CS can be calculated by 
$CS=\frac{100*10^6}{2*Fd} - 1$

```
module CustomClock(
    input CLOCK_IN,
    input [31:0] COUNT_STOP,
    output reg CLOCK_OUT = 0);
```

## drawRectangle
Draws a rectangle based on top left and bot right coordinates. Outputs whether pixel at pixel index lies in the rectangle

```
//drawRectangle drawRectangle_inst (
//    .pixel_index(pixel_index),
//    .X_coord_start(),
//    .Y_coord_start(),
//    .X_coord_end(),
//    .Y_coord_end(),
//    .draw()
//);

```

## PB_PressDetect
Outputs a rising `btn_press` signal if a button press on `btn` is detected. **200ms** of button presses are ignored after for debouncing.

```
module PB_PressDetect(
    input Clock_1kHz, //Counting
    input Clock_10kHz, //Detection
    input btn,
    output reg btn_press = 0
    );
```

# Top_student explanation

```
module Top_Student (
    input [15:0]sw, /// sw0 is used as enable/reset
    input clk,  ///basys
    input btnC, ///centre push button
    input btnD, /// down push button
    output [7:0]JB); /// port for oled
```

