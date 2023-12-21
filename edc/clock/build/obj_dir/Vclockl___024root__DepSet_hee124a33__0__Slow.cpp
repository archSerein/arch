// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vclockl.h for the primary calling header

#include "verilated.h"

#include "Vclockl___024root.h"

VL_ATTR_COLD void Vclockl___024root___eval_static(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vclockl___024root___eval_initial__TOP(Vclockl___024root* vlSelf);

VL_ATTR_COLD void Vclockl___024root___eval_initial(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___eval_initial\n"); );
    // Body
    Vclockl___024root___eval_initial__TOP(vlSelf);
    vlSelf->__Vtrigrprev__TOP__clk = vlSelf->clk;
    vlSelf->__Vtrigrprev__TOP__clockl__DOT__clk_m = vlSelf->clockl__DOT__clk_m;
    vlSelf->__Vtrigrprev__TOP__clockl__DOT__clk_c = vlSelf->clockl__DOT__clk_c;
}

VL_ATTR_COLD void Vclockl___024root___eval_initial__TOP(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___eval_initial__TOP\n"); );
    // Body
    vlSelf->clockl__DOT__x = 0U;
    vlSelf->clockl__DOT__y = 0U;
    vlSelf->clockl__DOT__a = 0U;
    vlSelf->clockl__DOT__b = 0U;
    vlSelf->clockl__DOT__c = 0U;
    vlSelf->clockl__DOT__d = 0U;
    vlSelf->clockl__DOT__hour = 0U;
    vlSelf->clockl__DOT__min = 0U;
    vlSelf->clockl__DOT__sec = 0U;
    vlSelf->clockl__DOT__count_clk_m = 0U;
    vlSelf->clockl__DOT__count_clk_c = 0U;
    vlSelf->clockl__DOT__alarm = 0U;
}

VL_ATTR_COLD void Vclockl___024root___eval_final(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vclockl___024root___eval_triggers__stl(Vclockl___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vclockl___024root___dump_triggers__stl(Vclockl___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD void Vclockl___024root___eval_stl(Vclockl___024root* vlSelf);

VL_ATTR_COLD void Vclockl___024root___eval_settle(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___eval_settle\n"); );
    // Init
    CData/*0:0*/ __VstlContinue;
    // Body
    vlSelf->__VstlIterCount = 0U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        __VstlContinue = 0U;
        Vclockl___024root___eval_triggers__stl(vlSelf);
        if (vlSelf->__VstlTriggered.any()) {
            __VstlContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VstlIterCount))) {
#ifdef VL_DEBUG
                Vclockl___024root___dump_triggers__stl(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/clock/vsrc/clockl.v", 1, "", "Settle region did not converge.");
            }
            vlSelf->__VstlIterCount = ((IData)(1U) 
                                       + vlSelf->__VstlIterCount);
            Vclockl___024root___eval_stl(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vclockl___024root___dump_triggers__stl(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VstlTriggered.at(0U)) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vclockl___024root___stl_sequent__TOP__0(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___stl_sequent__TOP__0\n"); );
    // Init
    CData/*6:0*/ __Vfunc_clockl__DOT__segl__DOT__get_seg__0__Vfuncout;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__0__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_clockl__DOT__segl__DOT__get_seg__0__value;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__0__value = 0;
    CData/*6:0*/ __Vfunc_clockl__DOT__segl__DOT__get_seg__1__Vfuncout;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__1__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_clockl__DOT__segl__DOT__get_seg__1__value;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__1__value = 0;
    CData/*6:0*/ __Vfunc_clockl__DOT__segl__DOT__get_seg__2__Vfuncout;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__2__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_clockl__DOT__segl__DOT__get_seg__2__value;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__2__value = 0;
    CData/*6:0*/ __Vfunc_clockl__DOT__segl__DOT__get_seg__3__Vfuncout;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__3__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_clockl__DOT__segl__DOT__get_seg__3__value;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__3__value = 0;
    CData/*6:0*/ __Vfunc_clockl__DOT__segl__DOT__get_seg__4__Vfuncout;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__4__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_clockl__DOT__segl__DOT__get_seg__4__value;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__4__value = 0;
    CData/*6:0*/ __Vfunc_clockl__DOT__segl__DOT__get_seg__5__Vfuncout;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__5__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_clockl__DOT__segl__DOT__get_seg__5__value;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__5__value = 0;
    // Body
    vlSelf->led = vlSelf->clockl__DOT__ledl;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__0__value 
        = vlSelf->clockl__DOT__x;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__0__Vfuncout 
        = ((8U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__0__value))
            ? ((4U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__0__value))
                ? 0x7fU : ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__0__value))
                            ? 0x7fU : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__0__value))
                                        ? 4U : 0U)))
            : ((4U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__0__value))
                ? ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__0__value))
                    ? ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__0__value))
                        ? 0xfU : 0x20U) : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__0__value))
                                            ? 0x24U
                                            : 0x4cU))
                : ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__0__value))
                    ? ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__0__value))
                        ? 6U : 0x12U) : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__0__value))
                                          ? 0x4fU : 1U))));
    vlSelf->seg0 = __Vfunc_clockl__DOT__segl__DOT__get_seg__0__Vfuncout;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__1__value 
        = vlSelf->clockl__DOT__y;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__1__Vfuncout 
        = ((8U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__1__value))
            ? ((4U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__1__value))
                ? 0x7fU : ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__1__value))
                            ? 0x7fU : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__1__value))
                                        ? 4U : 0U)))
            : ((4U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__1__value))
                ? ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__1__value))
                    ? ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__1__value))
                        ? 0xfU : 0x20U) : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__1__value))
                                            ? 0x24U
                                            : 0x4cU))
                : ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__1__value))
                    ? ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__1__value))
                        ? 6U : 0x12U) : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__1__value))
                                          ? 0x4fU : 1U))));
    vlSelf->seg1 = __Vfunc_clockl__DOT__segl__DOT__get_seg__1__Vfuncout;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__2__value 
        = vlSelf->clockl__DOT__a;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__2__Vfuncout 
        = ((8U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__2__value))
            ? ((4U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__2__value))
                ? 0x7fU : ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__2__value))
                            ? 0x7fU : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__2__value))
                                        ? 4U : 0U)))
            : ((4U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__2__value))
                ? ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__2__value))
                    ? ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__2__value))
                        ? 0xfU : 0x20U) : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__2__value))
                                            ? 0x24U
                                            : 0x4cU))
                : ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__2__value))
                    ? ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__2__value))
                        ? 6U : 0x12U) : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__2__value))
                                          ? 0x4fU : 1U))));
    vlSelf->seg2 = __Vfunc_clockl__DOT__segl__DOT__get_seg__2__Vfuncout;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__3__value 
        = vlSelf->clockl__DOT__b;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__3__Vfuncout 
        = ((8U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__3__value))
            ? ((4U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__3__value))
                ? 0x7fU : ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__3__value))
                            ? 0x7fU : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__3__value))
                                        ? 4U : 0U)))
            : ((4U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__3__value))
                ? ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__3__value))
                    ? ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__3__value))
                        ? 0xfU : 0x20U) : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__3__value))
                                            ? 0x24U
                                            : 0x4cU))
                : ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__3__value))
                    ? ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__3__value))
                        ? 6U : 0x12U) : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__3__value))
                                          ? 0x4fU : 1U))));
    vlSelf->seg3 = __Vfunc_clockl__DOT__segl__DOT__get_seg__3__Vfuncout;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__4__value 
        = vlSelf->clockl__DOT__c;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__4__Vfuncout 
        = ((8U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__4__value))
            ? ((4U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__4__value))
                ? 0x7fU : ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__4__value))
                            ? 0x7fU : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__4__value))
                                        ? 4U : 0U)))
            : ((4U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__4__value))
                ? ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__4__value))
                    ? ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__4__value))
                        ? 0xfU : 0x20U) : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__4__value))
                                            ? 0x24U
                                            : 0x4cU))
                : ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__4__value))
                    ? ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__4__value))
                        ? 6U : 0x12U) : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__4__value))
                                          ? 0x4fU : 1U))));
    vlSelf->seg4 = __Vfunc_clockl__DOT__segl__DOT__get_seg__4__Vfuncout;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__5__value 
        = vlSelf->clockl__DOT__d;
    __Vfunc_clockl__DOT__segl__DOT__get_seg__5__Vfuncout 
        = ((8U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__5__value))
            ? ((4U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__5__value))
                ? 0x7fU : ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__5__value))
                            ? 0x7fU : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__5__value))
                                        ? 4U : 0U)))
            : ((4U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__5__value))
                ? ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__5__value))
                    ? ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__5__value))
                        ? 0xfU : 0x20U) : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__5__value))
                                            ? 0x24U
                                            : 0x4cU))
                : ((2U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__5__value))
                    ? ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__5__value))
                        ? 6U : 0x12U) : ((1U & (IData)(__Vfunc_clockl__DOT__segl__DOT__get_seg__5__value))
                                          ? 0x4fU : 1U))));
    vlSelf->seg5 = __Vfunc_clockl__DOT__segl__DOT__get_seg__5__Vfuncout;
}

VL_ATTR_COLD void Vclockl___024root___eval_stl(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___eval_stl\n"); );
    // Body
    if (vlSelf->__VstlTriggered.at(0U)) {
        Vclockl___024root___stl_sequent__TOP__0(vlSelf);
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vclockl___024root___dump_triggers__act(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VactTriggered.at(0U)) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk)\n");
    }
    if (vlSelf->__VactTriggered.at(1U)) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @(posedge clockl.clk_m)\n");
    }
    if (vlSelf->__VactTriggered.at(2U)) {
        VL_DBG_MSGF("         'act' region trigger index 2 is active: @([changed] clockl.clk_c)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vclockl___024root___dump_triggers__nba(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VnbaTriggered.at(0U)) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk)\n");
    }
    if (vlSelf->__VnbaTriggered.at(1U)) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @(posedge clockl.clk_m)\n");
    }
    if (vlSelf->__VnbaTriggered.at(2U)) {
        VL_DBG_MSGF("         'nba' region trigger index 2 is active: @([changed] clockl.clk_c)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vclockl___024root___ctor_var_reset(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = 0;
    vlSelf->rst = 0;
    vlSelf->BTNL = 0;
    vlSelf->sw = 0;
    vlSelf->seg0 = 0;
    vlSelf->seg1 = 0;
    vlSelf->seg2 = 0;
    vlSelf->seg3 = 0;
    vlSelf->seg4 = 0;
    vlSelf->seg5 = 0;
    vlSelf->led = 0;
    vlSelf->clockl__DOT__clk_c = 0;
    vlSelf->clockl__DOT__clk_m = 0;
    vlSelf->clockl__DOT__count_clk_c = 0;
    vlSelf->clockl__DOT__count_clk_m = 0;
    vlSelf->clockl__DOT__hour = 0;
    vlSelf->clockl__DOT__min = 0;
    vlSelf->clockl__DOT__sec = 0;
    vlSelf->clockl__DOT__temp = 0;
    vlSelf->clockl__DOT__x = 0;
    vlSelf->clockl__DOT__y = 0;
    vlSelf->clockl__DOT__a = 0;
    vlSelf->clockl__DOT__b = 0;
    vlSelf->clockl__DOT__c = 0;
    vlSelf->clockl__DOT__d = 0;
    vlSelf->clockl__DOT__alarm = 0;
    vlSelf->clockl__DOT__ledl = 0;
    vlSelf->__Vtrigrprev__TOP__clk = 0;
    vlSelf->__Vtrigrprev__TOP__clockl__DOT__clk_m = 0;
    vlSelf->__Vtrigrprev__TOP__clockl__DOT__clk_c = 0;
    vlSelf->__VactDidInit = 0;
}
