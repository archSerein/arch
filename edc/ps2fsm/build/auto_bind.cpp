#include <nvboard.h>
#include "Vps2keyboard.h"

void nvboard_bind_all_pins(Vps2keyboard* top) {
	nvboard_bind_pin( &top->clrn, 1, SW0);
	nvboard_bind_pin( &top->ready, 1, LD0);
	nvboard_bind_pin( &top->overflow, 1, LD1);
	nvboard_bind_pin( &top->led, 8, LD9, LD8, LD7, LD6, LD5, LD4, LD3, LD2);
	nvboard_bind_pin( &top->seg0, 7, SEG0A, SEG0B, SEG0C, SEG0D, SEG0E, SEG0F, SEG0G);
	nvboard_bind_pin( &top->seg1, 7, SEG1A, SEG1B, SEG1C, SEG1D, SEG1E, SEG1F, SEG1G);
	nvboard_bind_pin( &top->seg2, 7, SEG2A, SEG2B, SEG2C, SEG2D, SEG2E, SEG2F, SEG2G);
	nvboard_bind_pin( &top->seg3, 7, SEG3A, SEG3B, SEG3C, SEG3D, SEG3E, SEG3F, SEG3G);
	nvboard_bind_pin( &top->seg4, 7, SEG4A, SEG4B, SEG4C, SEG4D, SEG4E, SEG4F, SEG4G);
	nvboard_bind_pin( &top->seg5, 7, SEG5A, SEG5B, SEG5C, SEG5D, SEG5E, SEG5F, SEG5G);
	nvboard_bind_pin( &top->ps2_clk, 1, PS2_CLK);
	nvboard_bind_pin( &top->ps2_data, 1, PS2_DAT);
}
