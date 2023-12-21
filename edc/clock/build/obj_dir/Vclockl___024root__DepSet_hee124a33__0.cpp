// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vclockl.h for the primary calling header

#include "verilated.h"

#include "Vclockl___024root.h"

void Vclockl___024root___eval_act(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vclockl___024root___nba_sequent__TOP__0(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___nba_sequent__TOP__0\n"); );
    // Init
    IData/*24:0*/ __Vdly__clockl__DOT__count_clk_c;
    __Vdly__clockl__DOT__count_clk_c = 0;
    IData/*17:0*/ __Vdly__clockl__DOT__count_clk_m;
    __Vdly__clockl__DOT__count_clk_m = 0;
    // Body
    __Vdly__clockl__DOT__count_clk_m = vlSelf->clockl__DOT__count_clk_m;
    __Vdly__clockl__DOT__count_clk_c = vlSelf->clockl__DOT__count_clk_c;
    if ((0x3d090U == vlSelf->clockl__DOT__count_clk_m)) {
        vlSelf->clockl__DOT__clk_m = (1U & (~ (IData)(vlSelf->clockl__DOT__clk_m)));
        __Vdly__clockl__DOT__count_clk_m = 0U;
    } else {
        __Vdly__clockl__DOT__count_clk_m = (0x3ffffU 
                                            & ((IData)(1U) 
                                               + vlSelf->clockl__DOT__count_clk_m));
    }
    if ((0x17d7840U == vlSelf->clockl__DOT__count_clk_c)) {
        vlSelf->clockl__DOT__clk_c = (1U & (~ (IData)(vlSelf->clockl__DOT__clk_c)));
        __Vdly__clockl__DOT__count_clk_c = 0U;
    } else {
        __Vdly__clockl__DOT__count_clk_c = (0x1ffffffU 
                                            & ((IData)(1U) 
                                               + vlSelf->clockl__DOT__count_clk_c));
    }
    vlSelf->clockl__DOT__count_clk_m = __Vdly__clockl__DOT__count_clk_m;
    vlSelf->clockl__DOT__count_clk_c = __Vdly__clockl__DOT__count_clk_c;
}

VL_INLINE_OPT void Vclockl___024root___nba_sequent__TOP__1(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___nba_sequent__TOP__1\n"); );
    // Body
    if ((1U == (IData)(vlSelf->sw))) {
        if ((0x63U >= (IData)(vlSelf->clockl__DOT__sec))) {
            vlSelf->clockl__DOT__sec = (0x7fU & ((IData)(1U) 
                                                 + (IData)(vlSelf->clockl__DOT__sec)));
            vlSelf->clockl__DOT__temp = (0x7fU & VL_MODDIV_III(32, (IData)(vlSelf->clockl__DOT__sec), (IData)(0xaU)));
            vlSelf->clockl__DOT__x = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
            vlSelf->clockl__DOT__temp = (0x7fU & VL_DIV_III(32, (IData)(vlSelf->clockl__DOT__sec), (IData)(0xaU)));
            vlSelf->clockl__DOT__y = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
        } else if ((0x3bU >= (IData)(vlSelf->clockl__DOT__min))) {
            vlSelf->clockl__DOT__min = (0x7fU & ((IData)(1U) 
                                                 + (IData)(vlSelf->clockl__DOT__min)));
            vlSelf->clockl__DOT__sec = 0U;
            vlSelf->clockl__DOT__x = 0U;
            vlSelf->clockl__DOT__y = 0U;
            vlSelf->clockl__DOT__temp = (0x7fU & VL_MODDIV_III(32, (IData)(vlSelf->clockl__DOT__min), (IData)(0xaU)));
            vlSelf->clockl__DOT__a = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
            vlSelf->clockl__DOT__temp = (0x7fU & VL_DIV_III(32, (IData)(vlSelf->clockl__DOT__min), (IData)(0xaU)));
            vlSelf->clockl__DOT__b = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
        } else if ((0x62U > (IData)(vlSelf->clockl__DOT__hour))) {
            vlSelf->clockl__DOT__sec = 0U;
            vlSelf->clockl__DOT__min = 0U;
            vlSelf->clockl__DOT__x = 0U;
            vlSelf->clockl__DOT__y = 0U;
            vlSelf->clockl__DOT__a = 0U;
            vlSelf->clockl__DOT__b = 0U;
            vlSelf->clockl__DOT__temp = (0x7fU & VL_MODDIV_III(32, (IData)(vlSelf->clockl__DOT__hour), (IData)(0xaU)));
            vlSelf->clockl__DOT__c = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
            vlSelf->clockl__DOT__temp = (0x7fU & VL_DIV_III(32, (IData)(vlSelf->clockl__DOT__hour), (IData)(0xaU)));
            vlSelf->clockl__DOT__d = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
        } else {
            vlSelf->clockl__DOT__min = 0U;
            vlSelf->clockl__DOT__sec = 0U;
            vlSelf->clockl__DOT__hour = 0U;
            vlSelf->clockl__DOT__a = 0U;
            vlSelf->clockl__DOT__b = 0U;
            vlSelf->clockl__DOT__c = 0U;
            vlSelf->clockl__DOT__d = 0U;
            vlSelf->clockl__DOT__x = 0U;
            vlSelf->clockl__DOT__y = 0U;
        }
    } else if ((7U == (IData)(vlSelf->sw))) {
        vlSelf->clockl__DOT__min = 0U;
        vlSelf->clockl__DOT__sec = 0U;
        vlSelf->clockl__DOT__hour = 0U;
        vlSelf->clockl__DOT__a = 0U;
        vlSelf->clockl__DOT__b = 0U;
        vlSelf->clockl__DOT__c = 0U;
        vlSelf->clockl__DOT__d = 0U;
        vlSelf->clockl__DOT__x = 0U;
        vlSelf->clockl__DOT__y = 0U;
    }
}

VL_INLINE_OPT void Vclockl___024root___nba_sequent__TOP__2(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___nba_sequent__TOP__2\n"); );
    // Body
    if ((0U == (IData)(vlSelf->sw))) {
        if ((0x3bU > (IData)(vlSelf->clockl__DOT__sec))) {
            vlSelf->clockl__DOT__sec = (0x7fU & ((IData)(1U) 
                                                 + (IData)(vlSelf->clockl__DOT__sec)));
            vlSelf->clockl__DOT__temp = (0x7fU & VL_MODDIV_III(32, (IData)(vlSelf->clockl__DOT__sec), (IData)(0xaU)));
            vlSelf->clockl__DOT__x = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
            vlSelf->clockl__DOT__temp = (0x7fU & VL_DIV_III(32, (IData)(vlSelf->clockl__DOT__sec), (IData)(0xaU)));
            vlSelf->clockl__DOT__y = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
            vlSelf->clockl__DOT__ledl = ((((((((IData)(vlSelf->clockl__DOT__d) 
                                               == (0xfU 
                                                   & (vlSelf->clockl__DOT__alarm 
                                                      >> 0x14U))) 
                                              & ((IData)(vlSelf->clockl__DOT__c) 
                                                 == 
                                                 (0xfU 
                                                  & (vlSelf->clockl__DOT__alarm 
                                                     >> 0x10U)))) 
                                             & ((IData)(vlSelf->clockl__DOT__b) 
                                                == 
                                                (0xfU 
                                                 & (vlSelf->clockl__DOT__alarm 
                                                    >> 0xcU)))) 
                                            & ((IData)(vlSelf->clockl__DOT__a) 
                                               == (0xfU 
                                                   & (vlSelf->clockl__DOT__alarm 
                                                      >> 8U)))) 
                                           & ((IData)(vlSelf->clockl__DOT__y) 
                                              == (0xfU 
                                                  & (vlSelf->clockl__DOT__alarm 
                                                     >> 4U)))) 
                                          & ((IData)(vlSelf->clockl__DOT__x) 
                                             == (0xfU 
                                                 & vlSelf->clockl__DOT__alarm)))
                                          ? 0xffffU
                                          : 0U);
        } else if ((0x3bU >= (IData)(vlSelf->clockl__DOT__min))) {
            vlSelf->clockl__DOT__min = (0x7fU & ((IData)(1U) 
                                                 + (IData)(vlSelf->clockl__DOT__min)));
            vlSelf->clockl__DOT__sec = 0U;
            vlSelf->clockl__DOT__x = 0U;
            vlSelf->clockl__DOT__y = 0U;
            vlSelf->clockl__DOT__temp = (0x7fU & VL_MODDIV_III(32, (IData)(vlSelf->clockl__DOT__min), (IData)(0xaU)));
            vlSelf->clockl__DOT__a = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
            vlSelf->clockl__DOT__temp = (0x7fU & VL_DIV_III(32, (IData)(vlSelf->clockl__DOT__min), (IData)(0xaU)));
            vlSelf->clockl__DOT__b = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
        } else if ((0x17U > (IData)(vlSelf->clockl__DOT__hour))) {
            vlSelf->clockl__DOT__sec = 0U;
            vlSelf->clockl__DOT__min = 0U;
            vlSelf->clockl__DOT__x = 0U;
            vlSelf->clockl__DOT__y = 0U;
            vlSelf->clockl__DOT__a = 0U;
            vlSelf->clockl__DOT__b = 0U;
            vlSelf->clockl__DOT__temp = (0x7fU & VL_MODDIV_III(32, (IData)(vlSelf->clockl__DOT__hour), (IData)(0xaU)));
            vlSelf->clockl__DOT__c = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
            vlSelf->clockl__DOT__temp = (0x7fU & VL_DIV_III(32, (IData)(vlSelf->clockl__DOT__hour), (IData)(0xaU)));
            vlSelf->clockl__DOT__d = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
        } else {
            vlSelf->clockl__DOT__min = 0U;
            vlSelf->clockl__DOT__sec = 0U;
            vlSelf->clockl__DOT__hour = 0U;
            vlSelf->clockl__DOT__a = 0U;
            vlSelf->clockl__DOT__b = 0U;
            vlSelf->clockl__DOT__c = 0U;
            vlSelf->clockl__DOT__d = 0U;
            vlSelf->clockl__DOT__x = 0U;
            vlSelf->clockl__DOT__y = 0U;
        }
    } else if ((2U == (IData)(vlSelf->sw))) {
        if (vlSelf->BTNL) {
            if ((0x3bU > (IData)(vlSelf->clockl__DOT__sec))) {
                vlSelf->clockl__DOT__sec = (0x7fU & 
                                            ((IData)(1U) 
                                             + (IData)(vlSelf->clockl__DOT__sec)));
                vlSelf->clockl__DOT__temp = (0x7fU 
                                             & VL_MODDIV_III(32, (IData)(vlSelf->clockl__DOT__sec), (IData)(0xaU)));
                vlSelf->clockl__DOT__x = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
                vlSelf->clockl__DOT__temp = (0x7fU 
                                             & VL_DIV_III(32, (IData)(vlSelf->clockl__DOT__sec), (IData)(0xaU)));
                vlSelf->clockl__DOT__y = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
            } else {
                vlSelf->clockl__DOT__sec = 0U;
                vlSelf->clockl__DOT__x = 0U;
                vlSelf->clockl__DOT__y = 0U;
            }
        }
    } else if ((4U == (IData)(vlSelf->sw))) {
        if (vlSelf->BTNL) {
            if ((0x3bU >= (IData)(vlSelf->clockl__DOT__min))) {
                vlSelf->clockl__DOT__min = (0x7fU & 
                                            ((IData)(1U) 
                                             + (IData)(vlSelf->clockl__DOT__min)));
                vlSelf->clockl__DOT__temp = (0x7fU 
                                             & VL_MODDIV_III(32, (IData)(vlSelf->clockl__DOT__min), (IData)(0xaU)));
                vlSelf->clockl__DOT__a = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
                vlSelf->clockl__DOT__temp = (0x7fU 
                                             & VL_DIV_III(32, (IData)(vlSelf->clockl__DOT__min), (IData)(0xaU)));
                vlSelf->clockl__DOT__b = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
            } else {
                vlSelf->clockl__DOT__min = 0U;
                vlSelf->clockl__DOT__a = 0U;
                vlSelf->clockl__DOT__b = 0U;
            }
        }
    } else if (vlSelf->BTNL) {
        if ((0x17U > (IData)(vlSelf->clockl__DOT__hour))) {
            vlSelf->clockl__DOT__hour = (0x7fU & ((IData)(1U) 
                                                  + (IData)(vlSelf->clockl__DOT__hour)));
            vlSelf->clockl__DOT__temp = (0x7fU & VL_MODDIV_III(32, (IData)(vlSelf->clockl__DOT__hour), (IData)(0xaU)));
            vlSelf->clockl__DOT__c = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
            vlSelf->clockl__DOT__temp = (0x7fU & VL_DIV_III(32, (IData)(vlSelf->clockl__DOT__hour), (IData)(0xaU)));
            vlSelf->clockl__DOT__d = (0xfU & (IData)(vlSelf->clockl__DOT__temp));
        } else {
            vlSelf->clockl__DOT__hour = 0U;
            vlSelf->clockl__DOT__c = 0U;
            vlSelf->clockl__DOT__d = 0U;
        }
    }
    vlSelf->led = vlSelf->clockl__DOT__ledl;
}

VL_INLINE_OPT void Vclockl___024root___nba_comb__TOP__0(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___nba_comb__TOP__0\n"); );
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

void Vclockl___024root___eval_nba(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___eval_nba\n"); );
    // Body
    if (vlSelf->__VnbaTriggered.at(0U)) {
        Vclockl___024root___nba_sequent__TOP__0(vlSelf);
    }
    if (vlSelf->__VnbaTriggered.at(1U)) {
        Vclockl___024root___nba_sequent__TOP__1(vlSelf);
    }
    if (vlSelf->__VnbaTriggered.at(2U)) {
        Vclockl___024root___nba_sequent__TOP__2(vlSelf);
    }
    if ((vlSelf->__VnbaTriggered.at(1U) | vlSelf->__VnbaTriggered.at(2U))) {
        Vclockl___024root___nba_comb__TOP__0(vlSelf);
    }
}

void Vclockl___024root___eval_triggers__act(Vclockl___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vclockl___024root___dump_triggers__act(Vclockl___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vclockl___024root___dump_triggers__nba(Vclockl___024root* vlSelf);
#endif  // VL_DEBUG

void Vclockl___024root___eval(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___eval\n"); );
    // Init
    VlTriggerVec<3> __VpreTriggered;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        __VnbaContinue = 0U;
        vlSelf->__VnbaTriggered.clear();
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            vlSelf->__VactContinue = 0U;
            Vclockl___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vclockl___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/clock/vsrc/clockl.v", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.set(vlSelf->__VactTriggered);
                Vclockl___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vclockl___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/clock/vsrc/clockl.v", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vclockl___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vclockl___024root___eval_debug_assertions(Vclockl___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vclockl__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vclockl___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->rst & 0xfeU))) {
        Verilated::overWidthError("rst");}
    if (VL_UNLIKELY((vlSelf->BTNL & 0xfeU))) {
        Verilated::overWidthError("BTNL");}
    if (VL_UNLIKELY((vlSelf->sw & 0xf8U))) {
        Verilated::overWidthError("sw");}
}
#endif  // VL_DEBUG
