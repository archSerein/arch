// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vvga.h"
#include "Vvga__Syms.h"

//============================================================
// Constructors

Vvga::Vvga(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vvga__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , rst{vlSymsp->TOP.rst}
    , VGA_HSYNC{vlSymsp->TOP.VGA_HSYNC}
    , VGA_VSYNC{vlSymsp->TOP.VGA_VSYNC}
    , VGA_BLANK_N{vlSymsp->TOP.VGA_BLANK_N}
    , vga_r{vlSymsp->TOP.vga_r}
    , vga_g{vlSymsp->TOP.vga_g}
    , vga_b{vlSymsp->TOP.vga_b}
    , h_addr{vlSymsp->TOP.h_addr}
    , v_addr{vlSymsp->TOP.v_addr}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vvga::Vvga(const char* _vcname__)
    : Vvga(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vvga::~Vvga() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vvga___024root___eval_debug_assertions(Vvga___024root* vlSelf);
#endif  // VL_DEBUG
void Vvga___024root___eval_static(Vvga___024root* vlSelf);
void Vvga___024root___eval_initial(Vvga___024root* vlSelf);
void Vvga___024root___eval_settle(Vvga___024root* vlSelf);
void Vvga___024root___eval(Vvga___024root* vlSelf);

void Vvga::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vvga::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vvga___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vvga___024root___eval_static(&(vlSymsp->TOP));
        Vvga___024root___eval_initial(&(vlSymsp->TOP));
        Vvga___024root___eval_settle(&(vlSymsp->TOP));
    }
    // MTask 0 start
    VL_DEBUG_IF(VL_DBG_MSGF("MTask0 starting\n"););
    Verilated::mtaskId(0);
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vvga___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfThreadMTask(vlSymsp->__Vm_evalMsgQp);
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vvga::eventsPending() { return false; }

uint64_t Vvga::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vvga::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vvga___024root___eval_final(Vvga___024root* vlSelf);

VL_ATTR_COLD void Vvga::final() {
    Vvga___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vvga::hierName() const { return vlSymsp->name(); }
const char* Vvga::modelName() const { return "Vvga"; }
unsigned Vvga::threads() const { return 1; }
