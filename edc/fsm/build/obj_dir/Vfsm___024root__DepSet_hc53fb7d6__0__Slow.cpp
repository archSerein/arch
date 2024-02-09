// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vfsm.h for the primary calling header

#include "verilated.h"

#include "Vfsm___024root.h"

VL_ATTR_COLD void Vfsm___024root___eval_static(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vfsm___024root___eval_initial__TOP(Vfsm___024root* vlSelf);

VL_ATTR_COLD void Vfsm___024root___eval_initial(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___eval_initial\n"); );
    // Body
    Vfsm___024root___eval_initial__TOP(vlSelf);
    vlSelf->__Vtrigrprev__TOP__clk = vlSelf->clk;
    vlSelf->__Vtrigrprev__TOP__fsm__DOT__clk_c = vlSelf->fsm__DOT__clk_c;
    vlSelf->__Vtrigrprev__TOP__rst = vlSelf->rst;
}

VL_ATTR_COLD void Vfsm___024root___eval_initial__TOP(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___eval_initial__TOP\n"); );
    // Body
    vlSelf->fsm__DOT__initial_state = 0U;
    vlSelf->fsm__DOT__count_clk_c = 0U;
}

VL_ATTR_COLD void Vfsm___024root___eval_final(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vfsm___024root___eval_triggers__stl(Vfsm___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vfsm___024root___dump_triggers__stl(Vfsm___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD void Vfsm___024root___eval_stl(Vfsm___024root* vlSelf);

VL_ATTR_COLD void Vfsm___024root___eval_settle(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___eval_settle\n"); );
    // Init
    CData/*0:0*/ __VstlContinue;
    // Body
    vlSelf->__VstlIterCount = 0U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        __VstlContinue = 0U;
        Vfsm___024root___eval_triggers__stl(vlSelf);
        if (vlSelf->__VstlTriggered.any()) {
            __VstlContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VstlIterCount))) {
#ifdef VL_DEBUG
                Vfsm___024root___dump_triggers__stl(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/fsm/vsrc/fsm.v", 1, "", "Settle region did not converge.");
            }
            vlSelf->__VstlIterCount = ((IData)(1U) 
                                       + vlSelf->__VstlIterCount);
            Vfsm___024root___eval_stl(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vfsm___024root___dump_triggers__stl(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VstlTriggered.at(0U)) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vfsm___024root___stl_sequent__TOP__0(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___stl_sequent__TOP__0\n"); );
    // Init
    CData/*0:0*/ fsm__DOT____VdfgTmp_h54965c5e__0;
    fsm__DOT____VdfgTmp_h54965c5e__0 = 0;
    // Body
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

VL_ATTR_COLD void Vfsm___024root___eval_stl(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___eval_stl\n"); );
    // Body
    if (vlSelf->__VstlTriggered.at(0U)) {
        Vfsm___024root___stl_sequent__TOP__0(vlSelf);
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vfsm___024root___dump_triggers__ico(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___dump_triggers__ico\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VicoTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VicoTriggered.at(0U)) {
        VL_DBG_MSGF("         'ico' region trigger index 0 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vfsm___024root___dump_triggers__act(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VactTriggered.at(0U)) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk)\n");
    }
    if (vlSelf->__VactTriggered.at(1U)) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @(posedge fsm.clk_c or posedge rst)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vfsm___024root___dump_triggers__nba(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VnbaTriggered.at(0U)) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk)\n");
    }
    if (vlSelf->__VnbaTriggered.at(1U)) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @(posedge fsm.clk_c or posedge rst)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vfsm___024root___ctor_var_reset(Vfsm___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfsm__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfsm___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = 0;
    vlSelf->rst = 0;
    vlSelf->in = 0;
    vlSelf->u = 0;
    vlSelf->v = 0;
    vlSelf->led = 0;
    vlSelf->fsm__DOT__count_clk_c = 0;
    vlSelf->fsm__DOT__clk_c = 0;
    vlSelf->fsm__DOT__initial_state = 0;
    vlSelf->fsm__DOT__current_state = 0;
    vlSelf->fsm__DOT__next_state = 0;
    vlSelf->fsm__DOT____VdfgTmp_he2182c5a__0 = 0;
    vlSelf->fsm__DOT____VdfgTmp_h63b840a2__0 = 0;
    vlSelf->fsm__DOT____VdfgTmp_hc3fb4bc3__0 = 0;
    vlSelf->fsm__DOT____VdfgTmp_h4f8d6120__0 = 0;
    vlSelf->fsm__DOT____VdfgTmp_hce4b7368__0 = 0;
    vlSelf->__Vtrigrprev__TOP__clk = 0;
    vlSelf->__Vtrigrprev__TOP__fsm__DOT__clk_c = 0;
    vlSelf->__Vtrigrprev__TOP__rst = 0;
}
