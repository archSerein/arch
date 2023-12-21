#include <nvboard.h>
#include "Vselector.h"

void nvboard_bind_all_pins(Vselector* top) {
	nvboard_bind_pin( &top->led, BIND_RATE_SCR, BIND_DIR_OUT, 2, LD1, LD0);
	nvboard_bind_pin( &top->sw, BIND_RATE_SCR, BIND_DIR_IN , 10, SW9, SW8, SW7, SW6, SW5, SW4, SW3, SW2, SW1, SW0);
}
