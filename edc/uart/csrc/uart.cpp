
#include <nvboard.h>
#include "../build/obj_dir/Vtop.h"

static TOP_NAME top; 

void nvboard_bind_all_pins(Vtop* top);

void single_cycle()
{
    top.clk = 0;
    top.eval();
    top.clk = 1;
    top.eval();
}

int main()
{
    nvboard_bind_all_pins(&top);
    nvboard_init();


    while(1)
    {
        nvboard_update();
        single_cycle();
    }
}

