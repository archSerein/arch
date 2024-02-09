// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vfsm.h for the primary calling header

#ifndef VERILATED_VFSM___024ROOT_H_
#define VERILATED_VFSM___024ROOT_H_  // guard

#include "verilated.h"

class Vfsm__Syms;

class Vfsm___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(rst,0,0);
    CData/*0:0*/ fsm__DOT__clk_c;
    VL_IN8(in,0,0);
    VL_OUT8(u,0,0);
    VL_OUT8(v,0,0);
    VL_OUT8(led,4,0);
    CData/*2:0*/ fsm__DOT__initial_state;
    CData/*2:0*/ fsm__DOT__current_state;
    CData/*2:0*/ fsm__DOT__next_state;
    CData/*0:0*/ fsm__DOT____VdfgTmp_he2182c5a__0;
    CData/*0:0*/ fsm__DOT____VdfgTmp_h63b840a2__0;
    CData/*0:0*/ fsm__DOT____VdfgTmp_hc3fb4bc3__0;
    CData/*0:0*/ fsm__DOT____VdfgTmp_h4f8d6120__0;
    CData/*0:0*/ fsm__DOT____VdfgTmp_hce4b7368__0;
    CData/*0:0*/ __Vtrigrprev__TOP__clk;
    CData/*0:0*/ __Vtrigrprev__TOP__fsm__DOT__clk_c;
    CData/*0:0*/ __Vtrigrprev__TOP__rst;
    CData/*0:0*/ __VactContinue;
    IData/*24:0*/ fsm__DOT__count_clk_c;
    IData/*31:0*/ __VstlIterCount;
    IData/*31:0*/ __VicoIterCount;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<2> __VactTriggered;
    VlTriggerVec<2> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vfsm__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vfsm___024root(Vfsm__Syms* symsp, const char* v__name);
    ~Vfsm___024root();
    VL_UNCOPYABLE(Vfsm___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
