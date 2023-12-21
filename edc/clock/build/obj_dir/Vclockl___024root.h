// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vclockl.h for the primary calling header

#ifndef VERILATED_VCLOCKL___024ROOT_H_
#define VERILATED_VCLOCKL___024ROOT_H_  // guard

#include "verilated.h"

class Vclockl__Syms;

class Vclockl___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    CData/*0:0*/ clockl__DOT__clk_c;
    CData/*0:0*/ clockl__DOT__clk_m;
    VL_IN8(rst,0,0);
    VL_IN8(BTNL,0,0);
    VL_IN8(sw,2,0);
    VL_OUT8(seg0,6,0);
    VL_OUT8(seg1,6,0);
    VL_OUT8(seg2,6,0);
    VL_OUT8(seg3,6,0);
    VL_OUT8(seg4,6,0);
    VL_OUT8(seg5,6,0);
    CData/*6:0*/ clockl__DOT__hour;
    CData/*6:0*/ clockl__DOT__min;
    CData/*6:0*/ clockl__DOT__sec;
    CData/*6:0*/ clockl__DOT__temp;
    CData/*3:0*/ clockl__DOT__x;
    CData/*3:0*/ clockl__DOT__y;
    CData/*3:0*/ clockl__DOT__a;
    CData/*3:0*/ clockl__DOT__b;
    CData/*3:0*/ clockl__DOT__c;
    CData/*3:0*/ clockl__DOT__d;
    CData/*0:0*/ __Vtrigrprev__TOP__clk;
    CData/*0:0*/ __Vtrigrprev__TOP__clockl__DOT__clk_m;
    CData/*0:0*/ __Vtrigrprev__TOP__clockl__DOT__clk_c;
    CData/*0:0*/ __VactDidInit;
    CData/*0:0*/ __VactContinue;
    VL_OUT16(led,15,0);
    SData/*15:0*/ clockl__DOT__ledl;
    IData/*24:0*/ clockl__DOT__count_clk_c;
    IData/*17:0*/ clockl__DOT__count_clk_m;
    IData/*23:0*/ clockl__DOT__alarm;
    IData/*31:0*/ __VstlIterCount;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<3> __VactTriggered;
    VlTriggerVec<3> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vclockl__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vclockl___024root(Vclockl__Syms* symsp, const char* v__name);
    ~Vclockl___024root();
    VL_UNCOPYABLE(Vclockl___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
