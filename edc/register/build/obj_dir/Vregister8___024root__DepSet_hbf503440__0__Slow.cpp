// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vregister8.h for the primary calling header

#include "verilated.h"

#include "Vregister8___024root.h"

VL_ATTR_COLD void Vregister8___024root___eval_static(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vregister8___024root___eval_initial__TOP(Vregister8___024root* vlSelf);

VL_ATTR_COLD void Vregister8___024root___eval_initial(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___eval_initial\n"); );
    // Body
    Vregister8___024root___eval_initial__TOP(vlSelf);
    vlSelf->__Vtrigrprev__TOP__clk = vlSelf->clk;
}

extern const VlWide<12>/*383:0*/ Vregister8__ConstPool__CONST_h195651f6_0;

VL_ATTR_COLD void Vregister8___024root___eval_initial__TOP(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___eval_initial__TOP\n"); );
    // Body
    VL_READMEM_N(true, 8, 16, 0, VL_CVT_PACK_STR_NW(12, Vregister8__ConstPool__CONST_h195651f6_0)
                 ,  &(vlSelf->register8__DOT__ram), 0U
                 , 0xfU);
}

VL_ATTR_COLD void Vregister8___024root___eval_final(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vregister8___024root___eval_triggers__stl(Vregister8___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vregister8___024root___dump_triggers__stl(Vregister8___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD void Vregister8___024root___eval_stl(Vregister8___024root* vlSelf);

VL_ATTR_COLD void Vregister8___024root___eval_settle(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___eval_settle\n"); );
    // Init
    CData/*0:0*/ __VstlContinue;
    // Body
    vlSelf->__VstlIterCount = 0U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        __VstlContinue = 0U;
        Vregister8___024root___eval_triggers__stl(vlSelf);
        if (vlSelf->__VstlTriggered.any()) {
            __VstlContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VstlIterCount))) {
#ifdef VL_DEBUG
                Vregister8___024root___dump_triggers__stl(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/register/vsrc/register8.v", 1, "", "Settle region did not converge.");
            }
            vlSelf->__VstlIterCount = ((IData)(1U) 
                                       + vlSelf->__VstlIterCount);
            Vregister8___024root___eval_stl(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vregister8___024root___dump_triggers__stl(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VstlTriggered.at(0U)) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

void Vregister8___024root___ico_sequent__TOP__0(Vregister8___024root* vlSelf);

VL_ATTR_COLD void Vregister8___024root___eval_stl(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___eval_stl\n"); );
    // Body
    if (vlSelf->__VstlTriggered.at(0U)) {
        Vregister8___024root___ico_sequent__TOP__0(vlSelf);
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vregister8___024root___dump_triggers__ico(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___dump_triggers__ico\n"); );
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
VL_ATTR_COLD void Vregister8___024root___dump_triggers__act(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___dump_triggers__act\n"); );
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
VL_ATTR_COLD void Vregister8___024root___dump_triggers__nba(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VnbaTriggered.at(0U)) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vregister8___024root___ctor_var_reset(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = 0;
    vlSelf->wr = 0;
    vlSelf->data = 0;
    vlSelf->addr = 0;
    vlSelf->out = 0;
    vlSelf->led = 0;
    for (int __Vi0 = 0; __Vi0 < 16; ++__Vi0) {
        vlSelf->register8__DOT__ram[__Vi0] = 0;
    }
    vlSelf->__Vtrigrprev__TOP__clk = 0;
}
