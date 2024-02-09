// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vshift.h for the primary calling header

#ifndef VERILATED_VSHIFT___024ROOT_H_
#define VERILATED_VSHIFT___024ROOT_H_  // guard

#include "verilated.h"

class Vshift__Syms;

class Vshift___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(en,0,0);
    VL_IN8(in,7,0);
    VL_OUT8(coda,7,0);
    VL_OUT8(seg1,6,0);
    VL_OUT8(seg0,6,0);
    CData/*0:0*/ shift__DOT__x8;
    CData/*0:0*/ __Vtrigrprev__TOP__en;
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ __VstlIterCount;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vshift__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vshift___024root(Vshift__Syms* symsp, const char* v__name);
    ~Vshift___024root();
    VL_UNCOPYABLE(Vshift___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
