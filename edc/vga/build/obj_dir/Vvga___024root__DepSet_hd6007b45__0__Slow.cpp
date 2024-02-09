// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vvga.h for the primary calling header

#include "verilated.h"

#include "Vvga___024root.h"

VL_ATTR_COLD void Vvga___024root___eval_static(Vvga___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vvga__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvga___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vvga___024root___eval_initial__TOP(Vvga___024root* vlSelf);

VL_ATTR_COLD void Vvga___024root___eval_initial(Vvga___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vvga__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvga___024root___eval_initial\n"); );
    // Body
    Vvga___024root___eval_initial__TOP(vlSelf);
    vlSelf->__Vtrigrprev__TOP__clk = vlSelf->clk;
}

extern const VlWide<14>/*447:0*/ Vvga__ConstPool__CONST_hf51fbe4f_0;

VL_ATTR_COLD void Vvga___024root___eval_initial__TOP(Vvga___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vvga__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvga___024root___eval_initial__TOP\n"); );
    // Body
    VL_READMEM_N(true, 24, 524288, 0, VL_CVT_PACK_STR_NW(14, Vvga__ConstPool__CONST_hf51fbe4f_0)
                 ,  &(vlSelf->vga__DOT__vmeml__DOT__vga_mem)
                 , 0, ~0ULL);
}

VL_ATTR_COLD void Vvga___024root___eval_final(Vvga___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vvga__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvga___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vvga___024root___eval_triggers__stl(Vvga___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vvga___024root___dump_triggers__stl(Vvga___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD void Vvga___024root___eval_stl(Vvga___024root* vlSelf);

VL_ATTR_COLD void Vvga___024root___eval_settle(Vvga___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vvga__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvga___024root___eval_settle\n"); );
    // Init
    CData/*0:0*/ __VstlContinue;
    // Body
    vlSelf->__VstlIterCount = 0U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        __VstlContinue = 0U;
        Vvga___024root___eval_triggers__stl(vlSelf);
        if (vlSelf->__VstlTriggered.any()) {
            __VstlContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VstlIterCount))) {
#ifdef VL_DEBUG
                Vvga___024root___dump_triggers__stl(vlSelf);
#endif
                VL_FATAL_MT("/home/serein/ysyx/yosys-sta/edc/vga/vsrc/vga.v", 1, "", "Settle region did not converge.");
            }
            vlSelf->__VstlIterCount = ((IData)(1U) 
                                       + vlSelf->__VstlIterCount);
            Vvga___024root___eval_stl(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vvga___024root___dump_triggers__stl(Vvga___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vvga__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvga___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VstlTriggered.at(0U)) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vvga___024root___stl_sequent__TOP__0(Vvga___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vvga__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvga___024root___stl_sequent__TOP__0\n"); );
    // Init
    CData/*0:0*/ vga__DOT__h_valid;
    vga__DOT__h_valid = 0;
    CData/*0:0*/ vga__DOT__v_valid;
    vga__DOT__v_valid = 0;
    IData/*23:0*/ vga__DOT__vga_data;
    vga__DOT__vga_data = 0;
    // Body
    vlSelf->VGA_HSYNC = (0x60U < (IData)(vlSelf->vga__DOT__x_cnt));
    vlSelf->VGA_VSYNC = (2U < (IData)(vlSelf->vga__DOT__y_cnt));
    vga__DOT__h_valid = ((0x90U < (IData)(vlSelf->vga__DOT__x_cnt)) 
                         & (0x310U >= (IData)(vlSelf->vga__DOT__x_cnt)));
    vga__DOT__v_valid = ((0x23U < (IData)(vlSelf->vga__DOT__y_cnt)) 
                         & (0x203U >= (IData)(vlSelf->vga__DOT__y_cnt)));
    vlSelf->h_addr = ((IData)(vga__DOT__h_valid) ? 
                      (0x3ffU & ((IData)(vlSelf->vga__DOT__x_cnt) 
                                 - (IData)(0x91U)))
                       : 0U);
    if (vga__DOT__v_valid) {
        vlSelf->v_addr = (0x3ffU & ((IData)(vlSelf->vga__DOT__y_cnt) 
                                    - (IData)(0x24U)));
        vlSelf->VGA_BLANK_N = vga__DOT__h_valid;
    } else {
        vlSelf->v_addr = 0U;
        vlSelf->VGA_BLANK_N = 0U;
    }
    vga__DOT__vga_data = vlSelf->vga__DOT__vmeml__DOT__vga_mem
        [(((IData)(vlSelf->h_addr) << 9U) | ((IData)(vga__DOT__v_valid)
                                              ? (0x1ffU 
                                                 & ((IData)(vlSelf->vga__DOT__y_cnt) 
                                                    - (IData)(0x24U)))
                                              : 0U))];
    vlSelf->vga_r = (0xffU & (vga__DOT__vga_data >> 0x10U));
    vlSelf->vga_g = (0xffU & (vga__DOT__vga_data >> 8U));
    vlSelf->vga_b = (0xffU & vga__DOT__vga_data);
}

VL_ATTR_COLD void Vvga___024root___eval_stl(Vvga___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vvga__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvga___024root___eval_stl\n"); );
    // Body
    if (vlSelf->__VstlTriggered.at(0U)) {
        Vvga___024root___stl_sequent__TOP__0(vlSelf);
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vvga___024root___dump_triggers__act(Vvga___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vvga__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvga___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VactTriggered.at(0U)) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vvga___024root___dump_triggers__nba(Vvga___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vvga__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvga___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VnbaTriggered.at(0U)) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vvga___024root___ctor_var_reset(Vvga___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vvga__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vvga___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = 0;
    vlSelf->rst = 0;
    vlSelf->h_addr = 0;
    vlSelf->v_addr = 0;
    vlSelf->VGA_HSYNC = 0;
    vlSelf->VGA_VSYNC = 0;
    vlSelf->VGA_BLANK_N = 0;
    vlSelf->vga_r = 0;
    vlSelf->vga_g = 0;
    vlSelf->vga_b = 0;
    vlSelf->vga__DOT__x_cnt = 0;
    vlSelf->vga__DOT__y_cnt = 0;
    for (int __Vi0 = 0; __Vi0 < 524288; ++__Vi0) {
        vlSelf->vga__DOT__vmeml__DOT__vga_mem[__Vi0] = 0;
    }
    vlSelf->__Vtrigrprev__TOP__clk = 0;
}
