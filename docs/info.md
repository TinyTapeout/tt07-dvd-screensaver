<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Displays a bouncing Tiny Tapeout logo on the screen.

## How to test

Connect to a VGA monitor. Set the following inputs to configure the design:
- `tile` (ui_in[0]) to repeat the logo and tile it across the screen,
- `color` (ui_in[1]) to enable color output.

## External hardware

[TinyVGA PMOD](https://github.com/mole99/tiny-vga)
