// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vregister8.h"
#include "Vregister8__Syms.h"

//============================================================
// Constructors

Vregister8::Vregister8(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vregister8__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , wr{vlSymsp->TOP.wr}
    , data{vlSymsp->TOP.data}
    , addr{vlSymsp->TOP.addr}
    , out{vlSymsp->TOP.out}
    , led{vlSymsp->TOP.led}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vregister8::Vregister8(const char* _vcname__)
    : Vregister8(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vregister8::~Vregister8() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vregister8___024root___eval_debug_assertions(Vregister8___024root* vlSelf);
#endif  // VL_DEBUG
void Vregister8___024root___eval_static(Vregister8___024root* vlSelf);
void Vregister8___024root___eval_initial(Vregister8___024root* vlSelf);
void Vregister8___024root___eval_settle(Vregister8___024root* vlSelf);
void Vregister8___024root___eval(Vregister8___024root* vlSelf);

void Vregister8::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vregister8::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vregister8___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vregister8___024root___eval_static(&(vlSymsp->TOP));
        Vregister8___024root___eval_initial(&(vlSymsp->TOP));
        Vregister8___024root___eval_settle(&(vlSymsp->TOP));
    }
    // MTask 0 start
    VL_DEBUG_IF(VL_DBG_MSGF("MTask0 starting\n"););
    Verilated::mtaskId(0);
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vregister8___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfThreadMTask(vlSymsp->__Vm_evalMsgQp);
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vregister8::eventsPending() { return false; }

uint64_t Vregister8::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vregister8::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vregister8___024root___eval_final(Vregister8___024root* vlSelf);

VL_ATTR_COLD void Vregister8::final() {
    Vregister8___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vregister8::hierName() const { return vlSymsp->name(); }
const char* Vregister8::modelName() const { return "Vregister8"; }
unsigned Vregister8::threads() const { return 1; }
