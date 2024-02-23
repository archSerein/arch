#include <nvboard.h>
#include <Vtop.h>
#include <stdint.h>
#include <random>

static TOP_NAME top;

void nvboard_bind_all_pins(Vtop* top);

static void single_cycle() {
  top.clk = 0; top.eval();
  top.clk = 1; top.eval();
}

static void reset(int n) {
  top.rst = 1;
  while (n -- > 0) single_cycle();
  top.rst = 0;
}

void test()
{
  int i = 0;
  int32_t a = 0;
  int32_t b = 0;
  std::random_device rd;
  std::mt19937 gen(rd());

  std::uniform_int_distribution<> dis(0, 65536);
  while(i++ < 5) {
    a = dis(gen);
    b = dis(gen);
    top.a = a;
    top.b = b;
    nvboard_update();
    single_cycle();
    printf("%d %d %d %d %d %d\n", top.a, top.b, top.out, top.less, top.aluc, top.zero);
  }
}
int main() {
  nvboard_bind_all_pins(&top);
  nvboard_init();

  reset(10);

  top.aluc = 0;
  test();

  top.aluc = 8;
  test();
  
  top.aluc = 1;
  test();

  top.aluc = 2;
  test();
  
  top.aluc = 3;
  test();

  top.aluc = 4;
  test();

  top.aluc = 5;
  test();
  
  top.aluc = 7;
  test();
  while(1)
  {
    nvboard_update();
    single_cycle();
  }
}
