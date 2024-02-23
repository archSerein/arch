#include <nvboard.h>
#include "Vadder.h"

void nvboard_bind_all_pins(Vadder* top) {
	nvboard_bind_pin( &top->led, 3, LD2, LD1, LD0);
	nvboard_bind_pin( &top->x, 4, SW3, SW2, SW1, SW0);
	nvboard_bind_pin( &top->y, 4, SW7, SW6, SW5, SW4);
	nvboard_bind_pin( &top->select, 3, SW10, SW9, SW8);
	nvboard_bind_pin( &top->seg0, 7, SEG0A, SEG0B, SEG0C, SEG0D, SEG0E, SEG0F, SEG0G);
	nvboard_bind_pin( &top->seg1, 7, SEG1A, SEG1B, SEG1C, SEG1D, SEG1E, SEG1F, SEG1G);
}
