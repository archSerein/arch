// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vregister8.h for the primary calling header

#include "verilated.h"

#include "Vregister8___024root.h"

VL_INLINE_OPT void Vregister8___024root___ico_sequent__TOP__0(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___ico_sequent__TOP__0\n"); );
    // Body
    vlSelf->out = ((IData)(vlSelf->wr) ? 0U : vlSelf->register8__DOT__ram
                   [vlSelf->addr]);
    vlSelf->led = vlSelf->out;
}

void Vregister8___024root___eval_ico(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___eval_ico\n"); );
    // Body
    if (vlSelf->__VicoTriggered.at(0U)) {
        Vregister8___024root___ico_sequent__TOP__0(vlSelf);
    }
}

void Vregister8___024root___eval_act(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vregister8___024root___nba_sequent__TOP__0(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___nba_sequent__TOP__0\n"); );
    // Init
    CData/*3:0*/ __Vdlyvdim0__register8__DOT__ram__v0;
    __Vdlyvdim0__register8__DOT__ram__v0 = 0;
    CData/*7:0*/ __Vdlyvval__register8__DOT__ram__v0;
    __Vdlyvval__register8__DOT__ram__v0 = 0;
    CData/*0:0*/ __Vdlyvset__register8__DOT__ram__v0;
    __Vdlyvset__register8__DOT__ram__v0 = 0;
    // Body
    __Vdlyvset__register8__DOT__ram__v0 = 0U;
    if (vlSelf->wr) {
        __Vdlyvval__register8__DOT__ram__v0 = vlSelf->data;
        __Vdlyvset__register8__DOT__ram__v0 = 1U;
        __Vdlyvdim0__register8__DOT__ram__v0 = vlSelf->addr;
    }
    if (__Vdlyvset__register8__DOT__ram__v0) {
        vlSelf->register8__DOT__ram[__Vdlyvdim0__register8__DOT__ram__v0] 
            = __Vdlyvval__register8__DOT__ram__v0;
    }
    vlSelf->out = ((IData)(vlSelf->wr) ? 0U : vlSelf->register8__DOT__ram
                   [vlSelf->addr]);
    vlSelf->led = vlSelf->out;
}

void Vregister8___024root___eval_nba(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___eval_nba\n"); );
    // Body
    if (vlSelf->__VnbaTriggered.at(0U)) {
        Vregister8___024root___nba_sequent__TOP__0(vlSelf);
    }
}

void Vregister8___024root___eval_triggers__ico(Vregister8___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vregister8___024root___dump_triggers__ico(Vregister8___024root* vlSelf);
#endif  // VL_DEBUG
void Vregister8___024root___eval_triggers__act(Vregister8___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vregister8___024root___dump_triggers__act(Vregister8___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vregister8___024root___dump_triggers__nba(Vregister8___024root* vlSelf);
#endif  // VL_DEBUG

void Vregister8___024root___eval(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___eval\n"); );
    // Init
    CData/*0:0*/ __VicoContinue;
    VlTriggerVec<1> __VpreTriggered;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    vlSelf->__VicoIterCount = 0U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        __VicoContinue = 0U;
        Vregister8___024root___eval_triggers__ico(vlSelf);
        if (vlSelf->__VicoTriggered.any()) {
            __VicoContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VicoIterCount))) {
#ifdef VL_DEBUG
                Vregister8___024root___dump_triggers__ico(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/register/vsrc/register8.v", 1, "", "Input combinational region did not converge.");
            }
            vlSelf->__VicoIterCount = ((IData)(1U) 
                                       + vlSelf->__VicoIterCount);
            Vregister8___024root___eval_ico(vlSelf);
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
            Vregister8___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vregister8___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/register/vsrc/register8.v", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.set(vlSelf->__VactTriggered);
                Vregister8___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vregister8___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/register/vsrc/register8.v", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vregister8___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vregister8___024root___eval_debug_assertions(Vregister8___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vregister8__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vregister8___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->wr & 0xfeU))) {
        Verilated::overWidthError("wr");}
    if (VL_UNLIKELY((vlSelf->addr & 0xf0U))) {
        Verilated::overWidthError("addr");}
}
#endif  // VL_DEBUG
