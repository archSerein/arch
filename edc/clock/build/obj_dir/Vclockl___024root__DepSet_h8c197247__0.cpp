// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vclockl.h for the primary calling header

#include "verilated.h"

#include "Vclockl__Syms.h"
#include "Vclockl___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vclockl___024root___dump_triggers__act(Vclockl___024root* vlSelf);
#endif  // VL_DEBUG

void Vclockl___024root___eval_triggers__act(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___eval_triggers__act\n"); );
    // Body
    vlSelf->__VactTriggered.at(0U) = ((IData)(vlSelf->clk) 
                                      & (~ (IData)(vlSelf->__Vtrigrprev__TOP__clk)));
    vlSelf->__VactTriggered.at(1U) = ((IData)(vlSelf->clockl__DOT__clk_m) 
                                      & (~ (IData)(vlSelf->__Vtrigrprev__TOP__clockl__DOT__clk_m)));
    vlSelf->__VactTriggered.at(2U) = ((IData)(vlSelf->clockl__DOT__clk_c) 
                                      != (IData)(vlSelf->__Vtrigrprev__TOP__clockl__DOT__clk_c));
    vlSelf->__Vtrigrprev__TOP__clk = vlSelf->clk;
    vlSelf->__Vtrigrprev__TOP__clockl__DOT__clk_m = vlSelf->clockl__DOT__clk_m;
    vlSelf->__Vtrigrprev__TOP__clockl__DOT__clk_c = vlSelf->clockl__DOT__clk_c;
    if (VL_UNLIKELY((1U & (~ (IData)(vlSelf->__VactDidInit))))) {
        vlSelf->__VactDidInit = 1U;
        vlSelf->__VactTriggered.at(2U) = 1U;
    }
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vclockl___024root___dump_triggers__act(vlSelf);
    }
#endif
}
