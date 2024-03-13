# Subtask B Module

This README describes modules designed for subtask B that should also be useful for integration.

## CustomClock
Create a clock that runs at frequency Fd. COUNT_STOP or CS can be calculated by 
$CS=\frac{100*10^6}{2*Fd} - 1$

```
module CustomClock(
    input CLOCK_IN,
    input [31:0] COUNT_STOP,
    output reg CLOCK_OUT = 0);
```

## Draw_Square
Draws a square starting from the top left corner of `X_coord_start` and `Y_coord_start` given the length.
Takes in 13 bit `pixel_index` and outputs a 1 bit `draw` value which tells the oled whether to draw or not given the current pixel position.

```
module Draw_Square(
    input [12:0] pixel_index,
    input [7:0] X_coord_start,
    input [7:0] Y_coord_start,
    input [7:0] length,
    output draw
    );
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

