// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vram1.h"
#include "Vram1__Syms.h"

//============================================================
// Constructors

Vram1::Vram1(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vram1__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , seg0{vlSymsp->TOP.seg0}
    , seg1{vlSymsp->TOP.seg1}
    , en{vlSymsp->TOP.en}
    , inputaddr{vlSymsp->TOP.inputaddr}
    , outputaddr{vlSymsp->TOP.outputaddr}
    , in{vlSymsp->TOP.in}
    , out{vlSymsp->TOP.out}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vram1::Vram1(const char* _vcname__)
    : Vram1(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vram1::~Vram1() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vram1___024root___eval_debug_assertions(Vram1___024root* vlSelf);
#endif  // VL_DEBUG
void Vram1___024root___eval_static(Vram1___024root* vlSelf);
void Vram1___024root___eval_initial(Vram1___024root* vlSelf);
void Vram1___024root___eval_settle(Vram1___024root* vlSelf);
void Vram1___024root___eval(Vram1___024root* vlSelf);

void Vram1::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vram1::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vram1___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vram1___024root___eval_static(&(vlSymsp->TOP));
        Vram1___024root___eval_initial(&(vlSymsp->TOP));
        Vram1___024root___eval_settle(&(vlSymsp->TOP));
    }
    // MTask 0 start
    VL_DEBUG_IF(VL_DBG_MSGF("MTask0 starting\n"););
    Verilated::mtaskId(0);
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vram1___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfThreadMTask(vlSymsp->__Vm_evalMsgQp);
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vram1::eventsPending() { return false; }

uint64_t Vram1::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vram1::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vram1___024root___eval_final(Vram1___024root* vlSelf);

VL_ATTR_COLD void Vram1::final() {
    Vram1___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vram1::hierName() const { return vlSymsp->name(); }
const char* Vram1::modelName() const { return "Vram1"; }
unsigned Vram1::threads() const { return 1; }
