// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcounter.h for the primary calling header

#include "verilated.h"

#include "Vcounter___024root.h"

void Vcounter___024root___eval_act(Vcounter___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcounter__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcounter___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vcounter___024root___nba_sequent__TOP__0(Vcounter___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcounter__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcounter___024root___nba_sequent__TOP__0\n"); );
    // Init
    IData/*24:0*/ __Vdly__counter__DOT__count_clk;
    __Vdly__counter__DOT__count_clk = 0;
    // Body
    __Vdly__counter__DOT__count_clk = vlSelf->counter__DOT__count_clk;
    if ((0x5b8d80U == vlSelf->counter__DOT__count_clk)) {
        vlSelf->counter__DOT__clk_ls = (1U & (~ (IData)(vlSelf->counter__DOT__clk_ls)));
        __Vdly__counter__DOT__count_clk = 0U;
    } else {
        __Vdly__counter__DOT__count_clk = (0x1ffffffU 
                                           & ((IData)(1U) 
                                              + vlSelf->counter__DOT__count_clk));
    }
    vlSelf->counter__DOT__count_clk = __Vdly__counter__DOT__count_clk;
}

extern const VlUnpacked<CData/*6:0*/, 16> Vcounter__ConstPool__TABLE_h1aa2c92a_0;

VL_INLINE_OPT void Vcounter___024root___nba_sequent__TOP__1(Vcounter___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcounter__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcounter___024root___nba_sequent__TOP__1\n"); );
    // Init
    CData/*3:0*/ __Vtableidx1;
    __Vtableidx1 = 0;
    CData/*3:0*/ __Vtableidx2;
    __Vtableidx2 = 0;
    // Body
    if (vlSelf->rst) {
        vlSelf->counter__DOT__x = 0xfU;
        vlSelf->counter__DOT__y = 0xfU;
        vlSelf->counter__DOT__ledl = 0U;
    } else if ((IData)((1U == (IData)(vlSelf->sw)))) {
        if ((0x63U >= (IData)(vlSelf->counter__DOT__count))) {
            vlSelf->counter__DOT__ledl = 0U;
            vlSelf->counter__DOT__temp = (0x7fU & VL_MODDIV_III(32, (IData)(vlSelf->counter__DOT__count), (IData)(0xaU)));
            vlSelf->counter__DOT__x = (0xfU & (IData)(vlSelf->counter__DOT__temp));
            vlSelf->counter__DOT__temp = (0x7fU & VL_DIV_III(32, (IData)(vlSelf->counter__DOT__count), (IData)(0xaU)));
            vlSelf->counter__DOT__y = (0xfU & (IData)(vlSelf->counter__DOT__temp));
            vlSelf->counter__DOT__count = (0x7fU & 
                                           ((IData)(1U) 
                                            + (IData)(vlSelf->counter__DOT__count)));
        } else {
            vlSelf->counter__DOT__ledl = 1U;
            vlSelf->counter__DOT__count = 0U;
            vlSelf->counter__DOT__x = 0U;
            vlSelf->counter__DOT__y = 0U;
        }
    } else if ((1U & (~ (IData)((0U == (IData)(vlSelf->sw)))))) {
        vlSelf->counter__DOT__count = 0U;
        vlSelf->counter__DOT__x = 0U;
        vlSelf->counter__DOT__y = 0U;
        vlSelf->counter__DOT__ledl = 0U;
    }
    vlSelf->led = vlSelf->counter__DOT__ledl;
    __Vtableidx1 = vlSelf->counter__DOT__x;
    vlSelf->seg0 = Vcounter__ConstPool__TABLE_h1aa2c92a_0
        [__Vtableidx1];
    __Vtableidx2 = vlSelf->counter__DOT__y;
    vlSelf->seg1 = Vcounter__ConstPool__TABLE_h1aa2c92a_0
        [__Vtableidx2];
}

void Vcounter___024root___eval_nba(Vcounter___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcounter__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcounter___024root___eval_nba\n"); );
    // Body
    if (vlSelf->__VnbaTriggered.at(0U)) {
        Vcounter___024root___nba_sequent__TOP__0(vlSelf);
    }
    if (vlSelf->__VnbaTriggered.at(1U)) {
        Vcounter___024root___nba_sequent__TOP__1(vlSelf);
    }
}

void Vcounter___024root___eval_triggers__act(Vcounter___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vcounter___024root___dump_triggers__act(Vcounter___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vcounter___024root___dump_triggers__nba(Vcounter___024root* vlSelf);
#endif  // VL_DEBUG

void Vcounter___024root___eval(Vcounter___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcounter__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcounter___024root___eval\n"); );
    // Init
    VlTriggerVec<2> __VpreTriggered;
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
            Vcounter___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vcounter___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/counter/vsrc/counter.v", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.set(vlSelf->__VactTriggered);
                Vcounter___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vcounter___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/counter/vsrc/counter.v", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vcounter___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vcounter___024root___eval_debug_assertions(Vcounter___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcounter__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcounter___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->rst & 0xfeU))) {
        Verilated::overWidthError("rst");}
    if (VL_UNLIKELY((vlSelf->sw & 0xfcU))) {
        Verilated::overWidthError("sw");}
}
#endif  // VL_DEBUG
