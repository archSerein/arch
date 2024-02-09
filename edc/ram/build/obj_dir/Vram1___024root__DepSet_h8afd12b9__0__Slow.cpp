// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vram1.h for the primary calling header

#include "verilated.h"

#include "Vram1___024root.h"

VL_ATTR_COLD void Vram1___024root___eval_static(Vram1___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vram1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram1___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vram1___024root___eval_initial__TOP(Vram1___024root* vlSelf);

VL_ATTR_COLD void Vram1___024root___eval_initial(Vram1___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vram1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram1___024root___eval_initial\n"); );
    // Body
    Vram1___024root___eval_initial__TOP(vlSelf);
    vlSelf->__Vtrigrprev__TOP__clk = vlSelf->clk;
}

extern const VlWide<12>/*383:0*/ Vram1__ConstPool__CONST_h3c0429a3_0;

VL_ATTR_COLD void Vram1___024root___eval_initial__TOP(Vram1___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vram1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram1___024root___eval_initial__TOP\n"); );
    // Body
    VL_READMEM_N(true, 8, 16, 0, VL_CVT_PACK_STR_NW(12, Vram1__ConstPool__CONST_h3c0429a3_0)
                 ,  &(vlSelf->ram1__DOT__ram1), 0, ~0ULL);
}

VL_ATTR_COLD void Vram1___024root___eval_final(Vram1___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vram1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram1___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vram1___024root___eval_triggers__stl(Vram1___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vram1___024root___dump_triggers__stl(Vram1___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD void Vram1___024root___eval_stl(Vram1___024root* vlSelf);

VL_ATTR_COLD void Vram1___024root___eval_settle(Vram1___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vram1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram1___024root___eval_settle\n"); );
    // Init
    CData/*0:0*/ __VstlContinue;
    // Body
    vlSelf->__VstlIterCount = 0U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        __VstlContinue = 0U;
        Vram1___024root___eval_triggers__stl(vlSelf);
        if (vlSelf->__VstlTriggered.any()) {
            __VstlContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VstlIterCount))) {
#ifdef VL_DEBUG
                Vram1___024root___dump_triggers__stl(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/ram/vsrc/ram1.v", 1, "", "Settle region did not converge.");
            }
            vlSelf->__VstlIterCount = ((IData)(1U) 
                                       + vlSelf->__VstlIterCount);
            Vram1___024root___eval_stl(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vram1___024root___dump_triggers__stl(Vram1___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vram1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram1___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VstlTriggered.at(0U)) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vram1___024root___stl_sequent__TOP__0(Vram1___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vram1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram1___024root___stl_sequent__TOP__0\n"); );
    // Body
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

VL_ATTR_COLD void Vram1___024root___eval_stl(Vram1___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vram1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram1___024root___eval_stl\n"); );
    // Body
    if (vlSelf->__VstlTriggered.at(0U)) {
        Vram1___024root___stl_sequent__TOP__0(vlSelf);
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vram1___024root___dump_triggers__act(Vram1___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vram1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram1___024root___dump_triggers__act\n"); );
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
VL_ATTR_COLD void Vram1___024root___dump_triggers__nba(Vram1___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vram1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram1___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VnbaTriggered.at(0U)) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vram1___024root___ctor_var_reset(Vram1___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vram1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vram1___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = 0;
    vlSelf->seg0 = 0;
    vlSelf->seg1 = 0;
    vlSelf->en = 0;
    vlSelf->inputaddr = 0;
    vlSelf->outputaddr = 0;
    vlSelf->in = 0;
    vlSelf->out = 0;
    for (int __Vi0 = 0; __Vi0 < 16; ++__Vi0) {
        vlSelf->ram1__DOT__ram1[__Vi0] = 0;
    }
    vlSelf->__Vtrigrprev__TOP__clk = 0;
}
