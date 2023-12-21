#include <nvboard.h>
#include "../build/obj_dir/Vselector.h"

static TOP_NAME selector;

void nvboard_bind_all_pins(Vselector* top);

void single_cycle() {
  selector.clk = 0;
  selector.eval();
  selector.clk = 1;
  selector.eval();
}

void reset(int n) {
  selector.rst = 1;
  while (n-- > 0)
    single_cycle();
  selector.rst = 0;
}

int main() {
  nvboard_bind_all_pins(&selector);
  nvboard_init();
  
  reset(10);
  
  while(1)
  {
    nvboard_update();
    single_cycle();
  }
  return 0;
}
