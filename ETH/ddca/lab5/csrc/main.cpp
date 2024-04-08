#include "../obj_dir/Valu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>
#include <random>

VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;

static Valu* alu;

void step_and_dump_wave(){
  alu->eval();
  contextp->timeInc(1);
  tfp->dump(contextp->time());
}

void sim_exit(){
  step_and_dump_wave();
  tfp->close();
}

void sim_init()
{
    contextp = new VerilatedContext;
    tfp = new VerilatedVcdC;
    alu = new Valu;
    contextp->traceEverOn(true);
    alu->trace(tfp, 0);
    tfp->open("alu.vcd");
}

int main() {
    sim_init();
    
    // 创建一个随机设备
    std::random_device rd;

    // 使用随机设备来种子一个随机数生成器
    std::mt19937 gen(rd());

    // 定义一个范围在 [0, 1000000] 之间的均匀分布的整数
    std::uniform_int_distribution<> distInt(0, 100000000);
    int i = 0;
    while(i ++ < 10000)
    {
        uint32_t a = distInt(gen);
        uint32_t b = distInt(gen);

        alu->x = a;
        alu->y = b;
        alu->fn = 0b0000;
        step_and_dump_wave();
        bool cal = (a + b) == alu->out;
        printf("%u + %u == %u\t%s\n", alu->x, alu->y, alu->out, cal ? "true" : "fasle");
    }

    sim_exit();
}
