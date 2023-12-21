#include <nvboard.h>
#include "../build/obj_dir/Vadder.h"

static TOP_NAME adder; 

void nvboard_bind_all_pins(Vadder* top);

void single_cycle()
{
    adder.eval();
}

int main()
{
    nvboard_bind_all_pins(&adder);
    nvboard_init();


    while(1)
    {
        nvboard_update();
        single_cycle();
    }
}

