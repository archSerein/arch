// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vencode.h for the primary calling header

#include "verilated.h"

#include "Vencode___024root.h"

VL_ATTR_COLD void Vencode___024root___eval_static(Vencode___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vencode__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vencode___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vencode___024root___eval_initial(Vencode___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vencode__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vencode___024root___eval_initial\n"); );
    // Body
    vlSelf->__Vtrigrprev__TOP__clk = vlSelf->clk;
}

VL_ATTR_COLD void Vencode___024root___eval_final(Vencode___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vencode__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vencode___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vencode___024root___eval_triggers__stl(Vencode___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vencode___024root___dump_triggers__stl(Vencode___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD void Vencode___024root___eval_stl(Vencode___024root* vlSelf);

VL_ATTR_COLD void Vencode___024root___eval_settle(Vencode___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vencode__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vencode___024root___eval_settle\n"); );
    // Init
    CData/*0:0*/ __VstlContinue;
    // Body
    vlSelf->__VstlIterCount = 0U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        __VstlContinue = 0U;
        Vencode___024root___eval_triggers__stl(vlSelf);
        if (vlSelf->__VstlTriggered.any()) {
            __VstlContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VstlIterCount))) {
#ifdef VL_DEBUG
                Vencode___024root___dump_triggers__stl(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/encoder/vsrc/encode.v", 1, "", "Settle region did not converge.");
            }
            vlSelf->__VstlIterCount = ((IData)(1U) 
                                       + vlSelf->__VstlIterCount);
            Vencode___024root___eval_stl(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vencode___024root___dump_triggers__stl(Vencode___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vencode__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vencode___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VstlTriggered.at(0U)) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

void Vencode___024root___ico_sequent__TOP__0(Vencode___024root* vlSelf);

VL_ATTR_COLD void Vencode___024root___eval_stl(Vencode___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vencode__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vencode___024root___eval_stl\n"); );
    // Body
    if (vlSelf->__VstlTriggered.at(0U)) {
        Vencode___024root___ico_sequent__TOP__0(vlSelf);
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vencode___024root___dump_triggers__ico(Vencode___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vencode__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vencode___024root___dump_triggers__ico\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VicoTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VicoTriggered.at(0U)) {
        VL_DBG_MSGF("         'ico' region trigger index 0 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vencode___024root___dump_triggers__act(Vencode___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vencode__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vencode___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VactTriggered.at(0U)) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vencode___024root___dump_triggers__nba(Vencode___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vencode__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vencode___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VnbaTriggered.at(0U)) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vencode___024root___ctor_var_reset(Vencode___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vencode__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vencode___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->sw = 0;
    vlSelf->en = 0;
    vlSelf->clk = 0;
    vlSelf->rst = 0;
    vlSelf->led = 0;
    vlSelf->y = 0;
    vlSelf->seg0 = 0;
    vlSelf->__Vtrigrprev__TOP__clk = 0;
}
