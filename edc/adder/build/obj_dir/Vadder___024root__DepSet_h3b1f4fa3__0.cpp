// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vadder.h for the primary calling header

#include "verilated.h"

#include "Vadder___024root.h"

VL_INLINE_OPT void Vadder___024root___ico_sequent__TOP__0(Vadder___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vadder__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vadder___024root___ico_sequent__TOP__0\n"); );
    // Init
    CData/*4:0*/ adder__DOT__add;
    adder__DOT__add = 0;
    CData/*3:0*/ adder__DOT__t_add_Cin;
    adder__DOT__t_add_Cin = 0;
    CData/*4:0*/ adder__DOT__sub;
    adder__DOT__sub = 0;
    CData/*0:0*/ adder__DOT____VdfgTmp_he3f694c6__0;
    adder__DOT____VdfgTmp_he3f694c6__0 = 0;
    CData/*2:0*/ adder__DOT__segl__DOT__out_s;
    adder__DOT__segl__DOT__out_s = 0;
    // Body
    adder__DOT__add = (0x1fU & ((IData)(vlSelf->x) 
                                + (IData)(vlSelf->y)));
    adder__DOT____VdfgTmp_he3f694c6__0 = ((1U & ((IData)(vlSelf->x) 
                                                 >> 3U)) 
                                          == (1U & 
                                              ((IData)(vlSelf->y) 
                                               >> 3U)));
    adder__DOT__t_add_Cin = (0xfU & ((- (IData)((1U 
                                                 & (IData)(vlSelf->select)))) 
                                     ^ (IData)(vlSelf->y)));
    adder__DOT__sub = (0x1fU & ((IData)(vlSelf->x) 
                                + ((IData)(adder__DOT__t_add_Cin) 
                                   + (1U & (IData)(vlSelf->select)))));
    if ((0U == (IData)(vlSelf->select))) {
        vlSelf->out = (0xfU & (IData)(adder__DOT__add));
        vlSelf->led = ((((IData)(adder__DOT____VdfgTmp_he3f694c6__0) 
                         & ((1U & ((IData)(adder__DOT__add) 
                                   >> 3U)) != (1U & 
                                               ((IData)(vlSelf->x) 
                                                >> 3U)))) 
                        << 2U) | ((2U & ((IData)(adder__DOT__add) 
                                         >> 3U)) | 
                                  (1U & (~ (IData)(
                                                   (0U 
                                                    != (IData)(vlSelf->out)))))));
    } else if ((1U == (IData)(vlSelf->select))) {
        vlSelf->out = (0xfU & (IData)(adder__DOT__sub));
        vlSelf->led = (((((1U & ((IData)(vlSelf->x) 
                                 >> 3U)) == (1U & ((IData)(adder__DOT__t_add_Cin) 
                                                   >> 3U))) 
                         & ((1U & ((IData)(adder__DOT__sub) 
                                   >> 3U)) != (1U & 
                                               ((IData)(vlSelf->x) 
                                                >> 3U)))) 
                        << 2U) | ((2U & ((IData)(adder__DOT__sub) 
                                         >> 3U)) | 
                                  (1U & (~ (IData)(
                                                   (0U 
                                                    != (IData)(vlSelf->out)))))));
    } else {
        vlSelf->out = (0xfU & ((2U == (IData)(vlSelf->select))
                                ? (~ (IData)(vlSelf->x))
                                : ((3U == (IData)(vlSelf->select))
                                    ? ((IData)(vlSelf->x) 
                                       & (IData)(vlSelf->y))
                                    : ((4U == (IData)(vlSelf->select))
                                        ? ((IData)(vlSelf->x) 
                                           | (IData)(vlSelf->y))
                                        : ((5U == (IData)(vlSelf->select))
                                            ? ((IData)(vlSelf->x) 
                                               ^ (IData)(vlSelf->y))
                                            : ((6U 
                                                == (IData)(vlSelf->select))
                                                ? (
                                                   (((7U 
                                                      & (IData)(vlSelf->x)) 
                                                     < 
                                                     (7U 
                                                      & (IData)(vlSelf->y))) 
                                                    & (IData)(adder__DOT____VdfgTmp_he3f694c6__0)) 
                                                   | ((1U 
                                                       & ((IData)(vlSelf->x) 
                                                          >> 3U)) 
                                                      > 
                                                      (1U 
                                                       & ((IData)(vlSelf->y) 
                                                          >> 3U))))
                                                : (
                                                   (7U 
                                                    == (IData)(vlSelf->select))
                                                    ? 
                                                   ((IData)(vlSelf->x) 
                                                    == (IData)(vlSelf->y))
                                                    : 0U)))))));
        vlSelf->led = 0U;
    }
    if ((8U & (IData)(vlSelf->out))) {
        vlSelf->seg1 = 0x7eU;
        adder__DOT__segl__DOT__out_s = (7U & ((IData)(1U) 
                                              + (~ (IData)(vlSelf->out))));
    } else {
        vlSelf->seg1 = 0x7fU;
        adder__DOT__segl__DOT__out_s = (7U & (IData)(vlSelf->out));
    }
    vlSelf->seg0 = ((0U == (IData)(adder__DOT__segl__DOT__out_s))
                     ? 1U : ((1U == (IData)(adder__DOT__segl__DOT__out_s))
                              ? 0x4fU : ((2U == (IData)(adder__DOT__segl__DOT__out_s))
                                          ? 0x12U : 
                                         ((3U == (IData)(adder__DOT__segl__DOT__out_s))
                                           ? 6U : (
                                                   (4U 
                                                    == (IData)(adder__DOT__segl__DOT__out_s))
                                                    ? 0x4cU
                                                    : 
                                                   ((5U 
                                                     == (IData)(adder__DOT__segl__DOT__out_s))
                                                     ? 0x24U
                                                     : 
                                                    ((6U 
                                                      == (IData)(adder__DOT__segl__DOT__out_s))
                                                      ? 0x20U
                                                      : 
                                                     ((7U 
                                                       == (IData)(adder__DOT__segl__DOT__out_s))
                                                       ? 0xfU
                                                       : 0x7fU))))))));
}

void Vadder___024root___eval_ico(Vadder___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vadder__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vadder___024root___eval_ico\n"); );
    // Body
    if (vlSelf->__VicoTriggered.at(0U)) {
        Vadder___024root___ico_sequent__TOP__0(vlSelf);
    }
}

void Vadder___024root___eval_act(Vadder___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vadder__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vadder___024root___eval_act\n"); );
}

void Vadder___024root___eval_nba(Vadder___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vadder__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vadder___024root___eval_nba\n"); );
}

void Vadder___024root___eval_triggers__ico(Vadder___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vadder___024root___dump_triggers__ico(Vadder___024root* vlSelf);
#endif  // VL_DEBUG
void Vadder___024root___eval_triggers__act(Vadder___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vadder___024root___dump_triggers__act(Vadder___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vadder___024root___dump_triggers__nba(Vadder___024root* vlSelf);
#endif  // VL_DEBUG

void Vadder___024root___eval(Vadder___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vadder__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vadder___024root___eval\n"); );
    // Init
    CData/*0:0*/ __VicoContinue;
    VlTriggerVec<0> __VpreTriggered;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    vlSelf->__VicoIterCount = 0U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        __VicoContinue = 0U;
        Vadder___024root___eval_triggers__ico(vlSelf);
        if (vlSelf->__VicoTriggered.any()) {
            __VicoContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VicoIterCount))) {
#ifdef VL_DEBUG
                Vadder___024root___dump_triggers__ico(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/adder/vsrc/adder.v", 1, "", "Input combinational region did not converge.");
            }
            vlSelf->__VicoIterCount = ((IData)(1U) 
                                       + vlSelf->__VicoIterCount);
            Vadder___024root___eval_ico(vlSelf);
        }
    }
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        __VnbaContinue = 0U;
        vlSelf->__VnbaTriggered.clear();
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            vlSelf->__VactContinue = 0U;
            Vadder___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vadder___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/adder/vsrc/adder.v", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.set(vlSelf->__VactTriggered);
                Vadder___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vadder___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/adder/vsrc/adder.v", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vadder___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vadder___024root___eval_debug_assertions(Vadder___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vadder__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vadder___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->x & 0xf0U))) {
        Verilated::overWidthError("x");}
    if (VL_UNLIKELY((vlSelf->y & 0xf0U))) {
        Verilated::overWidthError("y");}
    if (VL_UNLIKELY((vlSelf->select & 0xf8U))) {
        Verilated::overWidthError("select");}
}
#endif  // VL_DEBUG
