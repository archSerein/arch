#include <nvboard.h>
#include "Vcounter.h"

void nvboard_bind_all_pins(Vcounter* top) {
	nvboard_bind_pin( &top->led, BIND_RATE_SCR, BIND_DIR_OUT, 1, LD0);
	nvboard_bind_pin( &top->sw, BIND_RATE_SCR, BIND_DIR_IN , 2, SW1, SW0);
	nvboard_bind_pin( &top->seg0, BIND_RATE_SCR, BIND_DIR_OUT, 7, SEG0A, SEG0B, SEG0C, SEG0D, SEG0E, SEG0F, SEG0G);
	nvboard_bind_pin( &top->seg1, BIND_RATE_SCR, BIND_DIR_OUT, 7, SEG1A, SEG1B, SEG1C, SEG1D, SEG1E, SEG1F, SEG1G);
}
