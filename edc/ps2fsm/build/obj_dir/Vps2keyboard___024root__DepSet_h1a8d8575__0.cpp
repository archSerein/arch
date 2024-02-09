// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vps2keyboard.h for the primary calling header

#include "verilated.h"

#include "Vps2keyboard___024root.h"

void Vps2keyboard___024root___eval_act(Vps2keyboard___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vps2keyboard__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vps2keyboard___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vps2keyboard___024root___nba_sequent__TOP__0(Vps2keyboard___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vps2keyboard__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vps2keyboard___024root___nba_sequent__TOP__0\n"); );
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
    CData/*2:0*/ __Vdly__ps2keyboard__DOT__ps2_clk_sync;
    __Vdly__ps2keyboard__DOT__ps2_clk_sync = 0;
    CData/*2:0*/ __Vdly__ps2keyboard__DOT__r_ptr;
    __Vdly__ps2keyboard__DOT__r_ptr = 0;
    CData/*2:0*/ __Vdlyvdim0__ps2keyboard__DOT__fifo__v0;
    __Vdlyvdim0__ps2keyboard__DOT__fifo__v0 = 0;
    CData/*7:0*/ __Vdlyvval__ps2keyboard__DOT__fifo__v0;
    __Vdlyvval__ps2keyboard__DOT__fifo__v0 = 0;
    CData/*0:0*/ __Vdlyvset__ps2keyboard__DOT__fifo__v0;
    __Vdlyvset__ps2keyboard__DOT__fifo__v0 = 0;
    CData/*7:0*/ __Vdlyvdim0__ps2keyboard__DOT__times__v0;
    __Vdlyvdim0__ps2keyboard__DOT__times__v0 = 0;
    CData/*7:0*/ __Vdlyvval__ps2keyboard__DOT__times__v0;
    __Vdlyvval__ps2keyboard__DOT__times__v0 = 0;
    CData/*0:0*/ __Vdlyvset__ps2keyboard__DOT__times__v0;
    __Vdlyvset__ps2keyboard__DOT__times__v0 = 0;
    CData/*2:0*/ __Vdly__ps2keyboard__DOT__w_ptr;
    __Vdly__ps2keyboard__DOT__w_ptr = 0;
    CData/*3:0*/ __Vdly__ps2keyboard__DOT__count;
    __Vdly__ps2keyboard__DOT__count = 0;
    // Body
    __Vdly__ps2keyboard__DOT__ps2_clk_sync = vlSelf->ps2keyboard__DOT__ps2_clk_sync;
    __Vdly__ps2keyboard__DOT__count = vlSelf->ps2keyboard__DOT__count;
    __Vdly__ps2keyboard__DOT__w_ptr = vlSelf->ps2keyboard__DOT__w_ptr;
    __Vdlyvset__ps2keyboard__DOT__times__v0 = 0U;
    __Vdly__ps2keyboard__DOT__r_ptr = vlSelf->ps2keyboard__DOT__r_ptr;
    __Vdlyvset__ps2keyboard__DOT__fifo__v0 = 0U;
    __Vdly__ps2keyboard__DOT__ps2_clk_sync = ((6U & 
                                               ((IData)(vlSelf->ps2keyboard__DOT__ps2_clk_sync) 
                                                << 1U)) 
                                              | (IData)(vlSelf->ps2_clk));
    if (vlSelf->clrn) {
        if (vlSelf->ready) {
            if ((1U & (~ (IData)(vlSelf->ps2keyboard__DOT__nextdata_n)))) {
                __Vdly__ps2keyboard__DOT__r_ptr = (7U 
                                                   & ((IData)(1U) 
                                                      + (IData)(vlSelf->ps2keyboard__DOT__r_ptr)));
                if (((IData)(vlSelf->ps2keyboard__DOT__w_ptr) 
                     == (7U & ((IData)(1U) + (IData)(vlSelf->ps2keyboard__DOT__r_ptr))))) {
                    vlSelf->ps2keyboard__DOT__nextdata_n = 1U;
                    vlSelf->ready = 0U;
                }
            }
        }
        if ((IData)((4U == (6U & (IData)(vlSelf->ps2keyboard__DOT__ps2_clk_sync))))) {
            if ((0xaU == (IData)(vlSelf->ps2keyboard__DOT__count))) {
                if ((((~ (IData)(vlSelf->ps2keyboard__DOT__buffer)) 
                      & (IData)(vlSelf->ps2_data)) 
                     & VL_REDXOR_32((0x1ffU & ((IData)(vlSelf->ps2keyboard__DOT__buffer) 
                                               >> 1U))))) {
                    __Vdlyvval__ps2keyboard__DOT__fifo__v0 
                        = (0xffU & ((IData)(vlSelf->ps2keyboard__DOT__buffer) 
                                    >> 1U));
                    __Vdlyvset__ps2keyboard__DOT__fifo__v0 = 1U;
                    __Vdlyvdim0__ps2keyboard__DOT__fifo__v0 
                        = vlSelf->ps2keyboard__DOT__w_ptr;
                    if ((0xf0U == vlSelf->ps2keyboard__DOT__fifo
                         [(7U & ((IData)(vlSelf->ps2keyboard__DOT__w_ptr) 
                                 - (IData)(1U)))])) {
                        __Vdlyvval__ps2keyboard__DOT__times__v0 
                            = (0xffU & ((IData)(1U) 
                                        + vlSelf->ps2keyboard__DOT__times
                                        [(0xffU & ((IData)(vlSelf->ps2keyboard__DOT__buffer) 
                                                   >> 1U))]));
                        __Vdlyvset__ps2keyboard__DOT__times__v0 = 1U;
                        __Vdlyvdim0__ps2keyboard__DOT__times__v0 
                            = (0xffU & ((IData)(vlSelf->ps2keyboard__DOT__buffer) 
                                        >> 1U));
                    }
                    __Vdly__ps2keyboard__DOT__w_ptr 
                        = (7U & ((IData)(1U) + (IData)(vlSelf->ps2keyboard__DOT__w_ptr)));
                    vlSelf->ready = 1U;
                    vlSelf->ps2keyboard__DOT__nextdata_n = 0U;
                    vlSelf->overflow = ((IData)(vlSelf->overflow) 
                                        | ((IData)(vlSelf->ps2keyboard__DOT__r_ptr) 
                                           == (7U & 
                                               ((IData)(1U) 
                                                + (IData)(vlSelf->ps2keyboard__DOT__w_ptr)))));
                }
                __Vdly__ps2keyboard__DOT__count = 0U;
            } else {
                vlSelf->ps2keyboard__DOT____Vlvbound_h1a91ade8__0 
                    = vlSelf->ps2_data;
                if ((9U >= (IData)(vlSelf->ps2keyboard__DOT__count))) {
                    vlSelf->ps2keyboard__DOT__buffer 
                        = (((~ ((IData)(1U) << (IData)(vlSelf->ps2keyboard__DOT__count))) 
                            & (IData)(vlSelf->ps2keyboard__DOT__buffer)) 
                           | (0x3ffU & ((IData)(vlSelf->ps2keyboard__DOT____Vlvbound_h1a91ade8__0) 
                                        << (IData)(vlSelf->ps2keyboard__DOT__count))));
                }
                __Vdly__ps2keyboard__DOT__count = (0xfU 
                                                   & ((IData)(1U) 
                                                      + (IData)(vlSelf->ps2keyboard__DOT__count)));
            }
        }
    } else {
        __Vdly__ps2keyboard__DOT__count = 0U;
        __Vdly__ps2keyboard__DOT__w_ptr = 0U;
        __Vdly__ps2keyboard__DOT__r_ptr = 0U;
        vlSelf->overflow = 0U;
        vlSelf->ready = 0U;
    }
    vlSelf->ps2keyboard__DOT__ps2_clk_sync = __Vdly__ps2keyboard__DOT__ps2_clk_sync;
    vlSelf->ps2keyboard__DOT__count = __Vdly__ps2keyboard__DOT__count;
    vlSelf->ps2keyboard__DOT__w_ptr = __Vdly__ps2keyboard__DOT__w_ptr;
    if (__Vdlyvset__ps2keyboard__DOT__times__v0) {
        vlSelf->ps2keyboard__DOT__times[__Vdlyvdim0__ps2keyboard__DOT__times__v0] 
            = __Vdlyvval__ps2keyboard__DOT__times__v0;
    }
    vlSelf->ps2keyboard__DOT__r_ptr = __Vdly__ps2keyboard__DOT__r_ptr;
    if (__Vdlyvset__ps2keyboard__DOT__fifo__v0) {
        vlSelf->ps2keyboard__DOT__fifo[__Vdlyvdim0__ps2keyboard__DOT__fifo__v0] 
            = __Vdlyvval__ps2keyboard__DOT__fifo__v0;
    }
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

void Vps2keyboard___024root___eval_nba(Vps2keyboard___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vps2keyboard__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vps2keyboard___024root___eval_nba\n"); );
    // Body
    if (vlSelf->__VnbaTriggered.at(0U)) {
        Vps2keyboard___024root___nba_sequent__TOP__0(vlSelf);
    }
}

void Vps2keyboard___024root___eval_triggers__act(Vps2keyboard___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vps2keyboard___024root___dump_triggers__act(Vps2keyboard___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vps2keyboard___024root___dump_triggers__nba(Vps2keyboard___024root* vlSelf);
#endif  // VL_DEBUG

void Vps2keyboard___024root___eval(Vps2keyboard___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vps2keyboard__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vps2keyboard___024root___eval\n"); );
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
            Vps2keyboard___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vps2keyboard___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/ps2fsm/vsrc/ps2keyboard.v", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.set(vlSelf->__VactTriggered);
                Vps2keyboard___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vps2keyboard___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/ps2fsm/vsrc/ps2keyboard.v", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vps2keyboard___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vps2keyboard___024root___eval_debug_assertions(Vps2keyboard___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vps2keyboard__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vps2keyboard___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->clrn & 0xfeU))) {
        Verilated::overWidthError("clrn");}
    if (VL_UNLIKELY((vlSelf->ps2_data & 0xfeU))) {
        Verilated::overWidthError("ps2_data");}
    if (VL_UNLIKELY((vlSelf->ps2_clk & 0xfeU))) {
        Verilated::overWidthError("ps2_clk");}
}
#endif  // VL_DEBUG
