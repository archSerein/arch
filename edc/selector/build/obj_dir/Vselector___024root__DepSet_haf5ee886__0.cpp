// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vselector.h for the primary calling header

#include "verilated.h"

#include "Vselector___024root.h"

void Vselector___024root___eval_act(Vselector___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vselector__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vselector___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vselector___024root___nba_sequent__TOP__0(Vselector___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vselector__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vselector___024root___nba_sequent__TOP__0\n"); );
    // Body
    vlSelf->led = ((IData)(vlSelf->rst) ? 0U : (3U 
                                                & ((2U 
                                                    & (IData)(vlSelf->sw))
                                                    ? 
                                                   ((1U 
                                                     & (IData)(vlSelf->sw))
                                                     ? 
                                                    ((IData)(vlSelf->sw) 
                                                     >> 8U)
                                                     : 
                                                    ((IData)(vlSelf->sw) 
                                                     >> 6U))
                                                    : 
                                                   ((1U 
                                                     & (IData)(vlSelf->sw))
                                                     ? 
                                                    ((IData)(vlSelf->sw) 
                                                     >> 4U)
                                                     : 
                                                    ((IData)(vlSelf->sw) 
                                                     >> 2U)))));
}

void Vselector___024root___eval_nba(Vselector___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vselector__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vselector___024root___eval_nba\n"); );
    // Body
    if (vlSelf->__VnbaTriggered.at(0U)) {
        Vselector___024root___nba_sequent__TOP__0(vlSelf);
    }
}

void Vselector___024root___eval_triggers__act(Vselector___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vselector___024root___dump_triggers__act(Vselector___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vselector___024root___dump_triggers__nba(Vselector___024root* vlSelf);
#endif  // VL_DEBUG

void Vselector___024root___eval(Vselector___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vselector__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vselector___024root___eval\n"); );
    // Init
    VlTriggerVec<1> __VpreTriggered;
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
            Vselector___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vselector___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/selector/vsrc/selector.v", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.set(vlSelf->__VactTriggered);
                Vselector___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vselector___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/selector/vsrc/selector.v", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vselector___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vselector___024root___eval_debug_assertions(Vselector___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vselector__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vselector___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->rst & 0xfeU))) {
        Verilated::overWidthError("rst");}
    if (VL_UNLIKELY((vlSelf->sw & 0xfc00U))) {
        Verilated::overWidthError("sw");}
}
#endif  // VL_DEBUG
