#include <nvboard.h>
#include "Vencode.h"

void nvboard_bind_all_pins(Vencode* top) {
	nvboard_bind_pin( &top->led, BIND_RATE_SCR, BIND_DIR_OUT, 5, LD4, LD3, LD2, LD1, LD0);
	nvboard_bind_pin( &top->sw, BIND_RATE_SCR, BIND_DIR_IN , 8, SW7, SW6, SW5, SW4, SW3, SW2, SW1, SW0);
	nvboard_bind_pin( &top->en, BIND_RATE_SCR, BIND_DIR_IN , 1, SW8);
	nvboard_bind_pin( &top->seg0, BIND_RATE_SCR, BIND_DIR_OUT, 7, SEG0A, SEG0B, SEG0C, SEG0D, SEG0E, SEG0F, SEG0G);
}
