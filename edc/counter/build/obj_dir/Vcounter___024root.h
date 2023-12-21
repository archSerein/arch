// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vcounter.h for the primary calling header

#ifndef VERILATED_VCOUNTER___024ROOT_H_
#define VERILATED_VCOUNTER___024ROOT_H_  // guard

#include "verilated.h"

class Vcounter__Syms;

class Vcounter___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    CData/*0:0*/ counter__DOT__clk_ls;
    VL_IN8(rst,0,0);
    VL_IN8(sw,1,0);
    VL_OUT8(seg0,6,0);
    VL_OUT8(seg1,6,0);
    VL_OUT8(led,0,0);
    CData/*6:0*/ counter__DOT__count;
    CData/*3:0*/ counter__DOT__x;
    CData/*3:0*/ counter__DOT__y;
    CData/*6:0*/ counter__DOT__temp;
    CData/*0:0*/ counter__DOT__ledl;
    CData/*0:0*/ __Vtrigrprev__TOP__clk;
    CData/*0:0*/ __Vtrigrprev__TOP__counter__DOT__clk_ls;
    CData/*0:0*/ __VactContinue;
    IData/*24:0*/ counter__DOT__count_clk;
    IData/*31:0*/ __VstlIterCount;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<2> __VactTriggered;
    VlTriggerVec<2> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vcounter__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vcounter___024root(Vcounter__Syms* symsp, const char* v__name);
    ~Vcounter___024root();
    VL_UNCOPYABLE(Vcounter___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
