#include <nvboard.h>
#include "Vregister8.h"

void nvboard_bind_all_pins(Vregister8* top) {
	nvboard_bind_pin( &top->wr, BIND_RATE_SCR, BIND_DIR_IN , 1, SW4);
	nvboard_bind_pin( &top->addr, BIND_RATE_SCR, BIND_DIR_IN , 4, SW3, SW2, SW1, SW0);
	nvboard_bind_pin( &top->data, BIND_RATE_SCR, BIND_DIR_IN , 8, SW12, SW11, SW10, SW9, SW8, SW7, SW6, SW5);
	nvboard_bind_pin( &top->led, BIND_RATE_SCR, BIND_DIR_OUT, 8, LD7, LD6, LD5, LD4, LD3, LD2, LD1, LD0);
}
