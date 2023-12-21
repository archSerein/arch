#include <nvboard.h>
#include "../build/obj_dir/Vencode.h"

static TOP_NAME encode; 

void nvboard_bind_all_pins(Vencode* top);

void single_cycle()
{
    encode.clk = 0;
    encode.eval();
    encode.clk = 1;
    encode.eval();
}

void reset(int n)
{
    encode.rst = 1;
    while(n--)
    {
        single_cycle();
    }
    encode.rst = 0;
}

int main()
{
    nvboard_bind_all_pins(&encode);
    nvboard_init();

    reset(10);

    while(1)
    {
        nvboard_update();
        single_cycle();
    }
}
