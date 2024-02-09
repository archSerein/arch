// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vfsm.h"
#include "Vfsm__Syms.h"

//============================================================
// Constructors

Vfsm::Vfsm(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vfsm__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , rst{vlSymsp->TOP.rst}
    , in{vlSymsp->TOP.in}
    , u{vlSymsp->TOP.u}
    , v{vlSymsp->TOP.v}
    , led{vlSymsp->TOP.led}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vfsm::Vfsm(const char* _vcname__)
    : Vfsm(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vfsm::~Vfsm() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vfsm___024root___eval_debug_assertions(Vfsm___024root* vlSelf);
#endif  // VL_DEBUG
void Vfsm___024root___eval_static(Vfsm___024root* vlSelf);
void Vfsm___024root___eval_initial(Vfsm___024root* vlSelf);
void Vfsm___024root___eval_settle(Vfsm___024root* vlSelf);
void Vfsm___024root___eval(Vfsm___024root* vlSelf);

void Vfsm::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vfsm::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vfsm___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vfsm___024root___eval_static(&(vlSymsp->TOP));
        Vfsm___024root___eval_initial(&(vlSymsp->TOP));
        Vfsm___024root___eval_settle(&(vlSymsp->TOP));
    }
    // MTask 0 start
    VL_DEBUG_IF(VL_DBG_MSGF("MTask0 starting\n"););
    Verilated::mtaskId(0);
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vfsm___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfThreadMTask(vlSymsp->__Vm_evalMsgQp);
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vfsm::eventsPending() { return false; }

uint64_t Vfsm::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vfsm::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vfsm___024root___eval_final(Vfsm___024root* vlSelf);

VL_ATTR_COLD void Vfsm::final() {
    Vfsm___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vfsm::hierName() const { return vlSymsp->name(); }
const char* Vfsm::modelName() const { return "Vfsm"; }
unsigned Vfsm::threads() const { return 1; }
