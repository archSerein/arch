// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vshift.h for the primary calling header

#include "verilated.h"

#include "Vshift___024root.h"

void Vshift___024root___eval_act(Vshift___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vshift__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vshift___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vshift___024root___nba_sequent__TOP__0(Vshift___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vshift__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vshift___024root___nba_sequent__TOP__0\n"); );
    // Body
    vlSelf->coda = (((0U == (IData)(vlSelf->coda)) 
                     & (0U != (IData)(vlSelf->in)))
                     ? (IData)(vlSelf->in) : (((IData)(vlSelf->shift__DOT__x8) 
                                               << 7U) 
                                              | (0x7fU 
                                                 & ((IData)(vlSelf->coda) 
                                                    >> 1U))));
    vlSelf->seg1 = ((0U == (0xfU & ((IData)(vlSelf->coda) 
                                    >> 4U))) ? 1U : 
                    ((1U == (0xfU & ((IData)(vlSelf->coda) 
                                     >> 4U))) ? 0x4fU
                      : ((2U == (0xfU & ((IData)(vlSelf->coda) 
                                         >> 4U))) ? 0x12U
                          : ((3U == (0xfU & ((IData)(vlSelf->coda) 
                                             >> 4U)))
                              ? 6U : ((4U == (0xfU 
                                              & ((IData)(vlSelf->coda) 
                                                 >> 4U)))
                                       ? 0x4cU : ((5U 
                                                   == 
                                                   (0xfU 
                                                    & ((IData)(vlSelf->coda) 
                                                       >> 4U)))
                                                   ? 0x24U
                                                   : 
                                                  ((6U 
                                                    == 
                                                    (0xfU 
                                                     & ((IData)(vlSelf->coda) 
                                                        >> 4U)))
                                                    ? 0x20U
                                                    : 
                                                   ((7U 
                                                     == 
                                                     (0xfU 
                                                      & ((IData)(vlSelf->coda) 
                                                         >> 4U)))
                                                     ? 0xfU
                                                     : 
                                                    ((8U 
                                                      == 
                                                      (0xfU 
                                                       & ((IData)(vlSelf->coda) 
                                                          >> 4U)))
                                                      ? 0U
                                                      : 
                                                     ((9U 
                                                       == 
                                                       (0xfU 
                                                        & ((IData)(vlSelf->coda) 
                                                           >> 4U)))
                                                       ? 4U
                                                       : 
                                                      ((0xaU 
                                                        == 
                                                        (0xfU 
                                                         & ((IData)(vlSelf->coda) 
                                                            >> 4U)))
                                                        ? 8U
                                                        : 
                                                       ((0xbU 
                                                         == 
                                                         (0xfU 
                                                          & ((IData)(vlSelf->coda) 
                                                             >> 4U)))
                                                         ? 0x60U
                                                         : 
                                                        ((0xcU 
                                                          == 
                                                          (0xfU 
                                                           & ((IData)(vlSelf->coda) 
                                                              >> 4U)))
                                                          ? 0x31U
                                                          : 
                                                         ((0xdU 
                                                           == 
                                                           (0xfU 
                                                            & ((IData)(vlSelf->coda) 
                                                               >> 4U)))
                                                           ? 0x42U
                                                           : 
                                                          ((0xeU 
                                                            == 
                                                            (0xfU 
                                                             & ((IData)(vlSelf->coda) 
                                                                >> 4U)))
                                                            ? 0x30U
                                                            : 
                                                           ((0xfU 
                                                             == 
                                                             (0xfU 
                                                              & ((IData)(vlSelf->coda) 
                                                                 >> 4U)))
                                                             ? 0x38U
                                                             : 0x7fU))))))))))))))));
    vlSelf->seg0 = ((0U == (0xfU & (IData)(vlSelf->coda)))
                     ? 1U : ((1U == (0xfU & (IData)(vlSelf->coda)))
                              ? 0x4fU : ((2U == (0xfU 
                                                 & (IData)(vlSelf->coda)))
                                          ? 0x12U : 
                                         ((3U == (0xfU 
                                                  & (IData)(vlSelf->coda)))
                                           ? 6U : (
                                                   (4U 
                                                    == 
                                                    (0xfU 
                                                     & (IData)(vlSelf->coda)))
                                                    ? 0x4cU
                                                    : 
                                                   ((5U 
                                                     == 
                                                     (0xfU 
                                                      & (IData)(vlSelf->coda)))
                                                     ? 0x24U
                                                     : 
                                                    ((6U 
                                                      == 
                                                      (0xfU 
                                                       & (IData)(vlSelf->coda)))
                                                      ? 0x20U
                                                      : 
                                                     ((7U 
                                                       == 
                                                       (0xfU 
                                                        & (IData)(vlSelf->coda)))
                                                       ? 0xfU
                                                       : 
                                                      ((8U 
                                                        == 
                                                        (0xfU 
                                                         & (IData)(vlSelf->coda)))
                                                        ? 0U
                                                        : 
                                                       ((9U 
                                                         == 
                                                         (0xfU 
                                                          & (IData)(vlSelf->coda)))
                                                         ? 4U
                                                         : 
                                                        ((0xaU 
                                                          == 
                                                          (0xfU 
                                                           & (IData)(vlSelf->coda)))
                                                          ? 8U
                                                          : 
                                                         ((0xbU 
                                                           == 
                                                           (0xfU 
                                                            & (IData)(vlSelf->coda)))
                                                           ? 0x60U
                                                           : 
                                                          ((0xcU 
                                                            == 
                                                            (0xfU 
                                                             & (IData)(vlSelf->coda)))
                                                            ? 0x31U
                                                            : 
                                                           ((0xdU 
                                                             == 
                                                             (0xfU 
                                                              & (IData)(vlSelf->coda)))
                                                             ? 0x42U
                                                             : 
                                                            ((0xeU 
                                                              == 
                                                              (0xfU 
                                                               & (IData)(vlSelf->coda)))
                                                              ? 0x30U
                                                              : 
                                                             ((0xfU 
                                                               == 
                                                               (0xfU 
                                                                & (IData)(vlSelf->coda)))
                                                               ? 0x38U
                                                               : 0x7fU))))))))))))))));
    vlSelf->shift__DOT__x8 = (1U & VL_REDXOR_8((0x1dU 
                                                & (IData)(vlSelf->coda))));
}

void Vshift___024root___eval_nba(Vshift___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vshift__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vshift___024root___eval_nba\n"); );
    // Body
    if (vlSelf->__VnbaTriggered.at(0U)) {
        Vshift___024root___nba_sequent__TOP__0(vlSelf);
    }
}

void Vshift___024root___eval_triggers__act(Vshift___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vshift___024root___dump_triggers__act(Vshift___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vshift___024root___dump_triggers__nba(Vshift___024root* vlSelf);
#endif  // VL_DEBUG

void Vshift___024root___eval(Vshift___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vshift__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vshift___024root___eval\n"); );
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
            Vshift___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vshift___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/shift/vsrc/shift.v", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.set(vlSelf->__VactTriggered);
                Vshift___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vshift___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/shift/vsrc/shift.v", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vshift___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vshift___024root___eval_debug_assertions(Vshift___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vshift__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vshift___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->en & 0xfeU))) {
        Verilated::overWidthError("en");}
}
#endif  // VL_DEBUG
