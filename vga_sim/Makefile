# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2024, Tiny Tapeout LTD
# Author: Uri Shaked

SRC_DIR = $(PWD)/../src
PROJECT_SOURCES = tt_um_tinytapeout_dvd_screensaver.v bitmap_rom.v vga_sync_generator.v palette.v
TOP_MODULE = tt_um_tinytapeout_dvd_screensaver

VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))
CFLAGS = -O3 -Iobj_dir -I/usr/share/verilator/include
LDFLAGS = -lSDL2

all: obj_dir/V$(TOP_MODULE).h
	make -C obj_dir -f V$(TOP_MODULE).mk

obj_dir/V$(TOP_MODULE).h : $(VERILOG_SOURCES) main.cpp
	verilator --cc $(VERILOG_SOURCES) --exe main.cpp -CFLAGS "$(CFLAGS)" -LDFLAGS "$(LDFLAGS)"

sim: all
	obj_dir/V$(TOP_MODULE)

clean:
	rm -rf obj_dir

.phony: all clean
