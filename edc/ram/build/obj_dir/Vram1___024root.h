// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vram1.h for the primary calling header

#ifndef VERILATED_VRAM1___024ROOT_H_
#define VERILATED_VRAM1___024ROOT_H_  // guard

#include "verilated.h"

class Vram1__Syms;

class Vram1___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_OUT8(seg0,6,0);
    VL_OUT8(seg1,6,0);
    VL_IN8(en,0,0);
    VL_IN8(inputaddr,3,0);
    VL_IN8(outputaddr,3,0);
    VL_IN8(in,7,0);
    VL_OUT8(out,7,0);
    CData/*0:0*/ __Vtrigrprev__TOP__clk;
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ __VstlIterCount;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<CData/*7:0*/, 16> ram1__DOT__ram1;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vram1__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vram1___024root(Vram1__Syms* symsp, const char* v__name);
    ~Vram1___024root();
    VL_UNCOPYABLE(Vram1___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
