// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vclockl.h for the primary calling header

#include "verilated.h"

#include "Vclockl__Syms.h"
#include "Vclockl___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vclockl___024root___dump_triggers__stl(Vclockl___024root* vlSelf);
#endif  // VL_DEBUG

VL_ATTR_COLD void Vclockl___024root___eval_triggers__stl(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___eval_triggers__stl\n"); );
    // Body
    vlSelf->__VstlTriggered.at(0U) = (0U == vlSelf->__VstlIterCount);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vclockl___024root___dump_triggers__stl(vlSelf);
    }
#endif
}
