// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vshift.h"
#include "Vshift__Syms.h"

//============================================================
// Constructors

Vshift::Vshift(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vshift__Syms(contextp(), _vcname__, this)}
    , en{vlSymsp->TOP.en}
    , in{vlSymsp->TOP.in}
    , coda{vlSymsp->TOP.coda}
    , seg1{vlSymsp->TOP.seg1}
    , seg0{vlSymsp->TOP.seg0}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vshift::Vshift(const char* _vcname__)
    : Vshift(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vshift::~Vshift() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vshift___024root___eval_debug_assertions(Vshift___024root* vlSelf);
#endif  // VL_DEBUG
void Vshift___024root___eval_static(Vshift___024root* vlSelf);
void Vshift___024root___eval_initial(Vshift___024root* vlSelf);
void Vshift___024root___eval_settle(Vshift___024root* vlSelf);
void Vshift___024root___eval(Vshift___024root* vlSelf);

void Vshift::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vshift::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vshift___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vshift___024root___eval_static(&(vlSymsp->TOP));
        Vshift___024root___eval_initial(&(vlSymsp->TOP));
        Vshift___024root___eval_settle(&(vlSymsp->TOP));
    }
    // MTask 0 start
    VL_DEBUG_IF(VL_DBG_MSGF("MTask0 starting\n"););
    Verilated::mtaskId(0);
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vshift___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfThreadMTask(vlSymsp->__Vm_evalMsgQp);
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vshift::eventsPending() { return false; }

uint64_t Vshift::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vshift::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vshift___024root___eval_final(Vshift___024root* vlSelf);

VL_ATTR_COLD void Vshift::final() {
    Vshift___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vshift::hierName() const { return vlSymsp->name(); }
const char* Vshift::modelName() const { return "Vshift"; }
unsigned Vshift::threads() const { return 1; }
