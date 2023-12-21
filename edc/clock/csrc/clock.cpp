#include <nvboard.h>
#include "../build/obj_dir/Vclockl.h"

static TOP_NAME clockl; 

void nvboard_bind_all_pins(Vclockl* top);

void single_cycle()
{
    clockl.clk = 0;
    clockl.eval();
    clockl.clk = 1;
    clockl.eval();
}

void reset(int n)
{
    clockl.rst = 1;
    while(n--)
    {
        single_cycle();
    }
    clockl.rst = 0;
}

int main()
{
    nvboard_bind_all_pins(&clockl);
    nvboard_init();

    reset(10);

    while(1)
    {
        nvboard_update();
        single_cycle();
    }
}
