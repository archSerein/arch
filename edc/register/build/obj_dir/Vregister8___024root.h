// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vregister8.h for the primary calling header

#ifndef VERILATED_VREGISTER8___024ROOT_H_
#define VERILATED_VREGISTER8___024ROOT_H_  // guard

#include "verilated.h"

class Vregister8__Syms;

class Vregister8___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(wr,0,0);
    VL_IN8(data,7,0);
    VL_IN8(addr,3,0);
    VL_OUT8(out,7,0);
    VL_OUT8(led,7,0);
    CData/*0:0*/ __Vtrigrprev__TOP__clk;
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ __VstlIterCount;
    IData/*31:0*/ __VicoIterCount;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<CData/*7:0*/, 16> register8__DOT__ram;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vregister8__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vregister8___024root(Vregister8__Syms* symsp, const char* v__name);
    ~Vregister8___024root();
    VL_UNCOPYABLE(Vregister8___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
