// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vencode.h"
#include "Vencode__Syms.h"

//============================================================
// Constructors

Vencode::Vencode(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vencode__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , sw{vlSymsp->TOP.sw}
    , en{vlSymsp->TOP.en}
    , rst{vlSymsp->TOP.rst}
    , led{vlSymsp->TOP.led}
    , y{vlSymsp->TOP.y}
    , seg0{vlSymsp->TOP.seg0}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vencode::Vencode(const char* _vcname__)
    : Vencode(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vencode::~Vencode() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vencode___024root___eval_debug_assertions(Vencode___024root* vlSelf);
#endif  // VL_DEBUG
void Vencode___024root___eval_static(Vencode___024root* vlSelf);
void Vencode___024root___eval_initial(Vencode___024root* vlSelf);
void Vencode___024root___eval_settle(Vencode___024root* vlSelf);
void Vencode___024root___eval(Vencode___024root* vlSelf);

void Vencode::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vencode::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vencode___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vencode___024root___eval_static(&(vlSymsp->TOP));
        Vencode___024root___eval_initial(&(vlSymsp->TOP));
        Vencode___024root___eval_settle(&(vlSymsp->TOP));
    }
    // MTask 0 start
    VL_DEBUG_IF(VL_DBG_MSGF("MTask0 starting\n"););
    Verilated::mtaskId(0);
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vencode___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfThreadMTask(vlSymsp->__Vm_evalMsgQp);
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vencode::eventsPending() { return false; }

uint64_t Vencode::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vencode::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vencode___024root___eval_final(Vencode___024root* vlSelf);

VL_ATTR_COLD void Vencode::final() {
    Vencode___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vencode::hierName() const { return vlSymsp->name(); }
const char* Vencode::modelName() const { return "Vencode"; }
unsigned Vencode::threads() const { return 1; }
