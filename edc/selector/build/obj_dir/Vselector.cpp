// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vselector.h"
#include "Vselector__Syms.h"

//============================================================
// Constructors

Vselector::Vselector(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vselector__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , rst{vlSymsp->TOP.rst}
    , led{vlSymsp->TOP.led}
    , sw{vlSymsp->TOP.sw}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vselector::Vselector(const char* _vcname__)
    : Vselector(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vselector::~Vselector() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vselector___024root___eval_debug_assertions(Vselector___024root* vlSelf);
#endif  // VL_DEBUG
void Vselector___024root___eval_static(Vselector___024root* vlSelf);
void Vselector___024root___eval_initial(Vselector___024root* vlSelf);
void Vselector___024root___eval_settle(Vselector___024root* vlSelf);
void Vselector___024root___eval(Vselector___024root* vlSelf);

void Vselector::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vselector::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vselector___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vselector___024root___eval_static(&(vlSymsp->TOP));
        Vselector___024root___eval_initial(&(vlSymsp->TOP));
        Vselector___024root___eval_settle(&(vlSymsp->TOP));
    }
    // MTask 0 start
    VL_DEBUG_IF(VL_DBG_MSGF("MTask0 starting\n"););
    Verilated::mtaskId(0);
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vselector___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfThreadMTask(vlSymsp->__Vm_evalMsgQp);
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vselector::eventsPending() { return false; }

uint64_t Vselector::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vselector::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vselector___024root___eval_final(Vselector___024root* vlSelf);

VL_ATTR_COLD void Vselector::final() {
    Vselector___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vselector::hierName() const { return vlSymsp->name(); }
const char* Vselector::modelName() const { return "Vselector"; }
unsigned Vselector::threads() const { return 1; }
