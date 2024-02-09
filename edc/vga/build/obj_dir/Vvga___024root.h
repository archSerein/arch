// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vvga.h for the primary calling header

#ifndef VERILATED_VVGA___024ROOT_H_
#define VERILATED_VVGA___024ROOT_H_  // guard

#include "verilated.h"

class Vvga__Syms;

class Vvga___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(rst,0,0);
    VL_OUT8(VGA_HSYNC,0,0);
    VL_OUT8(VGA_VSYNC,0,0);
    VL_OUT8(VGA_BLANK_N,0,0);
    VL_OUT8(vga_r,7,0);
    VL_OUT8(vga_g,7,0);
    VL_OUT8(vga_b,7,0);
    CData/*0:0*/ __Vtrigrprev__TOP__clk;
    CData/*0:0*/ __VactContinue;
    VL_OUT16(h_addr,9,0);
    VL_OUT16(v_addr,9,0);
    SData/*9:0*/ vga__DOT__x_cnt;
    SData/*9:0*/ vga__DOT__y_cnt;
    IData/*31:0*/ __VstlIterCount;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<IData/*23:0*/, 524288> vga__DOT__vmeml__DOT__vga_mem;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vvga__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vvga___024root(Vvga__Syms* symsp, const char* v__name);
    ~Vvga___024root();
    VL_UNCOPYABLE(Vvga___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
