// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "verilated.h"

#include "Vtop___024root.h"

VL_INLINE_OPT void Vtop___024root___ico_sequent__TOP__0(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___ico_sequent__TOP__0\n"); );
    // Init
    QData/*32:0*/ top__DOT__myalu__DOT__sum;
    top__DOT__myalu__DOT__sum = 0;
    CData/*6:0*/ top__DOT__myseg__DOT__show__Vstatic__seg;
    top__DOT__myseg__DOT__show__Vstatic__seg = 0;
    CData/*6:0*/ __Vfunc_top__DOT__myseg__DOT__show__0__Vfuncout;
    __Vfunc_top__DOT__myseg__DOT__show__0__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_top__DOT__myseg__DOT__show__0__data;
    __Vfunc_top__DOT__myseg__DOT__show__0__data = 0;
    CData/*6:0*/ __Vfunc_top__DOT__myseg__DOT__show__1__Vfuncout;
    __Vfunc_top__DOT__myseg__DOT__show__1__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_top__DOT__myseg__DOT__show__1__data;
    __Vfunc_top__DOT__myseg__DOT__show__1__data = 0;
    CData/*6:0*/ __Vfunc_top__DOT__myseg__DOT__show__2__Vfuncout;
    __Vfunc_top__DOT__myseg__DOT__show__2__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_top__DOT__myseg__DOT__show__2__data;
    __Vfunc_top__DOT__myseg__DOT__show__2__data = 0;
    CData/*6:0*/ __Vfunc_top__DOT__myseg__DOT__show__3__Vfuncout;
    __Vfunc_top__DOT__myseg__DOT__show__3__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_top__DOT__myseg__DOT__show__3__data;
    __Vfunc_top__DOT__myseg__DOT__show__3__data = 0;
    CData/*6:0*/ __Vfunc_top__DOT__myseg__DOT__show__4__Vfuncout;
    __Vfunc_top__DOT__myseg__DOT__show__4__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_top__DOT__myseg__DOT__show__4__data;
    __Vfunc_top__DOT__myseg__DOT__show__4__data = 0;
    CData/*6:0*/ __Vfunc_top__DOT__myseg__DOT__show__5__Vfuncout;
    __Vfunc_top__DOT__myseg__DOT__show__5__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_top__DOT__myseg__DOT__show__5__data;
    __Vfunc_top__DOT__myseg__DOT__show__5__data = 0;
    CData/*6:0*/ __Vfunc_top__DOT__myseg__DOT__show__6__Vfuncout;
    __Vfunc_top__DOT__myseg__DOT__show__6__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_top__DOT__myseg__DOT__show__6__data;
    __Vfunc_top__DOT__myseg__DOT__show__6__data = 0;
    CData/*6:0*/ __Vfunc_top__DOT__myseg__DOT__show__7__Vfuncout;
    __Vfunc_top__DOT__myseg__DOT__show__7__Vfuncout = 0;
    CData/*3:0*/ __Vfunc_top__DOT__myseg__DOT__show__7__data;
    __Vfunc_top__DOT__myseg__DOT__show__7__data = 0;
    // Body
    vlSelf->busa = vlSelf->top__DOT__myreg__DOT__regfile
        [vlSelf->ra];
    vlSelf->busb = vlSelf->top__DOT__myreg__DOT__regfile
        [vlSelf->rb];
    top__DOT__myalu__DOT__sum = (0x1ffffffffULL & ((QData)((IData)(vlSelf->a)) 
                                                   + 
                                                   ((QData)((IData)(
                                                                    (vlSelf->b 
                                                                     ^ 
                                                                     (- (IData)(
                                                                                (1U 
                                                                                & ((IData)(vlSelf->aluc) 
                                                                                >> 3U))))))) 
                                                    + (QData)((IData)(
                                                                      (1U 
                                                                       & ((IData)(vlSelf->aluc) 
                                                                          >> 3U)))))));
    vlSelf->zero = (0U == (IData)(top__DOT__myalu__DOT__sum));
    vlSelf->less = (1U & ((8U & (IData)(vlSelf->aluc))
                           ? ((IData)((top__DOT__myalu__DOT__sum 
                                       >> 0x20U)) ^ 
                              ((IData)(vlSelf->aluc) 
                               >> 3U)) : ((IData)((top__DOT__myalu__DOT__sum 
                                                   >> 0x20U)) 
                                          ^ ((IData)(
                                                     (top__DOT__myalu__DOT__sum 
                                                      >> 0x1fU)) 
                                             ^ (IData)(
                                                       (3ULL 
                                                        & ((1ULL 
                                                            + 
                                                            ((QData)((IData)(vlSelf->a)) 
                                                             + (QData)((IData)(
                                                                               (~ vlSelf->b))))) 
                                                           >> 0x1fU)))))));
    vlSelf->out = ((0U == (7U & (IData)(vlSelf->aluc)))
                    ? (IData)(top__DOT__myalu__DOT__sum)
                    : ((1U == (7U & (IData)(vlSelf->aluc)))
                        ? (vlSelf->a << (0x1fU & vlSelf->b))
                        : ((2U == (7U & (IData)(vlSelf->aluc)))
                            ? (IData)(vlSelf->less)
                            : ((3U == (7U & (IData)(vlSelf->aluc)))
                                ? vlSelf->b : ((4U 
                                                == 
                                                (7U 
                                                 & (IData)(vlSelf->aluc)))
                                                ? (vlSelf->a 
                                                   ^ vlSelf->b)
                                                : (
                                                   (5U 
                                                    == 
                                                    (7U 
                                                     & (IData)(vlSelf->aluc)))
                                                    ? 
                                                   (vlSelf->a 
                                                    >> 
                                                    (0x1fU 
                                                     & vlSelf->b))
                                                    : 
                                                   ((6U 
                                                     == 
                                                     (7U 
                                                      & (IData)(vlSelf->aluc)))
                                                     ? 
                                                    (vlSelf->a 
                                                     | vlSelf->b)
                                                     : 
                                                    ((7U 
                                                      == 
                                                      (7U 
                                                       & (IData)(vlSelf->aluc)))
                                                      ? 
                                                     (vlSelf->a 
                                                      & vlSelf->b)
                                                      : 0U))))))));
    __Vfunc_top__DOT__myseg__DOT__show__0__data = (0xfU 
                                                   & vlSelf->out);
    top__DOT__myseg__DOT__show__Vstatic__seg = ((0U 
                                                 == (IData)(__Vfunc_top__DOT__myseg__DOT__show__0__data))
                                                 ? 1U
                                                 : 
                                                ((1U 
                                                  == (IData)(__Vfunc_top__DOT__myseg__DOT__show__0__data))
                                                  ? 0x4fU
                                                  : 
                                                 ((2U 
                                                   == (IData)(__Vfunc_top__DOT__myseg__DOT__show__0__data))
                                                   ? 0x12U
                                                   : 
                                                  ((3U 
                                                    == (IData)(__Vfunc_top__DOT__myseg__DOT__show__0__data))
                                                    ? 6U
                                                    : 
                                                   ((4U 
                                                     == (IData)(__Vfunc_top__DOT__myseg__DOT__show__0__data))
                                                     ? 0x4cU
                                                     : 
                                                    ((5U 
                                                      == (IData)(__Vfunc_top__DOT__myseg__DOT__show__0__data))
                                                      ? 0x24U
                                                      : 
                                                     ((6U 
                                                       == (IData)(__Vfunc_top__DOT__myseg__DOT__show__0__data))
                                                       ? 0x20U
                                                       : 
                                                      ((7U 
                                                        == (IData)(__Vfunc_top__DOT__myseg__DOT__show__0__data))
                                                        ? 0xfU
                                                        : 
                                                       ((8U 
                                                         == (IData)(__Vfunc_top__DOT__myseg__DOT__show__0__data))
                                                         ? 0U
                                                         : 
                                                        ((9U 
                                                          == (IData)(__Vfunc_top__DOT__myseg__DOT__show__0__data))
                                                          ? 4U
                                                          : 
                                                         ((0xaU 
                                                           == (IData)(__Vfunc_top__DOT__myseg__DOT__show__0__data))
                                                           ? 8U
                                                           : 
                                                          ((0xbU 
                                                            == (IData)(__Vfunc_top__DOT__myseg__DOT__show__0__data))
                                                            ? 0x60U
                                                            : 
                                                           ((0xcU 
                                                             == (IData)(__Vfunc_top__DOT__myseg__DOT__show__0__data))
                                                             ? 0x31U
                                                             : 
                                                            ((0xdU 
                                                              == (IData)(__Vfunc_top__DOT__myseg__DOT__show__0__data))
                                                              ? 0x42U
                                                              : 
                                                             ((0xeU 
                                                               == (IData)(__Vfunc_top__DOT__myseg__DOT__show__0__data))
                                                               ? 0x30U
                                                               : 
                                                              ((0xfU 
                                                                == (IData)(__Vfunc_top__DOT__myseg__DOT__show__0__data))
                                                                ? 0x38U
                                                                : 0x7fU))))))))))))))));
    __Vfunc_top__DOT__myseg__DOT__show__0__Vfuncout 
        = top__DOT__myseg__DOT__show__Vstatic__seg;
    vlSelf->seg0 = __Vfunc_top__DOT__myseg__DOT__show__0__Vfuncout;
    __Vfunc_top__DOT__myseg__DOT__show__1__data = (0xfU 
                                                   & (vlSelf->out 
                                                      >> 4U));
    top__DOT__myseg__DOT__show__Vstatic__seg = ((0U 
                                                 == (IData)(__Vfunc_top__DOT__myseg__DOT__show__1__data))
                                                 ? 1U
                                                 : 
                                                ((1U 
                                                  == (IData)(__Vfunc_top__DOT__myseg__DOT__show__1__data))
                                                  ? 0x4fU
                                                  : 
                                                 ((2U 
                                                   == (IData)(__Vfunc_top__DOT__myseg__DOT__show__1__data))
                                                   ? 0x12U
                                                   : 
                                                  ((3U 
                                                    == (IData)(__Vfunc_top__DOT__myseg__DOT__show__1__data))
                                                    ? 6U
                                                    : 
                                                   ((4U 
                                                     == (IData)(__Vfunc_top__DOT__myseg__DOT__show__1__data))
                                                     ? 0x4cU
                                                     : 
                                                    ((5U 
                                                      == (IData)(__Vfunc_top__DOT__myseg__DOT__show__1__data))
                                                      ? 0x24U
                                                      : 
                                                     ((6U 
                                                       == (IData)(__Vfunc_top__DOT__myseg__DOT__show__1__data))
                                                       ? 0x20U
                                                       : 
                                                      ((7U 
                                                        == (IData)(__Vfunc_top__DOT__myseg__DOT__show__1__data))
                                                        ? 0xfU
                                                        : 
                                                       ((8U 
                                                         == (IData)(__Vfunc_top__DOT__myseg__DOT__show__1__data))
                                                         ? 0U
                                                         : 
                                                        ((9U 
                                                          == (IData)(__Vfunc_top__DOT__myseg__DOT__show__1__data))
                                                          ? 4U
                                                          : 
                                                         ((0xaU 
                                                           == (IData)(__Vfunc_top__DOT__myseg__DOT__show__1__data))
                                                           ? 8U
                                                           : 
                                                          ((0xbU 
                                                            == (IData)(__Vfunc_top__DOT__myseg__DOT__show__1__data))
                                                            ? 0x60U
                                                            : 
                                                           ((0xcU 
                                                             == (IData)(__Vfunc_top__DOT__myseg__DOT__show__1__data))
                                                             ? 0x31U
                                                             : 
                                                            ((0xdU 
                                                              == (IData)(__Vfunc_top__DOT__myseg__DOT__show__1__data))
                                                              ? 0x42U
                                                              : 
                                                             ((0xeU 
                                                               == (IData)(__Vfunc_top__DOT__myseg__DOT__show__1__data))
                                                               ? 0x30U
                                                               : 
                                                              ((0xfU 
                                                                == (IData)(__Vfunc_top__DOT__myseg__DOT__show__1__data))
                                                                ? 0x38U
                                                                : 0x7fU))))))))))))))));
    __Vfunc_top__DOT__myseg__DOT__show__1__Vfuncout 
        = top__DOT__myseg__DOT__show__Vstatic__seg;
    vlSelf->seg1 = __Vfunc_top__DOT__myseg__DOT__show__1__Vfuncout;
    __Vfunc_top__DOT__myseg__DOT__show__2__data = (0xfU 
                                                   & (vlSelf->out 
                                                      >> 8U));
    top__DOT__myseg__DOT__show__Vstatic__seg = ((0U 
                                                 == (IData)(__Vfunc_top__DOT__myseg__DOT__show__2__data))
                                                 ? 1U
                                                 : 
                                                ((1U 
                                                  == (IData)(__Vfunc_top__DOT__myseg__DOT__show__2__data))
                                                  ? 0x4fU
                                                  : 
                                                 ((2U 
                                                   == (IData)(__Vfunc_top__DOT__myseg__DOT__show__2__data))
                                                   ? 0x12U
                                                   : 
                                                  ((3U 
                                                    == (IData)(__Vfunc_top__DOT__myseg__DOT__show__2__data))
                                                    ? 6U
                                                    : 
                                                   ((4U 
                                                     == (IData)(__Vfunc_top__DOT__myseg__DOT__show__2__data))
                                                     ? 0x4cU
                                                     : 
                                                    ((5U 
                                                      == (IData)(__Vfunc_top__DOT__myseg__DOT__show__2__data))
                                                      ? 0x24U
                                                      : 
                                                     ((6U 
                                                       == (IData)(__Vfunc_top__DOT__myseg__DOT__show__2__data))
                                                       ? 0x20U
                                                       : 
                                                      ((7U 
                                                        == (IData)(__Vfunc_top__DOT__myseg__DOT__show__2__data))
                                                        ? 0xfU
                                                        : 
                                                       ((8U 
                                                         == (IData)(__Vfunc_top__DOT__myseg__DOT__show__2__data))
                                                         ? 0U
                                                         : 
                                                        ((9U 
                                                          == (IData)(__Vfunc_top__DOT__myseg__DOT__show__2__data))
                                                          ? 4U
                                                          : 
                                                         ((0xaU 
                                                           == (IData)(__Vfunc_top__DOT__myseg__DOT__show__2__data))
                                                           ? 8U
                                                           : 
                                                          ((0xbU 
                                                            == (IData)(__Vfunc_top__DOT__myseg__DOT__show__2__data))
                                                            ? 0x60U
                                                            : 
                                                           ((0xcU 
                                                             == (IData)(__Vfunc_top__DOT__myseg__DOT__show__2__data))
                                                             ? 0x31U
                                                             : 
                                                            ((0xdU 
                                                              == (IData)(__Vfunc_top__DOT__myseg__DOT__show__2__data))
                                                              ? 0x42U
                                                              : 
                                                             ((0xeU 
                                                               == (IData)(__Vfunc_top__DOT__myseg__DOT__show__2__data))
                                                               ? 0x30U
                                                               : 
                                                              ((0xfU 
                                                                == (IData)(__Vfunc_top__DOT__myseg__DOT__show__2__data))
                                                                ? 0x38U
                                                                : 0x7fU))))))))))))))));
    __Vfunc_top__DOT__myseg__DOT__show__2__Vfuncout 
        = top__DOT__myseg__DOT__show__Vstatic__seg;
    vlSelf->seg2 = __Vfunc_top__DOT__myseg__DOT__show__2__Vfuncout;
    __Vfunc_top__DOT__myseg__DOT__show__3__data = (0xfU 
                                                   & (vlSelf->out 
                                                      >> 0xcU));
    top__DOT__myseg__DOT__show__Vstatic__seg = ((0U 
                                                 == (IData)(__Vfunc_top__DOT__myseg__DOT__show__3__data))
                                                 ? 1U
                                                 : 
                                                ((1U 
                                                  == (IData)(__Vfunc_top__DOT__myseg__DOT__show__3__data))
                                                  ? 0x4fU
                                                  : 
                                                 ((2U 
                                                   == (IData)(__Vfunc_top__DOT__myseg__DOT__show__3__data))
                                                   ? 0x12U
                                                   : 
                                                  ((3U 
                                                    == (IData)(__Vfunc_top__DOT__myseg__DOT__show__3__data))
                                                    ? 6U
                                                    : 
                                                   ((4U 
                                                     == (IData)(__Vfunc_top__DOT__myseg__DOT__show__3__data))
                                                     ? 0x4cU
                                                     : 
                                                    ((5U 
                                                      == (IData)(__Vfunc_top__DOT__myseg__DOT__show__3__data))
                                                      ? 0x24U
                                                      : 
                                                     ((6U 
                                                       == (IData)(__Vfunc_top__DOT__myseg__DOT__show__3__data))
                                                       ? 0x20U
                                                       : 
                                                      ((7U 
                                                        == (IData)(__Vfunc_top__DOT__myseg__DOT__show__3__data))
                                                        ? 0xfU
                                                        : 
                                                       ((8U 
                                                         == (IData)(__Vfunc_top__DOT__myseg__DOT__show__3__data))
                                                         ? 0U
                                                         : 
                                                        ((9U 
                                                          == (IData)(__Vfunc_top__DOT__myseg__DOT__show__3__data))
                                                          ? 4U
                                                          : 
                                                         ((0xaU 
                                                           == (IData)(__Vfunc_top__DOT__myseg__DOT__show__3__data))
                                                           ? 8U
                                                           : 
                                                          ((0xbU 
                                                            == (IData)(__Vfunc_top__DOT__myseg__DOT__show__3__data))
                                                            ? 0x60U
                                                            : 
                                                           ((0xcU 
                                                             == (IData)(__Vfunc_top__DOT__myseg__DOT__show__3__data))
                                                             ? 0x31U
                                                             : 
                                                            ((0xdU 
                                                              == (IData)(__Vfunc_top__DOT__myseg__DOT__show__3__data))
                                                              ? 0x42U
                                                              : 
                                                             ((0xeU 
                                                               == (IData)(__Vfunc_top__DOT__myseg__DOT__show__3__data))
                                                               ? 0x30U
                                                               : 
                                                              ((0xfU 
                                                                == (IData)(__Vfunc_top__DOT__myseg__DOT__show__3__data))
                                                                ? 0x38U
                                                                : 0x7fU))))))))))))))));
    __Vfunc_top__DOT__myseg__DOT__show__3__Vfuncout 
        = top__DOT__myseg__DOT__show__Vstatic__seg;
    vlSelf->seg3 = __Vfunc_top__DOT__myseg__DOT__show__3__Vfuncout;
    __Vfunc_top__DOT__myseg__DOT__show__4__data = (0xfU 
                                                   & (vlSelf->out 
                                                      >> 0x10U));
    top__DOT__myseg__DOT__show__Vstatic__seg = ((0U 
                                                 == (IData)(__Vfunc_top__DOT__myseg__DOT__show__4__data))
                                                 ? 1U
                                                 : 
                                                ((1U 
                                                  == (IData)(__Vfunc_top__DOT__myseg__DOT__show__4__data))
                                                  ? 0x4fU
                                                  : 
                                                 ((2U 
                                                   == (IData)(__Vfunc_top__DOT__myseg__DOT__show__4__data))
                                                   ? 0x12U
                                                   : 
                                                  ((3U 
                                                    == (IData)(__Vfunc_top__DOT__myseg__DOT__show__4__data))
                                                    ? 6U
                                                    : 
                                                   ((4U 
                                                     == (IData)(__Vfunc_top__DOT__myseg__DOT__show__4__data))
                                                     ? 0x4cU
                                                     : 
                                                    ((5U 
                                                      == (IData)(__Vfunc_top__DOT__myseg__DOT__show__4__data))
                                                      ? 0x24U
                                                      : 
                                                     ((6U 
                                                       == (IData)(__Vfunc_top__DOT__myseg__DOT__show__4__data))
                                                       ? 0x20U
                                                       : 
                                                      ((7U 
                                                        == (IData)(__Vfunc_top__DOT__myseg__DOT__show__4__data))
                                                        ? 0xfU
                                                        : 
                                                       ((8U 
                                                         == (IData)(__Vfunc_top__DOT__myseg__DOT__show__4__data))
                                                         ? 0U
                                                         : 
                                                        ((9U 
                                                          == (IData)(__Vfunc_top__DOT__myseg__DOT__show__4__data))
                                                          ? 4U
                                                          : 
                                                         ((0xaU 
                                                           == (IData)(__Vfunc_top__DOT__myseg__DOT__show__4__data))
                                                           ? 8U
                                                           : 
                                                          ((0xbU 
                                                            == (IData)(__Vfunc_top__DOT__myseg__DOT__show__4__data))
                                                            ? 0x60U
                                                            : 
                                                           ((0xcU 
                                                             == (IData)(__Vfunc_top__DOT__myseg__DOT__show__4__data))
                                                             ? 0x31U
                                                             : 
                                                            ((0xdU 
                                                              == (IData)(__Vfunc_top__DOT__myseg__DOT__show__4__data))
                                                              ? 0x42U
                                                              : 
                                                             ((0xeU 
                                                               == (IData)(__Vfunc_top__DOT__myseg__DOT__show__4__data))
                                                               ? 0x30U
                                                               : 
                                                              ((0xfU 
                                                                == (IData)(__Vfunc_top__DOT__myseg__DOT__show__4__data))
                                                                ? 0x38U
                                                                : 0x7fU))))))))))))))));
    __Vfunc_top__DOT__myseg__DOT__show__4__Vfuncout 
        = top__DOT__myseg__DOT__show__Vstatic__seg;
    vlSelf->seg4 = __Vfunc_top__DOT__myseg__DOT__show__4__Vfuncout;
    __Vfunc_top__DOT__myseg__DOT__show__5__data = (0xfU 
                                                   & (vlSelf->out 
                                                      >> 0x14U));
    top__DOT__myseg__DOT__show__Vstatic__seg = ((0U 
                                                 == (IData)(__Vfunc_top__DOT__myseg__DOT__show__5__data))
                                                 ? 1U
                                                 : 
                                                ((1U 
                                                  == (IData)(__Vfunc_top__DOT__myseg__DOT__show__5__data))
                                                  ? 0x4fU
                                                  : 
                                                 ((2U 
                                                   == (IData)(__Vfunc_top__DOT__myseg__DOT__show__5__data))
                                                   ? 0x12U
                                                   : 
                                                  ((3U 
                                                    == (IData)(__Vfunc_top__DOT__myseg__DOT__show__5__data))
                                                    ? 6U
                                                    : 
                                                   ((4U 
                                                     == (IData)(__Vfunc_top__DOT__myseg__DOT__show__5__data))
                                                     ? 0x4cU
                                                     : 
                                                    ((5U 
                                                      == (IData)(__Vfunc_top__DOT__myseg__DOT__show__5__data))
                                                      ? 0x24U
                                                      : 
                                                     ((6U 
                                                       == (IData)(__Vfunc_top__DOT__myseg__DOT__show__5__data))
                                                       ? 0x20U
                                                       : 
                                                      ((7U 
                                                        == (IData)(__Vfunc_top__DOT__myseg__DOT__show__5__data))
                                                        ? 0xfU
                                                        : 
                                                       ((8U 
                                                         == (IData)(__Vfunc_top__DOT__myseg__DOT__show__5__data))
                                                         ? 0U
                                                         : 
                                                        ((9U 
                                                          == (IData)(__Vfunc_top__DOT__myseg__DOT__show__5__data))
                                                          ? 4U
                                                          : 
                                                         ((0xaU 
                                                           == (IData)(__Vfunc_top__DOT__myseg__DOT__show__5__data))
                                                           ? 8U
                                                           : 
                                                          ((0xbU 
                                                            == (IData)(__Vfunc_top__DOT__myseg__DOT__show__5__data))
                                                            ? 0x60U
                                                            : 
                                                           ((0xcU 
                                                             == (IData)(__Vfunc_top__DOT__myseg__DOT__show__5__data))
                                                             ? 0x31U
                                                             : 
                                                            ((0xdU 
                                                              == (IData)(__Vfunc_top__DOT__myseg__DOT__show__5__data))
                                                              ? 0x42U
                                                              : 
                                                             ((0xeU 
                                                               == (IData)(__Vfunc_top__DOT__myseg__DOT__show__5__data))
                                                               ? 0x30U
                                                               : 
                                                              ((0xfU 
                                                                == (IData)(__Vfunc_top__DOT__myseg__DOT__show__5__data))
                                                                ? 0x38U
                                                                : 0x7fU))))))))))))))));
    __Vfunc_top__DOT__myseg__DOT__show__5__Vfuncout 
        = top__DOT__myseg__DOT__show__Vstatic__seg;
    vlSelf->seg5 = __Vfunc_top__DOT__myseg__DOT__show__5__Vfuncout;
    __Vfunc_top__DOT__myseg__DOT__show__6__data = (0xfU 
                                                   & (vlSelf->out 
                                                      >> 0x18U));
    top__DOT__myseg__DOT__show__Vstatic__seg = ((0U 
                                                 == (IData)(__Vfunc_top__DOT__myseg__DOT__show__6__data))
                                                 ? 1U
                                                 : 
                                                ((1U 
                                                  == (IData)(__Vfunc_top__DOT__myseg__DOT__show__6__data))
                                                  ? 0x4fU
                                                  : 
                                                 ((2U 
                                                   == (IData)(__Vfunc_top__DOT__myseg__DOT__show__6__data))
                                                   ? 0x12U
                                                   : 
                                                  ((3U 
                                                    == (IData)(__Vfunc_top__DOT__myseg__DOT__show__6__data))
                                                    ? 6U
                                                    : 
                                                   ((4U 
                                                     == (IData)(__Vfunc_top__DOT__myseg__DOT__show__6__data))
                                                     ? 0x4cU
                                                     : 
                                                    ((5U 
                                                      == (IData)(__Vfunc_top__DOT__myseg__DOT__show__6__data))
                                                      ? 0x24U
                                                      : 
                                                     ((6U 
                                                       == (IData)(__Vfunc_top__DOT__myseg__DOT__show__6__data))
                                                       ? 0x20U
                                                       : 
                                                      ((7U 
                                                        == (IData)(__Vfunc_top__DOT__myseg__DOT__show__6__data))
                                                        ? 0xfU
                                                        : 
                                                       ((8U 
                                                         == (IData)(__Vfunc_top__DOT__myseg__DOT__show__6__data))
                                                         ? 0U
                                                         : 
                                                        ((9U 
                                                          == (IData)(__Vfunc_top__DOT__myseg__DOT__show__6__data))
                                                          ? 4U
                                                          : 
                                                         ((0xaU 
                                                           == (IData)(__Vfunc_top__DOT__myseg__DOT__show__6__data))
                                                           ? 8U
                                                           : 
                                                          ((0xbU 
                                                            == (IData)(__Vfunc_top__DOT__myseg__DOT__show__6__data))
                                                            ? 0x60U
                                                            : 
                                                           ((0xcU 
                                                             == (IData)(__Vfunc_top__DOT__myseg__DOT__show__6__data))
                                                             ? 0x31U
                                                             : 
                                                            ((0xdU 
                                                              == (IData)(__Vfunc_top__DOT__myseg__DOT__show__6__data))
                                                              ? 0x42U
                                                              : 
                                                             ((0xeU 
                                                               == (IData)(__Vfunc_top__DOT__myseg__DOT__show__6__data))
                                                               ? 0x30U
                                                               : 
                                                              ((0xfU 
                                                                == (IData)(__Vfunc_top__DOT__myseg__DOT__show__6__data))
                                                                ? 0x38U
                                                                : 0x7fU))))))))))))))));
    __Vfunc_top__DOT__myseg__DOT__show__6__Vfuncout 
        = top__DOT__myseg__DOT__show__Vstatic__seg;
    vlSelf->seg6 = __Vfunc_top__DOT__myseg__DOT__show__6__Vfuncout;
    __Vfunc_top__DOT__myseg__DOT__show__7__data = (vlSelf->out 
                                                   >> 0x1cU);
    top__DOT__myseg__DOT__show__Vstatic__seg = ((0U 
                                                 == (IData)(__Vfunc_top__DOT__myseg__DOT__show__7__data))
                                                 ? 1U
                                                 : 
                                                ((1U 
                                                  == (IData)(__Vfunc_top__DOT__myseg__DOT__show__7__data))
                                                  ? 0x4fU
                                                  : 
                                                 ((2U 
                                                   == (IData)(__Vfunc_top__DOT__myseg__DOT__show__7__data))
                                                   ? 0x12U
                                                   : 
                                                  ((3U 
                                                    == (IData)(__Vfunc_top__DOT__myseg__DOT__show__7__data))
                                                    ? 6U
                                                    : 
                                                   ((4U 
                                                     == (IData)(__Vfunc_top__DOT__myseg__DOT__show__7__data))
                                                     ? 0x4cU
                                                     : 
                                                    ((5U 
                                                      == (IData)(__Vfunc_top__DOT__myseg__DOT__show__7__data))
                                                      ? 0x24U
                                                      : 
                                                     ((6U 
                                                       == (IData)(__Vfunc_top__DOT__myseg__DOT__show__7__data))
                                                       ? 0x20U
                                                       : 
                                                      ((7U 
                                                        == (IData)(__Vfunc_top__DOT__myseg__DOT__show__7__data))
                                                        ? 0xfU
                                                        : 
                                                       ((8U 
                                                         == (IData)(__Vfunc_top__DOT__myseg__DOT__show__7__data))
                                                         ? 0U
                                                         : 
                                                        ((9U 
                                                          == (IData)(__Vfunc_top__DOT__myseg__DOT__show__7__data))
                                                          ? 4U
                                                          : 
                                                         ((0xaU 
                                                           == (IData)(__Vfunc_top__DOT__myseg__DOT__show__7__data))
                                                           ? 8U
                                                           : 
                                                          ((0xbU 
                                                            == (IData)(__Vfunc_top__DOT__myseg__DOT__show__7__data))
                                                            ? 0x60U
                                                            : 
                                                           ((0xcU 
                                                             == (IData)(__Vfunc_top__DOT__myseg__DOT__show__7__data))
                                                             ? 0x31U
                                                             : 
                                                            ((0xdU 
                                                              == (IData)(__Vfunc_top__DOT__myseg__DOT__show__7__data))
                                                              ? 0x42U
                                                              : 
                                                             ((0xeU 
                                                               == (IData)(__Vfunc_top__DOT__myseg__DOT__show__7__data))
                                                               ? 0x30U
                                                               : 
                                                              ((0xfU 
                                                                == (IData)(__Vfunc_top__DOT__myseg__DOT__show__7__data))
                                                                ? 0x38U
                                                                : 0x7fU))))))))))))))));
    __Vfunc_top__DOT__myseg__DOT__show__7__Vfuncout 
        = top__DOT__myseg__DOT__show__Vstatic__seg;
    vlSelf->seg7 = __Vfunc_top__DOT__myseg__DOT__show__7__Vfuncout;
}

void Vtop___024root___eval_ico(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_ico\n"); );
    // Body
    if (vlSelf->__VicoTriggered.at(0U)) {
        Vtop___024root___ico_sequent__TOP__0(vlSelf);
    }
}

void Vtop___024root___eval_act(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vtop___024root___nba_sequent__TOP__0(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___nba_sequent__TOP__0\n"); );
    // Body
    vlSelf->top__DOT__myreg__DOT__wrclk = (1U & (~ (IData)(vlSelf->top__DOT__myreg__DOT__wrclk)));
    vlSelf->top__DOT__mydatemem__DOT__wrclock = (1U 
                                                 & (~ (IData)(vlSelf->top__DOT__mydatemem__DOT__wrclock)));
    vlSelf->top__DOT__mydatemem__DOT__rdclock = (1U 
                                                 & (~ (IData)(vlSelf->top__DOT__mydatemem__DOT__rdclock)));
}

VL_INLINE_OPT void Vtop___024root___nba_sequent__TOP__1(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___nba_sequent__TOP__1\n"); );
    // Body
    vlSelf->__Vdlyvset__top__DOT__mydatemem__DOT__ram__v0 = 0U;
    if (vlSelf->wren) {
        vlSelf->__Vdlyvval__top__DOT__mydatemem__DOT__ram__v0 
            = ((((8U & (IData)(vlSelf->byteena_a)) ? 
                 (vlSelf->data >> 0x18U) : (vlSelf->top__DOT__mydatemem__DOT__tempout 
                                            >> 0x18U)) 
                << 0x18U) | ((0xff0000U & (((4U & (IData)(vlSelf->byteena_a))
                                             ? (vlSelf->data 
                                                >> 0x10U)
                                             : (vlSelf->top__DOT__mydatemem__DOT__tempout 
                                                >> 0x10U)) 
                                           << 0x10U)) 
                             | ((0xff00U & (((2U & (IData)(vlSelf->byteena_a))
                                              ? (vlSelf->data 
                                                 >> 8U)
                                              : (vlSelf->top__DOT__mydatemem__DOT__tempout 
                                                 >> 8U)) 
                                            << 8U)) 
                                | (0xffU & ((1U & (IData)(vlSelf->byteena_a))
                                             ? vlSelf->data
                                             : vlSelf->top__DOT__mydatemem__DOT__tempout)))));
        vlSelf->__Vdlyvset__top__DOT__mydatemem__DOT__ram__v0 = 1U;
        vlSelf->__Vdlyvdim0__top__DOT__mydatemem__DOT__ram__v0 
            = vlSelf->wraddress;
    }
}

VL_INLINE_OPT void Vtop___024root___nba_sequent__TOP__2(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___nba_sequent__TOP__2\n"); );
    // Init
    CData/*0:0*/ __Vdlyvset__top__DOT__myreg__DOT__regfile__v0;
    __Vdlyvset__top__DOT__myreg__DOT__regfile__v0 = 0;
    CData/*4:0*/ __Vdlyvdim0__top__DOT__myreg__DOT__regfile__v1;
    __Vdlyvdim0__top__DOT__myreg__DOT__regfile__v1 = 0;
    IData/*31:0*/ __Vdlyvval__top__DOT__myreg__DOT__regfile__v1;
    __Vdlyvval__top__DOT__myreg__DOT__regfile__v1 = 0;
    CData/*0:0*/ __Vdlyvset__top__DOT__myreg__DOT__regfile__v1;
    __Vdlyvset__top__DOT__myreg__DOT__regfile__v1 = 0;
    // Body
    __Vdlyvset__top__DOT__myreg__DOT__regfile__v0 = 0U;
    __Vdlyvset__top__DOT__myreg__DOT__regfile__v1 = 0U;
    if (vlSelf->rst) {
        __Vdlyvset__top__DOT__myreg__DOT__regfile__v0 = 1U;
    } else {
        __Vdlyvval__top__DOT__myreg__DOT__regfile__v1 
            = ((IData)(vlSelf->regwr) ? ((0U != (IData)(vlSelf->rw))
                                          ? vlSelf->busw
                                          : 0U) : vlSelf->top__DOT__myreg__DOT__regfile
               [vlSelf->rw]);
        __Vdlyvset__top__DOT__myreg__DOT__regfile__v1 = 1U;
        __Vdlyvdim0__top__DOT__myreg__DOT__regfile__v1 
            = vlSelf->rw;
    }
    if (__Vdlyvset__top__DOT__myreg__DOT__regfile__v0) {
        vlSelf->top__DOT__myreg__DOT__regfile[0U] = 0U;
    }
    if (__Vdlyvset__top__DOT__myreg__DOT__regfile__v1) {
        vlSelf->top__DOT__myreg__DOT__regfile[__Vdlyvdim0__top__DOT__myreg__DOT__regfile__v1] 
            = __Vdlyvval__top__DOT__myreg__DOT__regfile__v1;
    }
    vlSelf->busa = vlSelf->top__DOT__myreg__DOT__regfile
        [vlSelf->ra];
    vlSelf->busb = vlSelf->top__DOT__myreg__DOT__regfile
        [vlSelf->rb];
}

VL_INLINE_OPT void Vtop___024root___nba_sequent__TOP__3(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___nba_sequent__TOP__3\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->wren)))) {
        vlSelf->q = vlSelf->top__DOT__mydatemem__DOT__ram
            [vlSelf->rdaddress];
    }
    if (vlSelf->wren) {
        vlSelf->top__DOT__mydatemem__DOT__tempout = 
            vlSelf->top__DOT__mydatemem__DOT__ram[vlSelf->wraddress];
    }
}

VL_INLINE_OPT void Vtop___024root___nba_sequent__TOP__4(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___nba_sequent__TOP__4\n"); );
    // Body
    if (vlSelf->__Vdlyvset__top__DOT__mydatemem__DOT__ram__v0) {
        vlSelf->top__DOT__mydatemem__DOT__ram[vlSelf->__Vdlyvdim0__top__DOT__mydatemem__DOT__ram__v0] 
            = vlSelf->__Vdlyvval__top__DOT__mydatemem__DOT__ram__v0;
    }
}

void Vtop___024root___eval_nba(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_nba\n"); );
    // Body
    if (vlSelf->__VnbaTriggered.at(0U)) {
        Vtop___024root___nba_sequent__TOP__0(vlSelf);
    }
    if (vlSelf->__VnbaTriggered.at(2U)) {
        Vtop___024root___nba_sequent__TOP__1(vlSelf);
    }
    if (vlSelf->__VnbaTriggered.at(3U)) {
        Vtop___024root___nba_sequent__TOP__2(vlSelf);
    }
    if (vlSelf->__VnbaTriggered.at(1U)) {
        Vtop___024root___nba_sequent__TOP__3(vlSelf);
    }
    if (vlSelf->__VnbaTriggered.at(2U)) {
        Vtop___024root___nba_sequent__TOP__4(vlSelf);
    }
}

void Vtop___024root___eval_triggers__ico(Vtop___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__ico(Vtop___024root* vlSelf);
#endif  // VL_DEBUG
void Vtop___024root___eval_triggers__act(Vtop___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__act(Vtop___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__nba(Vtop___024root* vlSelf);
#endif  // VL_DEBUG

void Vtop___024root___eval(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval\n"); );
    // Init
    CData/*0:0*/ __VicoContinue;
    VlTriggerVec<4> __VpreTriggered;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    vlSelf->__VicoIterCount = 0U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        __VicoContinue = 0U;
        Vtop___024root___eval_triggers__ico(vlSelf);
        if (vlSelf->__VicoTriggered.any()) {
            __VicoContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VicoIterCount))) {
#ifdef VL_DEBUG
                Vtop___024root___dump_triggers__ico(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/cpu/vsrc/top.v", 1, "", "Input combinational region did not converge.");
            }
            vlSelf->__VicoIterCount = ((IData)(1U) 
                                       + vlSelf->__VicoIterCount);
            Vtop___024root___eval_ico(vlSelf);
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
            Vtop___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vtop___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/cpu/vsrc/top.v", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.set(vlSelf->__VactTriggered);
                Vtop___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vtop___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/cpu/vsrc/top.v", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vtop___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vtop___024root___eval_debug_assertions(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->rst & 0xfeU))) {
        Verilated::overWidthError("rst");}
    if (VL_UNLIKELY((vlSelf->aluc & 0xf0U))) {
        Verilated::overWidthError("aluc");}
    if (VL_UNLIKELY((vlSelf->byteena_a & 0xf0U))) {
        Verilated::overWidthError("byteena_a");}
    if (VL_UNLIKELY((vlSelf->rdaddress & 0x8000U))) {
        Verilated::overWidthError("rdaddress");}
    if (VL_UNLIKELY((vlSelf->wraddress & 0x8000U))) {
        Verilated::overWidthError("wraddress");}
    if (VL_UNLIKELY((vlSelf->wren & 0xfeU))) {
        Verilated::overWidthError("wren");}
    if (VL_UNLIKELY((vlSelf->ra & 0xe0U))) {
        Verilated::overWidthError("ra");}
    if (VL_UNLIKELY((vlSelf->rb & 0xe0U))) {
        Verilated::overWidthError("rb");}
    if (VL_UNLIKELY((vlSelf->rw & 0xe0U))) {
        Verilated::overWidthError("rw");}
    if (VL_UNLIKELY((vlSelf->regwr & 0xfeU))) {
        Verilated::overWidthError("regwr");}
}
#endif  // VL_DEBUG
