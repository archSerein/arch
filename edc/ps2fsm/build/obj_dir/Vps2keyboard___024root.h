// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vps2keyboard.h for the primary calling header

#ifndef VERILATED_VPS2KEYBOARD___024ROOT_H_
#define VERILATED_VPS2KEYBOARD___024ROOT_H_  // guard

#include "verilated.h"

class Vps2keyboard__Syms;

class Vps2keyboard___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(clrn,0,0);
    VL_IN8(ps2_data,0,0);
    VL_OUT8(ready,0,0);
    VL_OUT8(overflow,0,0);
    VL_IN8(ps2_clk,0,0);
    VL_OUT8(seg0,6,0);
    VL_OUT8(seg1,6,0);
    VL_OUT8(seg2,6,0);
    VL_OUT8(seg3,6,0);
    VL_OUT8(seg4,6,0);
    VL_OUT8(seg5,6,0);
    VL_OUT8(led,7,0);
    CData/*2:0*/ ps2keyboard__DOT__w_ptr;
    CData/*2:0*/ ps2keyboard__DOT__r_ptr;
    CData/*3:0*/ ps2keyboard__DOT__count;
    CData/*0:0*/ ps2keyboard__DOT__nextdata_n;
    CData/*2:0*/ ps2keyboard__DOT__ps2_clk_sync;
    CData/*0:0*/ ps2keyboard__DOT____Vlvbound_h1a91ade8__0;
    CData/*0:0*/ __Vtrigrprev__TOP__clk;
    CData/*0:0*/ __VactContinue;
    SData/*9:0*/ ps2keyboard__DOT__buffer;
    IData/*31:0*/ __VstlIterCount;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<CData/*7:0*/, 256> ps2keyboard__DOT__times;
    VlUnpacked<CData/*7:0*/, 8> ps2keyboard__DOT__fifo;
    VlUnpacked<CData/*7:0*/, 256> ps2keyboard__DOT__transl__DOT__rom;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vps2keyboard__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vps2keyboard___024root(Vps2keyboard__Syms* symsp, const char* v__name);
    ~Vps2keyboard___024root();
    VL_UNCOPYABLE(Vps2keyboard___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
