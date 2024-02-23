// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtop.h for the primary calling header

#ifndef VERILATED_VTOP___024ROOT_H_
#define VERILATED_VTOP___024ROOT_H_  // guard

#include "verilated.h"

class Vtop__Syms;

class Vtop___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    CData/*0:0*/ top__DOT__mydatemem__DOT__rdclock;
    CData/*0:0*/ top__DOT__mydatemem__DOT__wrclock;
    CData/*0:0*/ top__DOT__myreg__DOT__wrclk;
    VL_IN8(rst,0,0);
    VL_IN8(aluc,3,0);
    VL_IN8(byteena_a,3,0);
    VL_IN8(wren,0,0);
    VL_IN8(ra,4,0);
    VL_IN8(rb,4,0);
    VL_IN8(rw,4,0);
    VL_IN8(regwr,0,0);
    VL_OUT8(zero,0,0);
    VL_OUT8(less,0,0);
    VL_OUT8(seg0,6,0);
    VL_OUT8(seg1,6,0);
    VL_OUT8(seg2,6,0);
    VL_OUT8(seg3,6,0);
    VL_OUT8(seg4,6,0);
    VL_OUT8(seg5,6,0);
    VL_OUT8(seg6,6,0);
    VL_OUT8(seg7,6,0);
    CData/*0:0*/ __Vdlyvset__top__DOT__mydatemem__DOT__ram__v0;
    CData/*0:0*/ __Vtrigrprev__TOP__clk;
    CData/*0:0*/ __Vtrigrprev__TOP__top__DOT__mydatemem__DOT__rdclock;
    CData/*0:0*/ __Vtrigrprev__TOP__top__DOT__mydatemem__DOT__wrclock;
    CData/*0:0*/ __Vtrigrprev__TOP__top__DOT__myreg__DOT__wrclk;
    CData/*0:0*/ __VactContinue;
    VL_IN16(rdaddress,14,0);
    VL_IN16(wraddress,14,0);
    SData/*14:0*/ __Vdlyvdim0__top__DOT__mydatemem__DOT__ram__v0;
    VL_IN(a,31,0);
    VL_IN(b,31,0);
    VL_IN(data,31,0);
    VL_IN(busw,31,0);
    VL_OUT(busa,31,0);
    VL_OUT(busb,31,0);
    VL_OUT(out,31,0);
    VL_OUT(q,31,0);
    IData/*31:0*/ top__DOT__mydatemem__DOT__tempout;
    IData/*31:0*/ __Vdlyvval__top__DOT__mydatemem__DOT__ram__v0;
    IData/*31:0*/ __VstlIterCount;
    IData/*31:0*/ __VicoIterCount;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<IData/*31:0*/, 32768> top__DOT__mydatemem__DOT__ram;
    VlUnpacked<IData/*31:0*/, 32> top__DOT__myreg__DOT__regfile;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<4> __VactTriggered;
    VlTriggerVec<4> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtop__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtop___024root(Vtop__Syms* symsp, const char* v__name);
    ~Vtop___024root();
    VL_UNCOPYABLE(Vtop___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
