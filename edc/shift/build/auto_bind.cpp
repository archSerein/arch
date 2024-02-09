#include <nvboard.h>
#include "Vshift.h"

void nvboard_bind_all_pins(Vshift* top) {
	nvboard_bind_pin( &top->en, 1, BTNL);
	nvboard_bind_pin( &top->in, 8, SW8, SW7, SW6, SW5, SW4, SW3, SW2, SW1);
	nvboard_bind_pin( &top->seg0, 7, SEG0A, SEG0B, SEG0C, SEG0D, SEG0E, SEG0F, SEG0G);
	nvboard_bind_pin( &top->seg1, 7, SEG1A, SEG1B, SEG1C, SEG1D, SEG1E, SEG1F, SEG1G);
}
