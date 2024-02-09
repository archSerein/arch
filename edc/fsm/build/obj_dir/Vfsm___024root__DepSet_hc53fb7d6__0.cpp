// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vfsm.h for the primary calling header

#include "verilated.h"

#include "Vfsm___024root.h"

VL_INLINE_OPT void Vfsm___024root___ico_sequent__TOP__0(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___ico_sequent__TOP__0\n"); );
    // Init
    CData/*0:0*/ fsm__DOT____VdfgTmp_h54965c5e__0;
    fsm__DOT____VdfgTmp_h54965c5e__0 = 0;
    // Body
    vlSelf->u = ((IData)(vlSelf->fsm__DOT____VdfgTmp_he2182c5a__0) 
                 | ((IData)((6U != (6U & (IData)(vlSelf->fsm__DOT__current_state)))) 
                    & ((IData)(vlSelf->fsm__DOT__current_state) 
                       & (IData)(vlSelf->in))));
    fsm__DOT____VdfgTmp_h54965c5e__0 = (1U & ((IData)(vlSelf->fsm__DOT__current_state) 
                                              ^ (IData)(vlSelf->in)));
    vlSelf->v = (((IData)(vlSelf->fsm__DOT____VdfgTmp_h63b840a2__0) 
                  & (IData)(fsm__DOT____VdfgTmp_h54965c5e__0)) 
                 | ((~ (IData)(fsm__DOT____VdfgTmp_h54965c5e__0)) 
                    & (IData)(vlSelf->fsm__DOT____VdfgTmp_hc3fb4bc3__0)));
    vlSelf->fsm__DOT__next_state = (((((IData)(vlSelf->fsm__DOT____VdfgTmp_h4f8d6120__0) 
                                       & (IData)(vlSelf->in)) 
                                      | (((IData)(vlSelf->fsm__DOT____VdfgTmp_hce4b7368__0) 
                                          & (IData)(vlSelf->fsm__DOT__current_state)) 
                                         | ((~ (IData)(fsm__DOT____VdfgTmp_h54965c5e__0)) 
                                            & (IData)(vlSelf->fsm__DOT____VdfgTmp_h63b840a2__0)))) 
                                     << 2U) | (((((IData)(vlSelf->fsm__DOT____VdfgTmp_hc3fb4bc3__0) 
                                                  & (IData)(vlSelf->fsm__DOT__current_state)) 
                                                 | (((~ (IData)(vlSelf->in)) 
                                                     & (IData)(vlSelf->fsm__DOT____VdfgTmp_h4f8d6120__0)) 
                                                    | ((IData)(vlSelf->fsm__DOT____VdfgTmp_he2182c5a__0) 
                                                       & (IData)(vlSelf->in)))) 
                                                << 1U) 
                                               | (1U 
                                                  & (((~ (IData)(fsm__DOT____VdfgTmp_h54965c5e__0)) 
                                                      & (((IData)(vlSelf->fsm__DOT__current_state) 
                                                          >> 2U) 
                                                         ^ 
                                                         ((IData)(vlSelf->fsm__DOT__current_state) 
                                                          >> 1U))) 
                                                     | ((IData)(vlSelf->fsm__DOT____VdfgTmp_hc3fb4bc3__0) 
                                                        & (IData)(fsm__DOT____VdfgTmp_h54965c5e__0))))));
}

void Vfsm___024root___eval_ico(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___eval_ico\n"); );
    // Body
    if (vlSelf->__VicoTriggered.at(0U)) {
        Vfsm___024root___ico_sequent__TOP__0(vlSelf);
    }
}

void Vfsm___024root___eval_act(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vfsm___024root___nba_sequent__TOP__0(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___nba_sequent__TOP__0\n"); );
    // Init
    IData/*24:0*/ __Vdly__fsm__DOT__count_clk_c;
    __Vdly__fsm__DOT__count_clk_c = 0;
    // Body
    __Vdly__fsm__DOT__count_clk_c = vlSelf->fsm__DOT__count_clk_c;
    if ((1U == vlSelf->fsm__DOT__count_clk_c)) {
        vlSelf->fsm__DOT__clk_c = (1U & (~ (IData)(vlSelf->fsm__DOT__clk_c)));
        __Vdly__fsm__DOT__count_clk_c = 0U;
    } else {
        __Vdly__fsm__DOT__count_clk_c = (0x1ffffffU 
                                         & ((IData)(1U) 
                                            + vlSelf->fsm__DOT__count_clk_c));
    }
    vlSelf->fsm__DOT__count_clk_c = __Vdly__fsm__DOT__count_clk_c;
}

VL_INLINE_OPT void Vfsm___024root___nba_sequent__TOP__1(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___nba_sequent__TOP__1\n"); );
    // Init
    CData/*0:0*/ fsm__DOT____VdfgTmp_h54965c5e__0;
    fsm__DOT____VdfgTmp_h54965c5e__0 = 0;
    CData/*2:0*/ __Vdly__fsm__DOT__current_state;
    __Vdly__fsm__DOT__current_state = 0;
    // Body
    __Vdly__fsm__DOT__current_state = vlSelf->fsm__DOT__current_state;
    if (vlSelf->rst) {
        VL_WRITEF("u-v-state: %b-%b %b\n",1,vlSelf->u,
                  1,(IData)(vlSelf->v),3,vlSelf->fsm__DOT__next_state);
        vlSelf->led = (8U | (IData)(vlSelf->fsm__DOT__current_state));
        __Vdly__fsm__DOT__current_state = vlSelf->fsm__DOT__initial_state;
    } else {
        VL_WRITEF("u-v-state: %b-%b %b\n",1,vlSelf->u,
                  1,(IData)(vlSelf->v),3,vlSelf->fsm__DOT__next_state);
        vlSelf->led = (((IData)(vlSelf->u) << 4U) | 
                       (((IData)(vlSelf->v) << 3U) 
                        | (IData)(vlSelf->fsm__DOT__current_state)));
        __Vdly__fsm__DOT__current_state = vlSelf->fsm__DOT__next_state;
    }
    vlSelf->fsm__DOT__current_state = __Vdly__fsm__DOT__current_state;
    vlSelf->fsm__DOT____VdfgTmp_hc3fb4bc3__0 = (IData)(
                                                       (0U 
                                                        == 
                                                        (6U 
                                                         & (IData)(vlSelf->fsm__DOT__current_state))));
    fsm__DOT____VdfgTmp_h54965c5e__0 = (1U & ((IData)(vlSelf->fsm__DOT__current_state) 
                                              ^ (IData)(vlSelf->in)));
    vlSelf->fsm__DOT____VdfgTmp_hce4b7368__0 = (IData)(
                                                       (2U 
                                                        == 
                                                        (6U 
                                                         & (IData)(vlSelf->fsm__DOT__current_state))));
    vlSelf->fsm__DOT____VdfgTmp_h63b840a2__0 = (IData)(
                                                       (4U 
                                                        == 
                                                        (6U 
                                                         & (IData)(vlSelf->fsm__DOT__current_state))));
    vlSelf->fsm__DOT____VdfgTmp_h4f8d6120__0 = ((~ (IData)(vlSelf->fsm__DOT__current_state)) 
                                                & (IData)(vlSelf->fsm__DOT____VdfgTmp_hce4b7368__0));
    vlSelf->v = (((IData)(vlSelf->fsm__DOT____VdfgTmp_h63b840a2__0) 
                  & (IData)(fsm__DOT____VdfgTmp_h54965c5e__0)) 
                 | ((~ (IData)(fsm__DOT____VdfgTmp_h54965c5e__0)) 
                    & (IData)(vlSelf->fsm__DOT____VdfgTmp_hc3fb4bc3__0)));
    vlSelf->fsm__DOT____VdfgTmp_he2182c5a__0 = ((~ (IData)(vlSelf->fsm__DOT__current_state)) 
                                                & (IData)(vlSelf->fsm__DOT____VdfgTmp_h63b840a2__0));
    vlSelf->u = ((IData)(vlSelf->fsm__DOT____VdfgTmp_he2182c5a__0) 
                 | ((IData)((6U != (6U & (IData)(vlSelf->fsm__DOT__current_state)))) 
                    & ((IData)(vlSelf->fsm__DOT__current_state) 
                       & (IData)(vlSelf->in))));
    vlSelf->fsm__DOT__next_state = (((((IData)(vlSelf->fsm__DOT____VdfgTmp_h4f8d6120__0) 
                                       & (IData)(vlSelf->in)) 
                                      | (((IData)(vlSelf->fsm__DOT____VdfgTmp_hce4b7368__0) 
                                          & (IData)(vlSelf->fsm__DOT__current_state)) 
                                         | ((~ (IData)(fsm__DOT____VdfgTmp_h54965c5e__0)) 
                                            & (IData)(vlSelf->fsm__DOT____VdfgTmp_h63b840a2__0)))) 
                                     << 2U) | (((((IData)(vlSelf->fsm__DOT____VdfgTmp_hc3fb4bc3__0) 
                                                  & (IData)(vlSelf->fsm__DOT__current_state)) 
                                                 | (((~ (IData)(vlSelf->in)) 
                                                     & (IData)(vlSelf->fsm__DOT____VdfgTmp_h4f8d6120__0)) 
                                                    | ((IData)(vlSelf->fsm__DOT____VdfgTmp_he2182c5a__0) 
                                                       & (IData)(vlSelf->in)))) 
                                                << 1U) 
                                               | (1U 
                                                  & (((~ (IData)(fsm__DOT____VdfgTmp_h54965c5e__0)) 
                                                      & (((IData)(vlSelf->fsm__DOT__current_state) 
                                                          >> 2U) 
                                                         ^ 
                                                         ((IData)(vlSelf->fsm__DOT__current_state) 
                                                          >> 1U))) 
                                                     | ((IData)(vlSelf->fsm__DOT____VdfgTmp_hc3fb4bc3__0) 
                                                        & (IData)(fsm__DOT____VdfgTmp_h54965c5e__0))))));
}

void Vfsm___024root___eval_nba(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___eval_nba\n"); );
    // Body
    if (vlSelf->__VnbaTriggered.at(0U)) {
        Vfsm___024root___nba_sequent__TOP__0(vlSelf);
    }
    if (vlSelf->__VnbaTriggered.at(1U)) {
        Vfsm___024root___nba_sequent__TOP__1(vlSelf);
    }
}

void Vfsm___024root___eval_triggers__ico(Vfsm___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vfsm___024root___dump_triggers__ico(Vfsm___024root* vlSelf);
#endif  // VL_DEBUG
void Vfsm___024root___eval_triggers__act(Vfsm___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vfsm___024root___dump_triggers__act(Vfsm___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vfsm___024root___dump_triggers__nba(Vfsm___024root* vlSelf);
#endif  // VL_DEBUG

void Vfsm___024root___eval(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___eval\n"); );
    // Init
    CData/*0:0*/ __VicoContinue;
    VlTriggerVec<2> __VpreTriggered;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    vlSelf->__VicoIterCount = 0U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        __VicoContinue = 0U;
        Vfsm___024root___eval_triggers__ico(vlSelf);
        if (vlSelf->__VicoTriggered.any()) {
            __VicoContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VicoIterCount))) {
#ifdef VL_DEBUG
                Vfsm___024root___dump_triggers__ico(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/fsm/vsrc/fsm.v", 1, "", "Input combinational region did not converge.");
            }
            vlSelf->__VicoIterCount = ((IData)(1U) 
                                       + vlSelf->__VicoIterCount);
            Vfsm___024root___eval_ico(vlSelf);
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
            Vfsm___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vfsm___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/fsm/vsrc/fsm.v", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.set(vlSelf->__VactTriggered);
                Vfsm___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vfsm___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/fsm/vsrc/fsm.v", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vfsm___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vfsm___024root___eval_debug_assertions(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->rst & 0xfeU))) {
        Verilated::overWidthError("rst");}
    if (VL_UNLIKELY((vlSelf->in & 0xfeU))) {
        Verilated::overWidthError("in");}
}
#endif  // VL_DEBUG
