# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2024 Uri Shaked

from PIL import Image

# Open the image
img = Image.open("tt_logo_128.png")

# Convert the image to grayscale
img = img.convert("L")
pix = bytearray(128 * 128 // 8)

for y in range(img.height):
    for x in range(img.width):
        color = img.getpixel((x, y))
        if color < 128:
            pix[y * 16 + x // 8] |= 1 << (x % 8)

module = []
module.append("module bitmap_rom (")
module.append("    input wire [6:0] x,")
module.append("    input wire [6:0] y,")
module.append("    output wire pixel")
module.append(");")
module.append("")
module.append("  reg [7:0] mem[2047:0];")
module.append("  initial begin")
for i, byte in enumerate(pix):
    module.append(f"    mem[{i}] = 8'h{byte:02x};")
module.append("  end")
module.append("")
module.append("  wire [10:0] addr = {y[6:0], x[6:3]};")
module.append("  assign pixel = mem[addr][x&7];")
module.append("")
module.append("endmodule")
module.append("")

with open("../src/bitmap_rom.v", "w") as f:
    f.write("\n".join(module))
