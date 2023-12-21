// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vcounter.h"
#include "Vcounter__Syms.h"

//============================================================
// Constructors

Vcounter::Vcounter(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vcounter__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , rst{vlSymsp->TOP.rst}
    , sw{vlSymsp->TOP.sw}
    , seg0{vlSymsp->TOP.seg0}
    , seg1{vlSymsp->TOP.seg1}
    , led{vlSymsp->TOP.led}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vcounter::Vcounter(const char* _vcname__)
    : Vcounter(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vcounter::~Vcounter() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vcounter___024root___eval_debug_assertions(Vcounter___024root* vlSelf);
#endif  // VL_DEBUG
void Vcounter___024root___eval_static(Vcounter___024root* vlSelf);
void Vcounter___024root___eval_initial(Vcounter___024root* vlSelf);
void Vcounter___024root___eval_settle(Vcounter___024root* vlSelf);
void Vcounter___024root___eval(Vcounter___024root* vlSelf);

void Vcounter::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vcounter::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vcounter___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vcounter___024root___eval_static(&(vlSymsp->TOP));
        Vcounter___024root___eval_initial(&(vlSymsp->TOP));
        Vcounter___024root___eval_settle(&(vlSymsp->TOP));
    }
    // MTask 0 start
    VL_DEBUG_IF(VL_DBG_MSGF("MTask0 starting\n"););
    Verilated::mtaskId(0);
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vcounter___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfThreadMTask(vlSymsp->__Vm_evalMsgQp);
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vcounter::eventsPending() { return false; }

uint64_t Vcounter::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vcounter::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vcounter___024root___eval_final(Vcounter___024root* vlSelf);

VL_ATTR_COLD void Vcounter::final() {
    Vcounter___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vcounter::hierName() const { return vlSymsp->name(); }
const char* Vcounter::modelName() const { return "Vcounter"; }
unsigned Vcounter::threads() const { return 1; }
