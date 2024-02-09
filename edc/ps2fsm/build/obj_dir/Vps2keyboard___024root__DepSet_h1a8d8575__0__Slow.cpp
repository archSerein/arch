// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vps2keyboard.h for the primary calling header

#include "verilated.h"

#include "Vps2keyboard___024root.h"

VL_ATTR_COLD void Vps2keyboard___024root___eval_static(Vps2keyboard___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vps2keyboard__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vps2keyboard___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vps2keyboard___024root___eval_initial__TOP(Vps2keyboard___024root* vlSelf);

VL_ATTR_COLD void Vps2keyboard___024root___eval_initial(Vps2keyboard___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vps2keyboard__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vps2keyboard___024root___eval_initial\n"); );
    // Body
    Vps2keyboard___024root___eval_initial__TOP(vlSelf);
    vlSelf->__Vtrigrprev__TOP__clk = vlSelf->clk;
}

VL_ATTR_COLD void Vps2keyboard___024root___eval_initial__TOP(Vps2keyboard___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vps2keyboard__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vps2keyboard___024root___eval_initial__TOP\n"); );
    // Init
    IData/*31:0*/ __Vilp;
    // Body
    __Vilp = 0U;
    while ((__Vilp <= 0xffU)) {
        vlSelf->ps2keyboard__DOT__times[__Vilp] = 0U;
        __Vilp = ((IData)(1U) + __Vilp);
    }
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x45U] = 0x30U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x16U] = 0x31U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x1eU] = 0x32U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x26U] = 0x33U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x25U] = 0x34U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x2eU] = 0x35U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x36U] = 0x36U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x3dU] = 0x37U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x3eU] = 0x38U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x46U] = 0x39U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x1cU] = 0x41U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x32U] = 0x42U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x21U] = 0x43U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x23U] = 0x44U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x24U] = 0x45U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x2bU] = 0x46U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x34U] = 0x47U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x33U] = 0x48U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x43U] = 0x49U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x3bU] = 0x4aU;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x42U] = 0x4bU;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x4bU] = 0x4cU;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x3aU] = 0x4dU;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x31U] = 0x4eU;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x44U] = 0x4fU;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x4dU] = 0x50U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x15U] = 0x51U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x2dU] = 0x52U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x1bU] = 0x53U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x2cU] = 0x54U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x3cU] = 0x55U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x2aU] = 0x56U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x1dU] = 0x57U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x22U] = 0x58U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x35U] = 0x59U;
    vlSelf->ps2keyboard__DOT__transl__DOT__rom[0x1aU] = 0x5aU;
}

VL_ATTR_COLD void Vps2keyboard___024root___eval_final(Vps2keyboard___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vps2keyboard__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vps2keyboard___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vps2keyboard___024root___eval_triggers__stl(Vps2keyboard___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vps2keyboard___024root___dump_triggers__stl(Vps2keyboard___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD void Vps2keyboard___024root___eval_stl(Vps2keyboard___024root* vlSelf);

VL_ATTR_COLD void Vps2keyboard___024root___eval_settle(Vps2keyboard___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vps2keyboard__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vps2keyboard___024root___eval_settle\n"); );
    // Init
    CData/*0:0*/ __VstlContinue;
    // Body
    vlSelf->__VstlIterCount = 0U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        __VstlContinue = 0U;
        Vps2keyboard___024root___eval_triggers__stl(vlSelf);
        if (vlSelf->__VstlTriggered.any()) {
            __VstlContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VstlIterCount))) {
#ifdef VL_DEBUG
                Vps2keyboard___024root___dump_triggers__stl(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/ps2fsm/vsrc/ps2keyboard.v", 1, "", "Settle region did not converge.");
            }
            vlSelf->__VstlIterCount = ((IData)(1U) 
                                       + vlSelf->__VstlIterCount);
            Vps2keyboard___024root___eval_stl(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vps2keyboard___024root___dump_triggers__stl(Vps2keyboard___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vps2keyboard__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vps2keyboard___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VstlTriggered.at(0U)) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vps2keyboard___024root___stl_sequent__TOP__0(Vps2keyboard___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vps2keyboard__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vps2keyboard___024root___stl_sequent__TOP__0\n"); );
    // Init
    CData/*7:0*/ ps2keyboard__DOT__counts;
    ps2keyboard__DOT__counts = 0;
    CData/*7:0*/ ps2keyboard__DOT__data;
    ps2keyboard__DOT__data = 0;
    CData/*7:0*/ ps2keyboard__DOT__ascii;
    ps2keyboard__DOT__ascii = 0;
    CData/*6:0*/ ps2keyboard__DOT__segl__DOT__show__Vstatic__seg;
    ps2keyboard__DOT__segl__DOT__show__Vstatic__seg = 0;
    CData/*6:0*/ __Vfunc_ps2keyboard__DOT__segl__DOT__show__0__Vfuncout;
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__0__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data;
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data = 0;
    CData/*6:0*/ __Vfunc_ps2keyboard__DOT__segl__DOT__show__1__Vfuncout;
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__1__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data;
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data = 0;
    CData/*6:0*/ __Vfunc_ps2keyboard__DOT__segl__DOT__show__2__Vfuncout;
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__2__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data;
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data = 0;
    CData/*6:0*/ __Vfunc_ps2keyboard__DOT__segl__DOT__show__3__Vfuncout;
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__3__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data;
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data = 0;
    CData/*6:0*/ __Vfunc_ps2keyboard__DOT__segl__DOT__show__4__Vfuncout;
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__4__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data;
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data = 0;
    CData/*6:0*/ __Vfunc_ps2keyboard__DOT__segl__DOT__show__5__Vfuncout;
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__5__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data;
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data = 0;
    // Body
    vlSelf->led = ((0xf0U == vlSelf->ps2keyboard__DOT__fifo
                    [vlSelf->ps2keyboard__DOT__w_ptr])
                    ? 0xf0U : 0xfU);
    ps2keyboard__DOT__data = vlSelf->ps2keyboard__DOT__fifo
        [vlSelf->ps2keyboard__DOT__r_ptr];
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data 
        = (0xfU & (IData)(ps2keyboard__DOT__data));
    ps2keyboard__DOT__segl__DOT__show__Vstatic__seg 
        = ((0U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data))
            ? 1U : ((1U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data))
                     ? 0x4fU : ((2U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data))
                                 ? 0x12U : ((3U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data))
                                             ? 6U : 
                                            ((4U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data))
                                              ? 0x4cU
                                              : ((5U 
                                                  == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data))
                                                  ? 0x24U
                                                  : 
                                                 ((6U 
                                                   == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data))
                                                   ? 0x20U
                                                   : 
                                                  ((7U 
                                                    == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data))
                                                    ? 0xfU
                                                    : 
                                                   ((8U 
                                                     == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data))
                                                     ? 0U
                                                     : 
                                                    ((9U 
                                                      == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data))
                                                      ? 4U
                                                      : 
                                                     ((0xaU 
                                                       == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data))
                                                       ? 8U
                                                       : 
                                                      ((0xbU 
                                                        == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data))
                                                        ? 0x60U
                                                        : 
                                                       ((0xcU 
                                                         == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data))
                                                         ? 0x31U
                                                         : 
                                                        ((0xdU 
                                                          == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data))
                                                          ? 0x42U
                                                          : 
                                                         ((0xeU 
                                                           == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data))
                                                           ? 0x30U
                                                           : 
                                                          ((0xfU 
                                                            == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__0__data))
                                                            ? 0x38U
                                                            : 0x7fU))))))))))))))));
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__0__Vfuncout 
        = ps2keyboard__DOT__segl__DOT__show__Vstatic__seg;
    vlSelf->seg0 = __Vfunc_ps2keyboard__DOT__segl__DOT__show__0__Vfuncout;
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data 
        = (0xfU & ((IData)(ps2keyboard__DOT__data) 
                   >> 4U));
    ps2keyboard__DOT__segl__DOT__show__Vstatic__seg 
        = ((0U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data))
            ? 1U : ((1U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data))
                     ? 0x4fU : ((2U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data))
                                 ? 0x12U : ((3U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data))
                                             ? 6U : 
                                            ((4U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data))
                                              ? 0x4cU
                                              : ((5U 
                                                  == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data))
                                                  ? 0x24U
                                                  : 
                                                 ((6U 
                                                   == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data))
                                                   ? 0x20U
                                                   : 
                                                  ((7U 
                                                    == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data))
                                                    ? 0xfU
                                                    : 
                                                   ((8U 
                                                     == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data))
                                                     ? 0U
                                                     : 
                                                    ((9U 
                                                      == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data))
                                                      ? 4U
                                                      : 
                                                     ((0xaU 
                                                       == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data))
                                                       ? 8U
                                                       : 
                                                      ((0xbU 
                                                        == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data))
                                                        ? 0x60U
                                                        : 
                                                       ((0xcU 
                                                         == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data))
                                                         ? 0x31U
                                                         : 
                                                        ((0xdU 
                                                          == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data))
                                                          ? 0x42U
                                                          : 
                                                         ((0xeU 
                                                           == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data))
                                                           ? 0x30U
                                                           : 
                                                          ((0xfU 
                                                            == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__1__data))
                                                            ? 0x38U
                                                            : 0x7fU))))))))))))))));
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__1__Vfuncout 
        = ps2keyboard__DOT__segl__DOT__show__Vstatic__seg;
    vlSelf->seg1 = __Vfunc_ps2keyboard__DOT__segl__DOT__show__1__Vfuncout;
    ps2keyboard__DOT__counts = ((0xf0U == (IData)(ps2keyboard__DOT__data))
                                 ? 0U : vlSelf->ps2keyboard__DOT__times
                                [ps2keyboard__DOT__data]);
    ps2keyboard__DOT__ascii = vlSelf->ps2keyboard__DOT__transl__DOT__rom
        [ps2keyboard__DOT__data];
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data 
        = (0xfU & (IData)(ps2keyboard__DOT__counts));
    ps2keyboard__DOT__segl__DOT__show__Vstatic__seg 
        = ((0U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data))
            ? 1U : ((1U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data))
                     ? 0x4fU : ((2U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data))
                                 ? 0x12U : ((3U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data))
                                             ? 6U : 
                                            ((4U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data))
                                              ? 0x4cU
                                              : ((5U 
                                                  == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data))
                                                  ? 0x24U
                                                  : 
                                                 ((6U 
                                                   == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data))
                                                   ? 0x20U
                                                   : 
                                                  ((7U 
                                                    == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data))
                                                    ? 0xfU
                                                    : 
                                                   ((8U 
                                                     == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data))
                                                     ? 0U
                                                     : 
                                                    ((9U 
                                                      == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data))
                                                      ? 4U
                                                      : 
                                                     ((0xaU 
                                                       == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data))
                                                       ? 8U
                                                       : 
                                                      ((0xbU 
                                                        == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data))
                                                        ? 0x60U
                                                        : 
                                                       ((0xcU 
                                                         == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data))
                                                         ? 0x31U
                                                         : 
                                                        ((0xdU 
                                                          == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data))
                                                          ? 0x42U
                                                          : 
                                                         ((0xeU 
                                                           == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data))
                                                           ? 0x30U
                                                           : 
                                                          ((0xfU 
                                                            == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__4__data))
                                                            ? 0x38U
                                                            : 0x7fU))))))))))))))));
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__4__Vfuncout 
        = ps2keyboard__DOT__segl__DOT__show__Vstatic__seg;
    vlSelf->seg4 = __Vfunc_ps2keyboard__DOT__segl__DOT__show__4__Vfuncout;
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data 
        = (0xfU & ((IData)(ps2keyboard__DOT__counts) 
                   >> 4U));
    ps2keyboard__DOT__segl__DOT__show__Vstatic__seg 
        = ((0U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data))
            ? 1U : ((1U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data))
                     ? 0x4fU : ((2U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data))
                                 ? 0x12U : ((3U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data))
                                             ? 6U : 
                                            ((4U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data))
                                              ? 0x4cU
                                              : ((5U 
                                                  == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data))
                                                  ? 0x24U
                                                  : 
                                                 ((6U 
                                                   == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data))
                                                   ? 0x20U
                                                   : 
                                                  ((7U 
                                                    == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data))
                                                    ? 0xfU
                                                    : 
                                                   ((8U 
                                                     == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data))
                                                     ? 0U
                                                     : 
                                                    ((9U 
                                                      == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data))
                                                      ? 4U
                                                      : 
                                                     ((0xaU 
                                                       == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data))
                                                       ? 8U
                                                       : 
                                                      ((0xbU 
                                                        == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data))
                                                        ? 0x60U
                                                        : 
                                                       ((0xcU 
                                                         == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data))
                                                         ? 0x31U
                                                         : 
                                                        ((0xdU 
                                                          == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data))
                                                          ? 0x42U
                                                          : 
                                                         ((0xeU 
                                                           == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data))
                                                           ? 0x30U
                                                           : 
                                                          ((0xfU 
                                                            == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__5__data))
                                                            ? 0x38U
                                                            : 0x7fU))))))))))))))));
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__5__Vfuncout 
        = ps2keyboard__DOT__segl__DOT__show__Vstatic__seg;
    vlSelf->seg5 = __Vfunc_ps2keyboard__DOT__segl__DOT__show__5__Vfuncout;
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data 
        = (0xfU & (IData)(ps2keyboard__DOT__ascii));
    ps2keyboard__DOT__segl__DOT__show__Vstatic__seg 
        = ((0U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data))
            ? 1U : ((1U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data))
                     ? 0x4fU : ((2U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data))
                                 ? 0x12U : ((3U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data))
                                             ? 6U : 
                                            ((4U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data))
                                              ? 0x4cU
                                              : ((5U 
                                                  == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data))
                                                  ? 0x24U
                                                  : 
                                                 ((6U 
                                                   == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data))
                                                   ? 0x20U
                                                   : 
                                                  ((7U 
                                                    == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data))
                                                    ? 0xfU
                                                    : 
                                                   ((8U 
                                                     == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data))
                                                     ? 0U
                                                     : 
                                                    ((9U 
                                                      == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data))
                                                      ? 4U
                                                      : 
                                                     ((0xaU 
                                                       == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data))
                                                       ? 8U
                                                       : 
                                                      ((0xbU 
                                                        == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data))
                                                        ? 0x60U
                                                        : 
                                                       ((0xcU 
                                                         == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data))
                                                         ? 0x31U
                                                         : 
                                                        ((0xdU 
                                                          == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data))
                                                          ? 0x42U
                                                          : 
                                                         ((0xeU 
                                                           == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data))
                                                           ? 0x30U
                                                           : 
                                                          ((0xfU 
                                                            == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__2__data))
                                                            ? 0x38U
                                                            : 0x7fU))))))))))))))));
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__2__Vfuncout 
        = ps2keyboard__DOT__segl__DOT__show__Vstatic__seg;
    vlSelf->seg2 = __Vfunc_ps2keyboard__DOT__segl__DOT__show__2__Vfuncout;
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data 
        = (0xfU & ((IData)(ps2keyboard__DOT__ascii) 
                   >> 4U));
    ps2keyboard__DOT__segl__DOT__show__Vstatic__seg 
        = ((0U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data))
            ? 1U : ((1U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data))
                     ? 0x4fU : ((2U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data))
                                 ? 0x12U : ((3U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data))
                                             ? 6U : 
                                            ((4U == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data))
                                              ? 0x4cU
                                              : ((5U 
                                                  == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data))
                                                  ? 0x24U
                                                  : 
                                                 ((6U 
                                                   == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data))
                                                   ? 0x20U
                                                   : 
                                                  ((7U 
                                                    == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data))
                                                    ? 0xfU
                                                    : 
                                                   ((8U 
                                                     == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data))
                                                     ? 0U
                                                     : 
                                                    ((9U 
                                                      == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data))
                                                      ? 4U
                                                      : 
                                                     ((0xaU 
                                                       == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data))
                                                       ? 8U
                                                       : 
                                                      ((0xbU 
                                                        == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data))
                                                        ? 0x60U
                                                        : 
                                                       ((0xcU 
                                                         == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data))
                                                         ? 0x31U
                                                         : 
                                                        ((0xdU 
                                                          == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data))
                                                          ? 0x42U
                                                          : 
                                                         ((0xeU 
                                                           == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data))
                                                           ? 0x30U
                                                           : 
                                                          ((0xfU 
                                                            == (IData)(__Vfunc_ps2keyboard__DOT__segl__DOT__show__3__data))
                                                            ? 0x38U
                                                            : 0x7fU))))))))))))))));
    __Vfunc_ps2keyboard__DOT__segl__DOT__show__3__Vfuncout 
        = ps2keyboard__DOT__segl__DOT__show__Vstatic__seg;
    vlSelf->seg3 = __Vfunc_ps2keyboard__DOT__segl__DOT__show__3__Vfuncout;
}

VL_ATTR_COLD void Vps2keyboard___024root___eval_stl(Vps2keyboard___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vps2keyboard__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vps2keyboard___024root___eval_stl\n"); );
    // Body
    if (vlSelf->__VstlTriggered.at(0U)) {
        Vps2keyboard___024root___stl_sequent__TOP__0(vlSelf);
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vps2keyboard___024root___dump_triggers__act(Vps2keyboard___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vps2keyboard__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vps2keyboard___024root___dump_triggers__act\n"); );
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
VL_ATTR_COLD void Vps2keyboard___024root___dump_triggers__nba(Vps2keyboard___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vps2keyboard__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vps2keyboard___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VnbaTriggered.at(0U)) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vps2keyboard___024root___ctor_var_reset(Vps2keyboard___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vps2keyboard__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vps2keyboard___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = 0;
    vlSelf->clrn = 0;
    vlSelf->ps2_data = 0;
    vlSelf->ready = 0;
    vlSelf->overflow = 0;
    vlSelf->ps2_clk = 0;
    vlSelf->seg0 = 0;
    vlSelf->seg1 = 0;
    vlSelf->seg2 = 0;
    vlSelf->seg3 = 0;
    vlSelf->seg4 = 0;
    vlSelf->seg5 = 0;
    vlSelf->led = 0;
    for (int __Vi0 = 0; __Vi0 < 256; ++__Vi0) {
        vlSelf->ps2keyboard__DOT__times[__Vi0] = 0;
    }
    vlSelf->ps2keyboard__DOT__buffer = 0;
    for (int __Vi0 = 0; __Vi0 < 8; ++__Vi0) {
        vlSelf->ps2keyboard__DOT__fifo[__Vi0] = 0;
    }
    vlSelf->ps2keyboard__DOT__w_ptr = 0;
    vlSelf->ps2keyboard__DOT__r_ptr = 0;
    vlSelf->ps2keyboard__DOT__count = 0;
    vlSelf->ps2keyboard__DOT__nextdata_n = 0;
    vlSelf->ps2keyboard__DOT__ps2_clk_sync = 0;
    vlSelf->ps2keyboard__DOT____Vlvbound_h1a91ade8__0 = 0;
    for (int __Vi0 = 0; __Vi0 < 256; ++__Vi0) {
        vlSelf->ps2keyboard__DOT__transl__DOT__rom[__Vi0] = 0;
    }
    vlSelf->__Vtrigrprev__TOP__clk = 0;
}
