
#include <nvboard.h>
#include "../build/obj_dir/Vps2keyboard.h"

static TOP_NAME ps2keyboard; 

void nvboard_bind_all_pins(Vps2keyboard* top);

void single_cycle()
{
    ps2keyboard.clk = 0;
    ps2keyboard.eval();
    ps2keyboard.clk = 1;
    ps2keyboard.eval();
}

int main()
{
    nvboard_bind_all_pins(&ps2keyboard);
    nvboard_init();


    while(1)
    {
        nvboard_update();
        single_cycle();
    }
}

