#include <nvboard.h>
#include "../build/obj_dir/Vfsm.h"

static TOP_NAME fsm; 

void nvboard_bind_all_pins(Vfsm* top);

void single_cycle()
{
    fsm.clk = 0;
    fsm.eval();
    fsm.clk = 1;
    fsm.eval();
}

int main()
{
    nvboard_bind_all_pins(&fsm);
    nvboard_init();

    while(1)
    {
        nvboard_update();
        single_cycle();
    }
}
