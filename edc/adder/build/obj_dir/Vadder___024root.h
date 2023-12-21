// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vadder.h for the primary calling header

#ifndef VERILATED_VADDER___024ROOT_H_
#define VERILATED_VADDER___024ROOT_H_  // guard

#include "verilated.h"

class Vadder__Syms;

class Vadder___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(x,3,0);
    VL_IN8(y,3,0);
    VL_IN8(clk,0,0);
    VL_IN8(rst,0,0);
    VL_IN8(select,2,0);
    VL_OUT8(out,3,0);
    VL_OUT8(seg0,6,0);
    VL_OUT8(seg1,6,0);
    VL_OUT8(led,2,0);
    CData/*3:0*/ adder__DOT__to_add;
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ __VstlIterCount;
    IData/*31:0*/ __VicoIterCount;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<0> __VactTriggered;
    VlTriggerVec<0> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vadder__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vadder___024root(Vadder__Syms* symsp, const char* v__name);
    ~Vadder___024root();
    VL_UNCOPYABLE(Vadder___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
