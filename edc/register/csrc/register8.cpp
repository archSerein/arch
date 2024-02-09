#include <nvboard.h>
#include "../build/obj_dir/Vregister8.h"

static TOP_NAME register8; 

void nvboard_bind_all_pins(Vregister8* top);

void single_cycle()
{
    register8.clk = 0;
    register8.eval();
    register8.clk = 1;
    register8.eval();
}


int main()
{
    nvboard_bind_all_pins(&register8);
    nvboard_init();


    while(1)
    {
        nvboard_update();
        single_cycle();
    }
}
