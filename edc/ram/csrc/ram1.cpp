
#include <nvboard.h>
#include "../build/obj_dir/Vram1.h"

static TOP_NAME ram1; 

void nvboard_bind_all_pins(Vram1* top);

void single_cycle()
{
    ram1.clk = 0;
    ram1.eval();
    ram1.clk = 1;
    ram1.eval();
}

int main()
{
    nvboard_bind_all_pins(&ram1);
    nvboard_init();


    while(1)
    {
        nvboard_update();
        single_cycle();
    }
}

