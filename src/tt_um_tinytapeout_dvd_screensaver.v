/*
 * Copyright (c) 2024 Tiny Tapeout LTD
 * SPDX-License-Identifier: Apache-2.0
 * Author: Uri Shaked
 */

`default_nettype none

module tt_um_tinytapeout_dvd_screensaver (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // VGA signals
  wire hsync;
  wire vsync;
  reg [1:0] R;
  reg [1:0] G;
  reg [1:0] B;
  wire video_active;
  wire [9:0] pix_x;
  wire [9:0] pix_y;

  // TinyVGA PMOD
  assign uo_out  = {hsync, B[0], G[0], R[0], vsync, B[1], G[1], R[1]};

  // Unused outputs assigned to 0.
  assign uio_out = 0;
  assign uio_oe  = 0;

  // Suppress unused signals warning
  wire _unused_ok = &{ena, ui_in, uio_in};

  reg [9:0] prev_y;

  vga_sync_generator vga_sync_gen (
      .clk(clk),
      .reset(~rst_n),
      .hsync(hsync),
      .vsync(vsync),
      .display_on(video_active),
      .hpos(pix_x),
      .vpos(pix_y)
  );

  reg [9:0] cx;
  reg [9:0] cy;
  reg cx_dir;
  reg cy_dir;

  wire pixel_value;

  wire [9:0] x = pix_x - cx;
  wire [9:0] y = pix_y - cy;
  wire logo_pixels = &{x[9:7], y[9:7]};

  bitmap_rom rom1 (
      .x(x[6:0]),
      .y(y[6:0]),
      .pixel(pixel_value)
  );

  // RGB output logic
  always @(posedge clk) begin
    if (~rst_n) begin
      R <= 0;
      G <= 0;
      B <= 0;
    end else begin
      R <= 0;
      G <= 0;
      B <= 0;
      if (video_active && logo_pixels) begin
        R <= {2{pixel_value}};
        G <= {2{pixel_value}};
        B <= {2{pixel_value}};
      end
    end
  end

  // Bouncing logic
  always @(posedge clk) begin
    if (~rst_n) begin
      cx <= 200;
      cy <= 200;
      cy_dir <= 0;
      cx_dir <= 1;
    end else begin
      prev_y <= pix_y;
      if (pix_y == 0 && prev_y != pix_y) begin
        cy <= cy + (cy_dir ? 1 : -1);
        cx <= cx + (cx_dir ? 1 : -1);
        if (cx - 1 == 128) begin
          cx_dir <= 1;
        end
        if (cy + 1 == 640 - 128) begin
          cx_dir <= 0;
        end
        if (cy - 1 == 128) begin
          cy_dir <= 1;
        end
        if (cy + 1 == 480 - 128) begin
          cy_dir <= 0;
        end
      end
    end
  end

endmodule
