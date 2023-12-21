#include <nvboard.h>
#include "../build/obj_dir/Vcounter.h"

static TOP_NAME counter; 

void nvboard_bind_all_pins(Vcounter* top);

void single_cycle()
{
    counter.clk = 0;
    counter.eval();
    counter.clk = 1;
    counter.eval();
}

void reset(int n)
{
    counter.rst = 1;
    while(n--)
    {
        single_cycle();
    }
    counter.rst = 0;
}

int main()
{
    nvboard_bind_all_pins(&counter);
    nvboard_init();

    reset(10);

    while(1)
    {
        nvboard_update();
        single_cycle();
    }
}
