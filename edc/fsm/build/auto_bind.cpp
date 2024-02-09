#include <nvboard.h>
#include "Vfsm.h"

void nvboard_bind_all_pins(Vfsm* top) {
	nvboard_bind_pin( &top->led, BIND_RATE_SCR, BIND_DIR_OUT, 6, LD5, LD4, LD3, LD2, LD1, LD0);
	nvboard_bind_pin( &top->in, BIND_RATE_SCR, BIND_DIR_IN , 1, SW0);
}
