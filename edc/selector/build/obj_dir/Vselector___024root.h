// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vselector.h for the primary calling header

#ifndef VERILATED_VSELECTOR___024ROOT_H_
#define VERILATED_VSELECTOR___024ROOT_H_  // guard

#include "verilated.h"

class Vselector__Syms;

class Vselector___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(rst,0,0);
    VL_OUT8(led,1,0);
    CData/*0:0*/ __Vtrigrprev__TOP__clk;
    CData/*0:0*/ __VactContinue;
    VL_IN16(sw,9,0);
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vselector__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vselector___024root(Vselector__Syms* symsp, const char* v__name);
    ~Vselector___024root();
    VL_UNCOPYABLE(Vselector___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
