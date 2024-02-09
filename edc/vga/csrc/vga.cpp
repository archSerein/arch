
#include <nvboard.h>
#include "../build/obj_dir/Vvga.h"

static TOP_NAME vga; 

void nvboard_bind_all_pins(Vvga* top);

void single_cycle()
{
    vga.clk = 0;
    vga.eval();
    vga.clk = 1;
    vga.eval();
}

int main()
{
    nvboard_bind_all_pins(&vga);
    nvboard_init();


    while(1)
    {
        nvboard_update();
        single_cycle();
    }
}

