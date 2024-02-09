// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vram1.h for the primary calling header

#include "verilated.h"

#include "Vram1___024root.h"

void Vram1___024root___eval_act(Vram1___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vram1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram1___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vram1___024root___nba_sequent__TOP__0(Vram1___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vram1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram1___024root___nba_sequent__TOP__0\n"); );
    // Init
    CData/*3:0*/ __Vdlyvdim0__ram1__DOT__ram1__v0;
    __Vdlyvdim0__ram1__DOT__ram1__v0 = 0;
    CData/*7:0*/ __Vdlyvval__ram1__DOT__ram1__v0;
    __Vdlyvval__ram1__DOT__ram1__v0 = 0;
    CData/*0:0*/ __Vdlyvset__ram1__DOT__ram1__v0;
    __Vdlyvset__ram1__DOT__ram1__v0 = 0;
    // Body
    __Vdlyvset__ram1__DOT__ram1__v0 = 0U;
    if (vlSelf->en) {
        __Vdlyvval__ram1__DOT__ram1__v0 = vlSelf->in;
        __Vdlyvset__ram1__DOT__ram1__v0 = 1U;
        __Vdlyvdim0__ram1__DOT__ram1__v0 = vlSelf->inputaddr;
    }
    if ((1U & (~ (IData)(vlSelf->en)))) {
        vlSelf->out = vlSelf->ram1__DOT__ram1[vlSelf->outputaddr];
    }
    if (__Vdlyvset__ram1__DOT__ram1__v0) {
        vlSelf->ram1__DOT__ram1[__Vdlyvdim0__ram1__DOT__ram1__v0] 
            = __Vdlyvval__ram1__DOT__ram1__v0;
    }
    vlSelf->seg0 = ((0U == (0xfU & (IData)(vlSelf->out)))
                     ? 1U : ((1U == (0xfU & (IData)(vlSelf->out)))
                              ? 0x4fU : ((2U == (0xfU 
                                                 & (IData)(vlSelf->out)))
                                          ? 0x12U : 
                                         ((3U == (0xfU 
                                                  & (IData)(vlSelf->out)))
                                           ? 6U : (
                                                   (4U 
                                                    == 
                                                    (0xfU 
                                                     & (IData)(vlSelf->out)))
                                                    ? 0x4cU
                                                    : 
                                                   ((5U 
                                                     == 
                                                     (0xfU 
                                                      & (IData)(vlSelf->out)))
                                                     ? 0x24U
                                                     : 
                                                    ((6U 
                                                      == 
                                                      (0xfU 
                                                       & (IData)(vlSelf->out)))
                                                      ? 0x20U
                                                      : 
                                                     ((7U 
                                                       == 
                                                       (0xfU 
                                                        & (IData)(vlSelf->out)))
                                                       ? 0xfU
                                                       : 
                                                      ((8U 
                                                        == 
                                                        (0xfU 
                                                         & (IData)(vlSelf->out)))
                                                        ? 0U
                                                        : 
                                                       ((9U 
                                                         == 
                                                         (0xfU 
                                                          & (IData)(vlSelf->out)))
                                                         ? 4U
                                                         : 
                                                        ((0xaU 
                                                          == 
                                                          (0xfU 
                                                           & (IData)(vlSelf->out)))
                                                          ? 8U
                                                          : 
                                                         ((0xbU 
                                                           == 
                                                           (0xfU 
                                                            & (IData)(vlSelf->out)))
                                                           ? 0x60U
                                                           : 
                                                          ((0xcU 
                                                            == 
                                                            (0xfU 
                                                             & (IData)(vlSelf->out)))
                                                            ? 0x31U
                                                            : 
                                                           ((0xdU 
                                                             == 
                                                             (0xfU 
                                                              & (IData)(vlSelf->out)))
                                                             ? 0x42U
                                                             : 
                                                            ((0xeU 
                                                              == 
                                                              (0xfU 
                                                               & (IData)(vlSelf->out)))
                                                              ? 0x30U
                                                              : 
                                                             ((0xfU 
                                                               == 
                                                               (0xfU 
                                                                & (IData)(vlSelf->out)))
                                                               ? 0x38U
                                                               : 0x7fU))))))))))))))));
    vlSelf->seg1 = ((0U == (0xfU & ((IData)(vlSelf->out) 
                                    >> 4U))) ? 1U : 
                    ((1U == (0xfU & ((IData)(vlSelf->out) 
                                     >> 4U))) ? 0x4fU
                      : ((2U == (0xfU & ((IData)(vlSelf->out) 
                                         >> 4U))) ? 0x12U
                          : ((3U == (0xfU & ((IData)(vlSelf->out) 
                                             >> 4U)))
                              ? 6U : ((4U == (0xfU 
                                              & ((IData)(vlSelf->out) 
                                                 >> 4U)))
                                       ? 0x4cU : ((5U 
                                                   == 
                                                   (0xfU 
                                                    & ((IData)(vlSelf->out) 
                                                       >> 4U)))
                                                   ? 0x24U
                                                   : 
                                                  ((6U 
                                                    == 
                                                    (0xfU 
                                                     & ((IData)(vlSelf->out) 
                                                        >> 4U)))
                                                    ? 0x20U
                                                    : 
                                                   ((7U 
                                                     == 
                                                     (0xfU 
                                                      & ((IData)(vlSelf->out) 
                                                         >> 4U)))
                                                     ? 0xfU
                                                     : 
                                                    ((8U 
                                                      == 
                                                      (0xfU 
                                                       & ((IData)(vlSelf->out) 
                                                          >> 4U)))
                                                      ? 0U
                                                      : 
                                                     ((9U 
                                                       == 
                                                       (0xfU 
                                                        & ((IData)(vlSelf->out) 
                                                           >> 4U)))
                                                       ? 4U
                                                       : 
                                                      ((0xaU 
                                                        == 
                                                        (0xfU 
                                                         & ((IData)(vlSelf->out) 
                                                            >> 4U)))
                                                        ? 8U
                                                        : 
                                                       ((0xbU 
                                                         == 
                                                         (0xfU 
                                                          & ((IData)(vlSelf->out) 
                                                             >> 4U)))
                                                         ? 0x60U
                                                         : 
                                                        ((0xcU 
                                                          == 
                                                          (0xfU 
                                                           & ((IData)(vlSelf->out) 
                                                              >> 4U)))
                                                          ? 0x31U
                                                          : 
                                                         ((0xdU 
                                                           == 
                                                           (0xfU 
                                                            & ((IData)(vlSelf->out) 
                                                               >> 4U)))
                                                           ? 0x42U
                                                           : 
                                                          ((0xeU 
                                                            == 
                                                            (0xfU 
                                                             & ((IData)(vlSelf->out) 
                                                                >> 4U)))
                                                            ? 0x30U
                                                            : 
                                                           ((0xfU 
                                                             == 
                                                             (0xfU 
                                                              & ((IData)(vlSelf->out) 
                                                                 >> 4U)))
                                                             ? 0x38U
                                                             : 0x7fU))))))))))))))));
}

void Vram1___024root___eval_nba(Vram1___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vram1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram1___024root___eval_nba\n"); );
    // Body
    if (vlSelf->__VnbaTriggered.at(0U)) {
        Vram1___024root___nba_sequent__TOP__0(vlSelf);
    }
}

void Vram1___024root___eval_triggers__act(Vram1___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vram1___024root___dump_triggers__act(Vram1___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vram1___024root___dump_triggers__nba(Vram1___024root* vlSelf);
#endif  // VL_DEBUG

void Vram1___024root___eval(Vram1___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vram1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram1___024root___eval\n"); );
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
            Vram1___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vram1___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/ram/vsrc/ram1.v", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.set(vlSelf->__VactTriggered);
                Vram1___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vram1___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/ram/vsrc/ram1.v", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vram1___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vram1___024root___eval_debug_assertions(Vram1___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vram1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram1___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->en & 0xfeU))) {
        Verilated::overWidthError("en");}
    if (VL_UNLIKELY((vlSelf->inputaddr & 0xf0U))) {
        Verilated::overWidthError("inputaddr");}
    if (VL_UNLIKELY((vlSelf->outputaddr & 0xf0U))) {
        Verilated::overWidthError("outputaddr");}
}
#endif  // VL_DEBUG
