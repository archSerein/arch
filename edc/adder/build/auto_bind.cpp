#include <nvboard.h>
#include "Vadder.h"

void nvboard_bind_all_pins(Vadder* top) {
	nvboard_bind_pin( &top->led, BIND_RATE_SCR, BIND_DIR_OUT, 3, LD2, LD1, LD0);
	nvboard_bind_pin( &top->x, BIND_RATE_SCR, BIND_DIR_IN , 4, SW3, SW2, SW1, SW0);
	nvboard_bind_pin( &top->y, BIND_RATE_SCR, BIND_DIR_IN , 4, SW7, SW6, SW5, SW4);
	nvboard_bind_pin( &top->select, BIND_RATE_SCR, BIND_DIR_IN , 3, SW10, SW9, SW8);
	nvboard_bind_pin( &top->seg0, BIND_RATE_SCR, BIND_DIR_OUT, 7, SEG0A, SEG0B, SEG0C, SEG0D, SEG0E, SEG0F, SEG0G);
	nvboard_bind_pin( &top->seg1, BIND_RATE_SCR, BIND_DIR_OUT, 7, SEG1A, SEG1B, SEG1C, SEG1D, SEG1E, SEG1F, SEG1G);
}
