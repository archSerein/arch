#include <nvboard.h>
#include "Vtop.h"

void nvboard_bind_all_pins(Vtop* top) {
	nvboard_bind_pin( &top->zero, 1, LD0);
	nvboard_bind_pin( &top->less, 1, LD1);
	nvboard_bind_pin( &top->aluc, 4, SW3, SW2, SW1, SW0);
	nvboard_bind_pin( &top->seg0, 7, SEG0A, SEG0B, SEG0C, SEG0D, SEG0E, SEG0F, SEG0G);
	nvboard_bind_pin( &top->seg1, 7, SEG1A, SEG1B, SEG1C, SEG1D, SEG1E, SEG1F, SEG1G);
	nvboard_bind_pin( &top->seg2, 7, SEG2A, SEG2B, SEG2C, SEG2D, SEG2E, SEG2F, SEG2G);
	nvboard_bind_pin( &top->seg3, 7, SEG3A, SEG3B, SEG3C, SEG3D, SEG3E, SEG3F, SEG3G);
	nvboard_bind_pin( &top->seg4, 7, SEG4A, SEG4B, SEG4C, SEG4D, SEG4E, SEG4F, SEG4G);
	nvboard_bind_pin( &top->seg5, 7, SEG5A, SEG5B, SEG5C, SEG5D, SEG5E, SEG5F, SEG5G);
	nvboard_bind_pin( &top->seg6, 7, SEG6A, SEG6B, SEG6C, SEG6D, SEG6E, SEG6F, SEG6G);
	nvboard_bind_pin( &top->seg7, 7, SEG7A, SEG7B, SEG7C, SEG7D, SEG7E, SEG7F, SEG7G);
}
