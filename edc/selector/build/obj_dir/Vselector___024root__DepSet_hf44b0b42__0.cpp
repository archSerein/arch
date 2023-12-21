// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vselector.h for the primary calling header

#include "verilated.h"

#include "Vselector__Syms.h"
#include "Vselector___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vselector___024root___dump_triggers__act(Vselector___024root* vlSelf);
#endif  // VL_DEBUG

void Vselector___024root___eval_triggers__act(Vselector___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vselector__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vselector___024root___eval_triggers__act\n"); );
    // Body
    vlSelf->__VactTriggered.at(0U) = ((IData)(vlSelf->clk) 
                                      & (~ (IData)(vlSelf->__Vtrigrprev__TOP__clk)));
    vlSelf->__Vtrigrprev__TOP__clk = vlSelf->clk;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vselector___024root___dump_triggers__act(vlSelf);
    }
#endif
}
