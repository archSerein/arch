#include <nvboard.h>
#include "Vram1.h"

void nvboard_bind_all_pins(Vram1* top) {
	nvboard_bind_pin( &top->en, BIND_RATE_SCR, BIND_DIR_IN , 1, SW0);
	nvboard_bind_pin( &top->inputaddr, BIND_RATE_SCR, BIND_DIR_IN , 4, SW4, SW3, SW2, SW1);
	nvboard_bind_pin( &top->outputaddr, BIND_RATE_SCR, BIND_DIR_IN , 4, SW4, SW3, SW2, SW1);
	nvboard_bind_pin( &top->in, BIND_RATE_SCR, BIND_DIR_IN , 8, SW12, SW11, SW10, SW9, SW8, SW7, SW6, SW5);
	nvboard_bind_pin( &top->seg0, BIND_RATE_SCR, BIND_DIR_OUT, 7, SEG0A, SEG0B, SEG0C, SEG0D, SEG0E, SEG0F, SEG0G);
	nvboard_bind_pin( &top->seg1, BIND_RATE_SCR, BIND_DIR_OUT, 7, SEG1A, SEG1B, SEG1C, SEG1D, SEG1E, SEG1F, SEG1G);
}
