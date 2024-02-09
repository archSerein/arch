
#include <nvboard.h>
#include "../build/obj_dir/Vshift.h"

static TOP_NAME shift; 

void nvboard_bind_all_pins(Vshift* top);

void single_cycle()
{
    shift.eval();
}

int main()
{
    nvboard_bind_all_pins(&shift);
    nvboard_init();


    while(1)
    {
        nvboard_update();
        single_cycle();
    }
}

