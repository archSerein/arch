#include <nvboard.h>
#include "Vclockl.h"

void nvboard_bind_all_pins(Vclockl* top) {
	nvboard_bind_pin( &top->BTNL, BIND_RATE_SCR, BIND_DIR_IN , 1, BTNL);
	nvboard_bind_pin( &top->led, BIND_RATE_SCR, BIND_DIR_OUT, 16, LD15, LD14, LD13, LD12, LD11, LD10, LD9, LD8, LD7, LD6, LD5, LD4, LD3, LD2, LD1, LD0);
	nvboard_bind_pin( &top->sw, BIND_RATE_SCR, BIND_DIR_IN , 3, SW2, SW1, SW0);
	nvboard_bind_pin( &top->seg0, BIND_RATE_SCR, BIND_DIR_OUT, 7, SEG0A, SEG0B, SEG0C, SEG0D, SEG0E, SEG0F, SEG0G);
	nvboard_bind_pin( &top->seg1, BIND_RATE_SCR, BIND_DIR_OUT, 7, SEG1A, SEG1B, SEG1C, SEG1D, SEG1E, SEG1F, SEG1G);
	nvboard_bind_pin( &top->seg2, BIND_RATE_SCR, BIND_DIR_OUT, 7, SEG2A, SEG2B, SEG2C, SEG2D, SEG2E, SEG2F, SEG2G);
	nvboard_bind_pin( &top->seg3, BIND_RATE_SCR, BIND_DIR_OUT, 7, SEG3A, SEG3B, SEG3C, SEG3D, SEG3E, SEG3F, SEG3G);
	nvboard_bind_pin( &top->seg4, BIND_RATE_SCR, BIND_DIR_OUT, 7, SEG4A, SEG4B, SEG4C, SEG4D, SEG4E, SEG4F, SEG4G);
	nvboard_bind_pin( &top->seg5, BIND_RATE_SCR, BIND_DIR_OUT, 7, SEG5A, SEG5B, SEG5C, SEG5D, SEG5E, SEG5F, SEG5G);
}
