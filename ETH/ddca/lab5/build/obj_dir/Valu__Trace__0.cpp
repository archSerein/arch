// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Valu__Syms.h"


void Valu___024root__trace_chg_sub_0(Valu___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Valu___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root__trace_chg_top_0\n"); );
    // Init
    Valu___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Valu___024root*>(voidSelf);
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Valu___024root__trace_chg_sub_0((&vlSymsp->TOP), bufp);
}

void Valu___024root__trace_chg_sub_0(Valu___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root__trace_chg_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[0U])) {
        bufp->chgCData(oldp+0,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__0__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+1,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__0__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+2,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__0__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+3,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__0__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+4,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__10__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+5,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__10__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+6,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__10__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+7,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__10__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+8,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__11__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+9,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__11__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+10,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__11__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+11,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__11__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+12,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__12__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+13,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__12__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+14,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__12__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+15,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__12__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+16,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__13__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+17,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__13__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+18,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__13__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+19,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__13__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+20,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__14__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+21,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__14__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+22,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__14__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+23,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__14__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+24,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__15__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+25,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__15__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+26,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__15__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+27,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__15__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+28,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__16__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+29,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__16__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+30,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__16__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+31,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__16__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+32,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__17__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+33,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__17__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+34,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__17__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+35,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__17__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+36,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__18__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+37,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__18__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+38,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__18__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+39,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__18__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+40,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__19__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+41,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__19__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+42,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__19__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+43,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__19__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+44,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__1__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+45,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__1__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+46,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__1__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+47,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__1__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+48,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__20__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+49,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__20__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+50,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__20__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+51,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__20__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+52,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__21__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+53,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__21__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+54,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__21__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+55,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__21__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+56,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__22__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+57,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__22__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+58,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__22__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+59,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__22__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+60,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__23__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+61,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__23__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+62,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__23__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+63,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__23__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+64,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__24__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+65,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__24__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+66,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__24__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+67,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__24__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+68,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__25__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+69,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__25__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+70,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__25__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+71,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__25__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+72,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__26__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+73,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__26__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+74,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__26__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+75,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__26__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+76,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__27__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+77,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__27__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+78,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__27__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+79,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__27__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+80,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__28__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+81,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__28__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+82,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__28__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+83,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__28__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+84,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__29__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+85,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__29__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+86,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__29__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+87,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__29__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+88,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__2__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+89,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__2__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+90,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__2__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+91,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__2__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+92,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__30__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+93,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__30__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+94,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__30__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+95,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__30__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+96,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__31__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+97,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__31__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+98,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__31__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+99,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__31__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+100,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__3__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+101,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__3__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+102,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__3__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+103,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__3__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+104,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__4__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+105,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__4__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+106,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__4__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+107,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__4__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+108,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__5__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+109,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__5__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+110,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__5__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+111,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__5__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+112,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__6__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+113,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__6__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+114,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__6__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+115,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__6__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+116,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__7__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+117,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__7__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+118,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__7__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+119,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__7__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+120,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__8__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+121,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__8__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+122,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__8__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+123,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__8__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
        bufp->chgCData(oldp+124,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__9__KET____DOT__mux__DOT__i0__DOT__key_list[0]),2);
        bufp->chgCData(oldp+125,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__9__KET____DOT__mux__DOT__i0__DOT__key_list[1]),2);
        bufp->chgCData(oldp+126,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__9__KET____DOT__mux__DOT__i0__DOT__key_list[2]),2);
        bufp->chgCData(oldp+127,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__9__KET____DOT__mux__DOT__i0__DOT__key_list[3]),2);
    }
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[1U])) {
        bufp->chgIData(oldp+128,((((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__31__KET____DOT__mux____pinNumber1) 
                                   << 0x1fU) | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__30__KET____DOT__mux____pinNumber1) 
                                                 << 0x1eU) 
                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__29__KET____DOT__mux____pinNumber1) 
                                                    << 0x1dU) 
                                                   | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__28__KET____DOT__mux____pinNumber1) 
                                                       << 0x1cU) 
                                                      | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__27__KET____DOT__mux____pinNumber1) 
                                                          << 0x1bU) 
                                                         | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__26__KET____DOT__mux____pinNumber1) 
                                                             << 0x1aU) 
                                                            | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__25__KET____DOT__mux____pinNumber1) 
                                                                << 0x19U) 
                                                               | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__24__KET____DOT__mux____pinNumber1) 
                                                                   << 0x18U) 
                                                                  | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__23__KET____DOT__mux____pinNumber1) 
                                                                      << 0x17U) 
                                                                     | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__22__KET____DOT__mux____pinNumber1) 
                                                                         << 0x16U) 
                                                                        | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__21__KET____DOT__mux____pinNumber1) 
                                                                            << 0x15U) 
                                                                           | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__20__KET____DOT__mux____pinNumber1) 
                                                                               << 0x14U) 
                                                                              | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__19__KET____DOT__mux____pinNumber1) 
                                                                                << 0x13U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__18__KET____DOT__mux____pinNumber1) 
                                                                                << 0x12U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__17__KET____DOT__mux____pinNumber1) 
                                                                                << 0x11U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__16__KET____DOT__mux____pinNumber1) 
                                                                                << 0x10U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__15__KET____DOT__mux____pinNumber1) 
                                                                                << 0xfU) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__14__KET____DOT__mux____pinNumber1) 
                                                                                << 0xeU) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__13__KET____DOT__mux____pinNumber1) 
                                                                                << 0xdU) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__12__KET____DOT__mux____pinNumber1) 
                                                                                << 0xcU) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__11__KET____DOT__mux____pinNumber1) 
                                                                                << 0xbU) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__10__KET____DOT__mux____pinNumber1) 
                                                                                << 0xaU) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__9__KET____DOT__mux____pinNumber1) 
                                                                                << 9U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__8__KET____DOT__mux____pinNumber1) 
                                                                                << 8U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__7__KET____DOT__mux____pinNumber1) 
                                                                                << 7U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__6__KET____DOT__mux____pinNumber1) 
                                                                                << 6U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__5__KET____DOT__mux____pinNumber1) 
                                                                                << 5U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__4__KET____DOT__mux____pinNumber1) 
                                                                                << 4U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__3__KET____DOT__mux____pinNumber1) 
                                                                                << 3U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__2__KET____DOT__mux____pinNumber1) 
                                                                                << 2U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__1__KET____DOT__mux____pinNumber1) 
                                                                                << 1U) 
                                                                                | (IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__0__KET____DOT__mux____pinNumber1))))))))))))))))))))))))))))))))),32);
        bufp->chgIData(oldp+129,(vlSelf->alu__DOT__S),32);
        bufp->chgBit(oldp+130,((0U == vlSelf->alu__DOT__S)));
        bufp->chgCData(oldp+131,((((IData)(vlSelf->alu__DOT__arith_module__DOT____Vcellout__adder16_2__pm) 
                                   << 1U) | (IData)(vlSelf->alu__DOT__arith_module__DOT____Vcellout__adder16_1__pm))),2);
        bufp->chgCData(oldp+132,(((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_4__gn) 
                                    ^ (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_3__gn) 
                                        & (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_4__pn)) 
                                       ^ (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____VdfgTmp_hf4f18bc7__0) 
                                           & (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_2__gn)) 
                                          ^ ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____VdfgTmp_hf4f18bc7__0) 
                                             & (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____VdfgTmp_h5bf9af88__0))))) 
                                   << 1U) | (IData)(vlSelf->alu__DOT__arith_module__DOT____Vcellout__adder16_1__gm))),2);
        bufp->chgBit(oldp+133,(vlSelf->alu__DOT__arith_module__DOT__c_16));
        bufp->chgIData(oldp+134,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_4__y) 
                                   << 0x1fU) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_3__y) 
                                                 << 0x1eU) 
                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_2__y) 
                                                    << 0x1dU) 
                                                   | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_1__y) 
                                                       << 0x1cU) 
                                                      | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_4__y) 
                                                          << 0x1bU) 
                                                         | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_3__y) 
                                                             << 0x1aU) 
                                                            | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_2__y) 
                                                                << 0x19U) 
                                                               | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_1__y) 
                                                                   << 0x18U) 
                                                                  | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_4__y) 
                                                                      << 0x17U) 
                                                                     | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_3__y) 
                                                                         << 0x16U) 
                                                                        | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_2__y) 
                                                                            << 0x15U) 
                                                                           | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_1__y) 
                                                                               << 0x14U) 
                                                                              | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_4__y) 
                                                                                << 0x13U) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_3__y) 
                                                                                << 0x12U) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_2__y) 
                                                                                << 0x11U) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_1__y) 
                                                                                << 0x10U) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_4__y) 
                                                                                << 0xfU) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_3__y) 
                                                                                << 0xeU) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_2__y) 
                                                                                << 0xdU) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_1__y) 
                                                                                << 0xcU) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_4__y) 
                                                                                << 0xbU) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_3__y) 
                                                                                << 0xaU) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_2__y) 
                                                                                << 9U) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_1__y) 
                                                                                << 8U) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_4__y) 
                                                                                << 7U) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_3__y) 
                                                                                << 6U) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_2__y) 
                                                                                << 5U) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_1__y) 
                                                                                << 4U) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_4__y) 
                                                                                << 3U) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_3__y) 
                                                                                << 2U) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_2__y) 
                                                                                << 1U) 
                                                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_1__y))))))))))))))))))))))))))))))))),32);
        bufp->chgSData(oldp+135,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_4__y) 
                                   << 0xfU) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_3__y) 
                                                << 0xeU) 
                                               | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_2__y) 
                                                   << 0xdU) 
                                                  | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_1__y) 
                                                      << 0xcU) 
                                                     | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_4__y) 
                                                         << 0xbU) 
                                                        | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_3__y) 
                                                            << 0xaU) 
                                                           | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_2__y) 
                                                               << 9U) 
                                                              | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_1__y) 
                                                                  << 8U) 
                                                                 | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_4__y) 
                                                                     << 7U) 
                                                                    | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_3__y) 
                                                                        << 6U) 
                                                                       | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_2__y) 
                                                                           << 5U) 
                                                                          | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_1__y) 
                                                                              << 4U) 
                                                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_4__y) 
                                                                                << 3U) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_3__y) 
                                                                                << 2U) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_2__y) 
                                                                                << 1U) 
                                                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_1__y))))))))))))))))),16);
        bufp->chgBit(oldp+136,(vlSelf->alu__DOT__arith_module__DOT____Vcellout__adder16_1__pm));
        bufp->chgBit(oldp+137,(vlSelf->alu__DOT__arith_module__DOT____Vcellout__adder16_1__gm));
        bufp->chgCData(oldp+138,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellout__adder4_4__pn) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellout__adder4_3__pn) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellout__adder4_2__pn) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellout__adder4_1__pn))))),4);
        bufp->chgCData(oldp+139,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellout__adder4_4__gn) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellout__adder4_3__gn) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellout__adder4_2__gn) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellout__adder4_1__gn))))),4);
        bufp->chgCData(oldp+140,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_4__y) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_3__y) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_2__y) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_1__y))))),4);
        bufp->chgBit(oldp+141,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellout__adder4_1__pn));
        bufp->chgBit(oldp+142,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellout__adder4_1__gn));
        bufp->chgCData(oldp+143,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__adder_4__DOT__t) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__adder_1__DOT__t))))),4);
        bufp->chgBit(oldp+144,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_1__y));
        bufp->chgBit(oldp+145,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__adder_1__DOT__t));
        bufp->chgBit(oldp+146,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_2__y));
        bufp->chgBit(oldp+147,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_2__c));
        bufp->chgBit(oldp+148,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_2__c))));
        bufp->chgBit(oldp+149,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0));
        bufp->chgBit(oldp+150,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_3__y));
        bufp->chgBit(oldp+151,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_3__c));
        bufp->chgBit(oldp+152,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_3__c))));
        bufp->chgBit(oldp+153,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0));
        bufp->chgBit(oldp+154,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_4__y));
        bufp->chgBit(oldp+155,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_4__c));
        bufp->chgBit(oldp+156,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__adder_4__DOT__t) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_4__c))));
        bufp->chgBit(oldp+157,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__adder_4__DOT__t));
        bufp->chgCData(oldp+158,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_4__y) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_3__y) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_2__y) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_1__y))))),4);
        bufp->chgBit(oldp+159,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_2__cin));
        bufp->chgBit(oldp+160,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellout__adder4_2__pn));
        bufp->chgBit(oldp+161,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellout__adder4_2__gn));
        bufp->chgCData(oldp+162,(((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__adder_4__DOT__t) 
                                    ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_4__c)) 
                                   << 3U) | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                               ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_3__c)) 
                                              << 2U) 
                                             | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                  ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_2__c)) 
                                                 << 1U) 
                                                | ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__adder_1__DOT__t) 
                                                   ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_2__cin)))))),4);
        bufp->chgCData(oldp+163,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__adder_4__DOT__t) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__adder_1__DOT__t))))),4);
        bufp->chgCData(oldp+164,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_4__c) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_3__c) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_2__c) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_2__cin))))),4);
        bufp->chgBit(oldp+165,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_1__y));
        bufp->chgBit(oldp+166,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__adder_1__DOT__t) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_2__cin))));
        bufp->chgBit(oldp+167,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__adder_1__DOT__t));
        bufp->chgBit(oldp+168,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_2__y));
        bufp->chgBit(oldp+169,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_2__c));
        bufp->chgBit(oldp+170,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_2__c))));
        bufp->chgBit(oldp+171,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0));
        bufp->chgBit(oldp+172,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_3__y));
        bufp->chgBit(oldp+173,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_3__c));
        bufp->chgBit(oldp+174,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_3__c))));
        bufp->chgBit(oldp+175,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0));
        bufp->chgBit(oldp+176,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_4__y));
        bufp->chgBit(oldp+177,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_4__c));
        bufp->chgBit(oldp+178,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__adder_4__DOT__t) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_4__c))));
        bufp->chgBit(oldp+179,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__adder_4__DOT__t));
        bufp->chgCData(oldp+180,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_4__y) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_3__y) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_2__y) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_1__y))))),4);
        bufp->chgBit(oldp+181,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_3__cin));
        bufp->chgBit(oldp+182,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellout__adder4_3__pn));
        bufp->chgBit(oldp+183,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellout__adder4_3__gn));
        bufp->chgCData(oldp+184,(((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__adder_4__DOT__t) 
                                    ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_4__c)) 
                                   << 3U) | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                               ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_3__c)) 
                                              << 2U) 
                                             | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                  ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_2__c)) 
                                                 << 1U) 
                                                | ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__adder_1__DOT__t) 
                                                   ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_3__cin)))))),4);
        bufp->chgCData(oldp+185,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__adder_4__DOT__t) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__adder_1__DOT__t))))),4);
        bufp->chgCData(oldp+186,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_4__c) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_3__c) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_2__c) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_3__cin))))),4);
        bufp->chgBit(oldp+187,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_1__y));
        bufp->chgBit(oldp+188,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__adder_1__DOT__t) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_3__cin))));
        bufp->chgBit(oldp+189,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__adder_1__DOT__t));
        bufp->chgBit(oldp+190,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_2__y));
        bufp->chgBit(oldp+191,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_2__c));
        bufp->chgBit(oldp+192,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_2__c))));
        bufp->chgBit(oldp+193,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0));
        bufp->chgBit(oldp+194,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_3__y));
        bufp->chgBit(oldp+195,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_3__c));
        bufp->chgBit(oldp+196,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_3__c))));
        bufp->chgBit(oldp+197,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0));
        bufp->chgBit(oldp+198,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_4__y));
        bufp->chgBit(oldp+199,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_4__c));
        bufp->chgBit(oldp+200,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__adder_4__DOT__t) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_4__c))));
        bufp->chgBit(oldp+201,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__adder_4__DOT__t));
        bufp->chgCData(oldp+202,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_4__y) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_3__y) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_2__y) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_1__y))))),4);
        bufp->chgBit(oldp+203,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_4__cin));
        bufp->chgBit(oldp+204,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellout__adder4_4__pn));
        bufp->chgBit(oldp+205,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellout__adder4_4__gn));
        bufp->chgCData(oldp+206,(((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__adder_4__DOT__t) 
                                    ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_4__c)) 
                                   << 3U) | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                               ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_3__c)) 
                                              << 2U) 
                                             | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                  ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_2__c)) 
                                                 << 1U) 
                                                | ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__adder_1__DOT__t) 
                                                   ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_4__cin)))))),4);
        bufp->chgCData(oldp+207,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__adder_4__DOT__t) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__adder_1__DOT__t))))),4);
        bufp->chgCData(oldp+208,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_4__c) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_3__c) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_2__c) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_4__cin))))),4);
        bufp->chgBit(oldp+209,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_1__y));
        bufp->chgBit(oldp+210,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__adder_1__DOT__t) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_4__cin))));
        bufp->chgBit(oldp+211,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__adder_1__DOT__t));
        bufp->chgBit(oldp+212,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_2__y));
        bufp->chgBit(oldp+213,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_2__c));
        bufp->chgBit(oldp+214,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_2__c))));
        bufp->chgBit(oldp+215,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0));
        bufp->chgBit(oldp+216,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_3__y));
        bufp->chgBit(oldp+217,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_3__c));
        bufp->chgBit(oldp+218,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_3__c))));
        bufp->chgBit(oldp+219,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0));
        bufp->chgBit(oldp+220,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_4__y));
        bufp->chgBit(oldp+221,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_4__c));
        bufp->chgBit(oldp+222,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__adder_4__DOT__t) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_4__c))));
        bufp->chgBit(oldp+223,(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__adder_4__DOT__t));
        bufp->chgSData(oldp+224,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_4__y) 
                                   << 0xfU) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_3__y) 
                                                << 0xeU) 
                                               | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_2__y) 
                                                   << 0xdU) 
                                                  | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_1__y) 
                                                      << 0xcU) 
                                                     | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_4__y) 
                                                         << 0xbU) 
                                                        | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_3__y) 
                                                            << 0xaU) 
                                                           | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_2__y) 
                                                               << 9U) 
                                                              | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_1__y) 
                                                                  << 8U) 
                                                                 | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_4__y) 
                                                                     << 7U) 
                                                                    | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_3__y) 
                                                                        << 6U) 
                                                                       | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_2__y) 
                                                                           << 5U) 
                                                                          | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_1__y) 
                                                                              << 4U) 
                                                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_4__y) 
                                                                                << 3U) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_3__y) 
                                                                                << 2U) 
                                                                                | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_2__y) 
                                                                                << 1U) 
                                                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_1__y))))))))))))))))),16);
        bufp->chgBit(oldp+225,(vlSelf->alu__DOT__arith_module__DOT____Vcellout__adder16_2__pm));
        bufp->chgBit(oldp+226,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_4__gn) 
                                ^ (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_3__gn) 
                                    & (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_4__pn)) 
                                   ^ (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____VdfgTmp_hf4f18bc7__0) 
                                       & (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_2__gn)) 
                                      ^ ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____VdfgTmp_hf4f18bc7__0) 
                                         & (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____VdfgTmp_h5bf9af88__0)))))));
        bufp->chgCData(oldp+227,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_4__pn) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_3__pn) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_2__pn) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_1__pn))))),4);
        bufp->chgCData(oldp+228,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_4__gn) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_3__gn) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_2__gn) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_1__gn))))),4);
        bufp->chgCData(oldp+229,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_4__cin) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_3__cin) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_2__cin) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__c_16))))),4);
        bufp->chgCData(oldp+230,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_4__y) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_3__y) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_2__y) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_1__y))))),4);
        bufp->chgBit(oldp+231,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_1__pn));
        bufp->chgBit(oldp+232,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_1__gn));
        bufp->chgCData(oldp+233,(((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__adder_4__DOT__t) 
                                    ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_4__c)) 
                                   << 3U) | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                               ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_3__c)) 
                                              << 2U) 
                                             | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                  ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_2__c)) 
                                                 << 1U) 
                                                | ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__adder_1__DOT__t) 
                                                   ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__c_16)))))),4);
        bufp->chgCData(oldp+234,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__adder_4__DOT__t) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__adder_1__DOT__t))))),4);
        bufp->chgCData(oldp+235,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_4__c) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_3__c) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_2__c) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__c_16))))),4);
        bufp->chgBit(oldp+236,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_1__y));
        bufp->chgBit(oldp+237,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__adder_1__DOT__t) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__c_16))));
        bufp->chgBit(oldp+238,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__adder_1__DOT__t));
        bufp->chgBit(oldp+239,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_2__y));
        bufp->chgBit(oldp+240,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_2__c));
        bufp->chgBit(oldp+241,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_2__c))));
        bufp->chgBit(oldp+242,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0));
        bufp->chgBit(oldp+243,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_3__y));
        bufp->chgBit(oldp+244,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_3__c));
        bufp->chgBit(oldp+245,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_3__c))));
        bufp->chgBit(oldp+246,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0));
        bufp->chgBit(oldp+247,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_4__y));
        bufp->chgBit(oldp+248,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_4__c));
        bufp->chgBit(oldp+249,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__adder_4__DOT__t) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_4__c))));
        bufp->chgBit(oldp+250,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__adder_4__DOT__t));
        bufp->chgCData(oldp+251,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_4__y) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_3__y) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_2__y) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_1__y))))),4);
        bufp->chgBit(oldp+252,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_2__cin));
        bufp->chgBit(oldp+253,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_2__pn));
        bufp->chgBit(oldp+254,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_2__gn));
        bufp->chgCData(oldp+255,(((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__adder_4__DOT__t) 
                                    ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_4__c)) 
                                   << 3U) | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                               ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_3__c)) 
                                              << 2U) 
                                             | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                  ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_2__c)) 
                                                 << 1U) 
                                                | ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__adder_1__DOT__t) 
                                                   ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_2__cin)))))),4);
        bufp->chgCData(oldp+256,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__adder_4__DOT__t) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__adder_1__DOT__t))))),4);
        bufp->chgCData(oldp+257,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_4__c) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_3__c) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_2__c) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_2__cin))))),4);
        bufp->chgBit(oldp+258,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_1__y));
        bufp->chgBit(oldp+259,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__adder_1__DOT__t) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_2__cin))));
        bufp->chgBit(oldp+260,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__adder_1__DOT__t));
        bufp->chgBit(oldp+261,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_2__y));
        bufp->chgBit(oldp+262,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_2__c));
        bufp->chgBit(oldp+263,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_2__c))));
        bufp->chgBit(oldp+264,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0));
        bufp->chgBit(oldp+265,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_3__y));
        bufp->chgBit(oldp+266,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_3__c));
        bufp->chgBit(oldp+267,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_3__c))));
        bufp->chgBit(oldp+268,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0));
        bufp->chgBit(oldp+269,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_4__y));
        bufp->chgBit(oldp+270,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_4__c));
        bufp->chgBit(oldp+271,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__adder_4__DOT__t) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_4__c))));
        bufp->chgBit(oldp+272,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__adder_4__DOT__t));
        bufp->chgCData(oldp+273,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_4__y) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_3__y) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_2__y) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_1__y))))),4);
        bufp->chgBit(oldp+274,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_3__cin));
        bufp->chgBit(oldp+275,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_3__pn));
        bufp->chgBit(oldp+276,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_3__gn));
        bufp->chgCData(oldp+277,(((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__adder_4__DOT__t) 
                                    ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_4__c)) 
                                   << 3U) | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                               ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_3__c)) 
                                              << 2U) 
                                             | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                  ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_2__c)) 
                                                 << 1U) 
                                                | ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__adder_1__DOT__t) 
                                                   ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_3__cin)))))),4);
        bufp->chgCData(oldp+278,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__adder_4__DOT__t) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__adder_1__DOT__t))))),4);
        bufp->chgCData(oldp+279,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_4__c) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_3__c) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_2__c) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_3__cin))))),4);
        bufp->chgBit(oldp+280,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_1__y));
        bufp->chgBit(oldp+281,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__adder_1__DOT__t) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_3__cin))));
        bufp->chgBit(oldp+282,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__adder_1__DOT__t));
        bufp->chgBit(oldp+283,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_2__y));
        bufp->chgBit(oldp+284,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_2__c));
        bufp->chgBit(oldp+285,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_2__c))));
        bufp->chgBit(oldp+286,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0));
        bufp->chgBit(oldp+287,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_3__y));
        bufp->chgBit(oldp+288,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_3__c));
        bufp->chgBit(oldp+289,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_3__c))));
        bufp->chgBit(oldp+290,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0));
        bufp->chgBit(oldp+291,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_4__y));
        bufp->chgBit(oldp+292,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_4__c));
        bufp->chgBit(oldp+293,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__adder_4__DOT__t) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_4__c))));
        bufp->chgBit(oldp+294,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__adder_4__DOT__t));
        bufp->chgCData(oldp+295,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_4__y) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_3__y) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_2__y) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_1__y))))),4);
        bufp->chgBit(oldp+296,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_4__cin));
        bufp->chgBit(oldp+297,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_4__pn));
        bufp->chgBit(oldp+298,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_4__gn));
        bufp->chgCData(oldp+299,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__adder_4__DOT__t) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__adder_1__DOT__t))))),4);
        bufp->chgCData(oldp+300,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_4__c) 
                                   << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_3__c) 
                                              << 2U) 
                                             | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_2__c) 
                                                 << 1U) 
                                                | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_4__cin))))),4);
        bufp->chgBit(oldp+301,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_1__y));
        bufp->chgBit(oldp+302,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__adder_1__DOT__t) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_4__cin))));
        bufp->chgBit(oldp+303,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__adder_1__DOT__t));
        bufp->chgBit(oldp+304,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_2__y));
        bufp->chgBit(oldp+305,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_2__c));
        bufp->chgBit(oldp+306,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_2__c))));
        bufp->chgBit(oldp+307,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0));
        bufp->chgBit(oldp+308,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_3__y));
        bufp->chgBit(oldp+309,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_3__c));
        bufp->chgBit(oldp+310,(((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_3__c))));
        bufp->chgBit(oldp+311,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0));
        bufp->chgBit(oldp+312,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_4__y));
        bufp->chgBit(oldp+313,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_4__c));
        bufp->chgBit(oldp+314,(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__adder_4__DOT__t));
        bufp->chgBit(oldp+315,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__0__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+316,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__0__KET____DOT__mux____pinNumber2),2);
        bufp->chgSData(oldp+317,((0xa6U | (((IData)(vlSelf->__VdfgTmp_h56239478__0) 
                                            << 9U) 
                                           | (((IData)(vlSelf->alu__DOT__bool_module__DOT____VdfgTmp_h6099232e__0) 
                                               << 6U) 
                                              | (((IData)(vlSelf->alu__DOT__bool_module__DOT____VdfgTmp_h6099232e__0) 
                                                  << 3U) 
                                                 | (IData)(vlSelf->__VdfgTmp_h654f618d__0)))))),12);
        bufp->chgCData(oldp+318,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__0__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+319,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__0__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+320,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__0__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+321,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__0__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+322,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__0__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+323,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__0__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+324,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__0__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+325,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__0__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+326,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__0__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+327,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__0__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+328,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__10__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+329,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__10__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+330,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__10__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+331,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__10__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+332,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__10__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+333,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__10__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+334,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__10__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+335,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__10__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+336,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__10__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+337,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__10__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+338,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__10__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+339,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__10__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+340,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__11__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+341,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__11__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+342,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__11__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+343,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__11__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+344,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__11__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+345,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__11__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+346,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__11__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+347,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__11__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+348,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__11__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+349,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__11__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+350,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__11__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+351,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__11__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+352,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__12__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+353,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__12__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+354,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__12__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+355,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__12__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+356,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__12__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+357,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__12__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+358,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__12__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+359,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__12__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+360,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__12__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+361,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__12__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+362,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__12__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+363,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__12__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+364,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__13__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+365,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__13__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+366,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__13__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+367,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__13__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+368,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__13__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+369,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__13__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+370,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__13__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+371,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__13__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+372,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__13__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+373,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__13__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+374,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__13__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+375,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__13__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+376,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__14__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+377,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__14__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+378,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__14__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+379,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__14__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+380,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__14__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+381,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__14__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+382,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__14__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+383,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__14__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+384,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__14__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+385,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__14__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+386,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__14__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+387,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__14__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+388,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__15__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+389,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__15__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+390,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__15__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+391,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__15__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+392,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__15__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+393,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__15__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+394,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__15__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+395,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__15__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+396,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__15__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+397,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__15__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+398,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__15__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+399,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__15__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+400,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__16__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+401,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__16__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+402,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__16__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+403,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__16__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+404,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__16__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+405,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__16__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+406,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__16__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+407,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__16__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+408,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__16__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+409,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__16__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+410,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__16__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+411,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__16__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+412,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__17__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+413,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__17__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+414,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__17__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+415,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__17__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+416,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__17__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+417,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__17__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+418,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__17__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+419,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__17__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+420,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__17__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+421,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__17__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+422,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__17__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+423,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__17__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+424,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__18__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+425,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__18__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+426,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__18__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+427,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__18__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+428,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__18__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+429,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__18__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+430,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__18__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+431,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__18__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+432,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__18__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+433,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__18__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+434,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__18__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+435,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__18__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+436,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__19__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+437,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__19__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+438,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__19__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+439,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__19__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+440,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__19__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+441,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__19__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+442,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__19__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+443,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__19__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+444,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__19__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+445,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__19__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+446,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__19__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+447,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__19__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+448,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__1__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+449,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__1__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+450,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__1__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+451,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__1__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+452,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__1__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+453,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__1__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+454,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__1__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+455,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__1__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+456,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__1__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+457,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__1__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+458,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__1__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+459,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__1__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+460,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__20__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+461,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__20__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+462,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__20__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+463,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__20__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+464,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__20__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+465,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__20__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+466,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__20__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+467,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__20__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+468,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__20__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+469,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__20__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+470,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__20__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+471,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__20__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+472,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__21__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+473,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__21__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+474,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__21__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+475,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__21__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+476,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__21__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+477,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__21__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+478,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__21__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+479,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__21__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+480,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__21__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+481,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__21__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+482,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__21__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+483,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__21__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+484,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__22__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+485,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__22__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+486,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__22__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+487,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__22__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+488,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__22__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+489,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__22__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+490,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__22__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+491,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__22__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+492,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__22__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+493,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__22__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+494,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__22__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+495,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__22__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+496,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__23__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+497,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__23__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+498,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__23__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+499,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__23__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+500,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__23__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+501,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__23__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+502,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__23__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+503,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__23__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+504,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__23__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+505,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__23__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+506,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__23__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+507,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__23__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+508,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__24__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+509,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__24__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+510,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__24__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+511,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__24__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+512,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__24__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+513,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__24__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+514,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__24__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+515,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__24__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+516,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__24__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+517,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__24__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+518,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__24__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+519,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__24__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+520,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__25__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+521,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__25__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+522,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__25__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+523,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__25__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+524,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__25__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+525,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__25__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+526,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__25__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+527,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__25__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+528,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__25__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+529,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__25__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+530,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__25__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+531,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__25__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+532,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__26__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+533,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__26__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+534,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__26__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+535,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__26__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+536,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__26__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+537,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__26__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+538,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__26__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+539,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__26__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+540,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__26__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+541,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__26__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+542,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__26__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+543,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__26__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+544,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__27__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+545,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__27__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+546,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__27__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+547,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__27__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+548,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__27__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+549,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__27__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+550,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__27__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+551,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__27__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+552,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__27__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+553,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__27__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+554,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__27__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+555,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__27__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+556,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__28__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+557,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__28__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+558,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__28__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+559,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__28__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+560,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__28__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+561,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__28__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+562,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__28__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+563,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__28__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+564,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__28__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+565,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__28__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+566,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__28__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+567,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__28__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+568,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__29__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+569,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__29__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+570,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__29__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+571,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__29__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+572,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__29__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+573,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__29__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+574,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__29__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+575,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__29__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+576,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__29__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+577,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__29__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+578,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__29__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+579,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__29__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+580,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__2__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+581,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__2__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+582,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__2__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+583,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__2__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+584,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__2__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+585,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__2__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+586,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__2__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+587,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__2__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+588,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__2__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+589,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__2__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+590,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__2__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+591,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__2__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+592,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__30__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+593,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__30__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+594,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__30__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+595,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__30__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+596,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__30__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+597,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__30__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+598,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__30__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+599,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__30__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+600,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__30__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+601,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__30__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+602,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__30__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+603,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__30__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+604,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__31__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+605,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__31__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+606,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__31__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+607,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__31__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+608,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__31__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+609,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__31__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+610,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__31__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+611,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__31__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+612,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__31__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+613,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__31__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+614,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__31__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+615,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__31__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+616,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__3__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+617,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__3__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+618,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__3__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+619,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__3__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+620,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__3__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+621,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__3__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+622,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__3__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+623,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__3__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+624,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__3__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+625,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__3__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+626,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__3__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+627,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__3__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+628,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__4__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+629,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__4__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+630,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__4__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+631,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__4__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+632,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__4__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+633,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__4__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+634,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__4__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+635,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__4__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+636,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__4__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+637,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__4__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+638,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__4__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+639,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__4__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+640,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__5__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+641,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__5__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+642,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__5__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+643,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__5__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+644,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__5__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+645,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__5__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+646,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__5__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+647,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__5__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+648,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__5__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+649,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__5__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+650,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__5__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+651,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__5__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+652,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__6__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+653,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__6__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+654,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__6__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+655,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__6__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+656,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__6__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+657,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__6__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+658,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__6__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+659,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__6__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+660,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__6__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+661,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__6__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+662,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__6__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+663,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__6__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+664,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__7__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+665,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__7__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+666,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__7__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+667,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__7__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+668,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__7__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+669,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__7__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+670,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__7__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+671,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__7__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+672,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__7__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+673,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__7__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+674,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__7__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+675,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__7__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+676,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__8__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+677,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__8__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+678,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__8__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+679,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__8__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+680,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__8__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+681,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__8__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+682,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__8__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+683,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__8__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+684,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__8__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+685,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__8__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+686,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__8__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+687,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__8__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgBit(oldp+688,(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__9__KET____DOT__mux____pinNumber1));
        bufp->chgCData(oldp+689,(vlSelf->alu__DOT__bool_module__DOT____Vcellinp__bool__BRA__9__KET____DOT__mux____pinNumber2),2);
        bufp->chgCData(oldp+690,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__9__KET____DOT__mux__DOT__i0__DOT__pair_list[0]),3);
        bufp->chgCData(oldp+691,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__9__KET____DOT__mux__DOT__i0__DOT__pair_list[1]),3);
        bufp->chgCData(oldp+692,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__9__KET____DOT__mux__DOT__i0__DOT__pair_list[2]),3);
        bufp->chgCData(oldp+693,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__9__KET____DOT__mux__DOT__i0__DOT__pair_list[3]),3);
        bufp->chgBit(oldp+694,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__9__KET____DOT__mux__DOT__i0__DOT__data_list[0]));
        bufp->chgBit(oldp+695,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__9__KET____DOT__mux__DOT__i0__DOT__data_list[1]));
        bufp->chgBit(oldp+696,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__9__KET____DOT__mux__DOT__i0__DOT__data_list[2]));
        bufp->chgBit(oldp+697,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__9__KET____DOT__mux__DOT__i0__DOT__data_list[3]));
        bufp->chgBit(oldp+698,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__9__KET____DOT__mux__DOT__i0__DOT__lut_out));
        bufp->chgBit(oldp+699,(vlSelf->alu__DOT__bool_module__DOT__bool__BRA__9__KET____DOT__mux__DOT__i0__DOT__hit));
        bufp->chgIData(oldp+700,(vlSelf->alu__DOT__shift_module__DOT__Q),32);
        bufp->chgIData(oldp+701,(vlSelf->alu__DOT__shift_module__DOT__R),32);
        bufp->chgIData(oldp+702,(vlSelf->alu__DOT__shift_module__DOT__S),32);
        bufp->chgIData(oldp+703,(vlSelf->alu__DOT__shift_module__DOT__T),32);
        bufp->chgIData(oldp+704,(vlSelf->alu__DOT__shift_module__DOT__Q1),32);
        bufp->chgIData(oldp+705,(vlSelf->alu__DOT__shift_module__DOT__R1),32);
        bufp->chgIData(oldp+706,(vlSelf->alu__DOT__shift_module__DOT__S1),32);
        bufp->chgIData(oldp+707,(vlSelf->alu__DOT__shift_module__DOT__T1),32);
        bufp->chgIData(oldp+708,(vlSelf->alu__DOT__shift_module__DOT__Q2),32);
        bufp->chgIData(oldp+709,(vlSelf->alu__DOT__shift_module__DOT__R2),32);
        bufp->chgIData(oldp+710,(vlSelf->alu__DOT__shift_module__DOT__S2),32);
        bufp->chgIData(oldp+711,(vlSelf->alu__DOT__shift_module__DOT__T2),32);
    }
    bufp->chgIData(oldp+712,(vlSelf->x),32);
    bufp->chgIData(oldp+713,(vlSelf->y),32);
    bufp->chgCData(oldp+714,(vlSelf->fn),4);
    bufp->chgIData(oldp+715,(vlSelf->out),32);
    bufp->chgBit(oldp+716,(vlSelf->zero));
    bufp->chgIData(oldp+717,((((0U == (3U & (IData)(vlSelf->fn)))
                                ? ((1U & vlSelf->y)
                                    ? (vlSelf->alu__DOT__shift_module__DOT__T 
                                       << 1U) : vlSelf->alu__DOT__shift_module__DOT__T)
                                : 0U) | (((1U == (3U 
                                                  & (IData)(vlSelf->fn)))
                                           ? ((1U & vlSelf->y)
                                               ? (vlSelf->alu__DOT__shift_module__DOT__T1 
                                                  >> 1U)
                                               : vlSelf->alu__DOT__shift_module__DOT__T1)
                                           : 0U) | 
                                         ((3U == (3U 
                                                  & (IData)(vlSelf->fn)))
                                           ? ((1U & vlSelf->y)
                                               ? ((0x80000000U 
                                                   & vlSelf->x) 
                                                  | (vlSelf->alu__DOT__shift_module__DOT__T2 
                                                     >> 1U))
                                               : vlSelf->alu__DOT__shift_module__DOT__T2)
                                           : 0U)))),32);
    bufp->chgIData(oldp+718,(((1U == (3U & ((IData)(vlSelf->fn) 
                                            >> 2U)))
                               ? (0U == vlSelf->alu__DOT__S)
                               : ((3U == (3U & ((IData)(vlSelf->fn) 
                                                >> 2U)))
                                   ? ((IData)(vlSelf->zero) 
                                      | (0U == vlSelf->alu__DOT__S))
                                   : (IData)(vlSelf->zero)))),32);
    bufp->chgBit(oldp+719,((((vlSelf->x >> 0x1fU) == (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_4__y)) 
                            & ((vlSelf->x >> 0x1fU) 
                               != (IData)(vlSelf->zero)))));
    bufp->chgBit(oldp+720,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_4__gn) 
                             ^ (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_3__gn) 
                                 & (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_4__pn)) 
                                ^ (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____VdfgTmp_hf4f18bc7__0) 
                                    & (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellout__adder4_2__gn)) 
                                   ^ ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____VdfgTmp_hf4f18bc7__0) 
                                      & (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____VdfgTmp_h5bf9af88__0))))) 
                            | (((IData)(vlSelf->alu__DOT__arith_module__DOT____Vcellout__adder16_1__pm) 
                                & (IData)(vlSelf->alu__DOT__arith_module__DOT____Vcellout__adder16_2__pm)) 
                               | (((IData)(vlSelf->alu__DOT__arith_module__DOT____Vcellout__adder16_1__pm) 
                                   & (IData)(vlSelf->alu__DOT__arith_module__DOT____Vcellout__adder16_2__pm)) 
                                  & ((IData)(vlSelf->fn) 
                                     >> 1U))))));
    bufp->chgIData(oldp+721,(((3U == (3U & ((IData)(vlSelf->fn) 
                                            >> 2U)))
                               ? (((0U == (3U & (IData)(vlSelf->fn)))
                                    ? ((1U & vlSelf->y)
                                        ? (vlSelf->alu__DOT__shift_module__DOT__T 
                                           << 1U) : vlSelf->alu__DOT__shift_module__DOT__T)
                                    : 0U) | (((1U == 
                                               (3U 
                                                & (IData)(vlSelf->fn)))
                                               ? ((1U 
                                                   & vlSelf->y)
                                                   ? 
                                                  (vlSelf->alu__DOT__shift_module__DOT__T1 
                                                   >> 1U)
                                                   : vlSelf->alu__DOT__shift_module__DOT__T1)
                                               : 0U) 
                                             | ((3U 
                                                 == 
                                                 (3U 
                                                  & (IData)(vlSelf->fn)))
                                                 ? 
                                                ((1U 
                                                  & vlSelf->y)
                                                  ? 
                                                 ((0x80000000U 
                                                   & vlSelf->x) 
                                                  | (vlSelf->alu__DOT__shift_module__DOT__T2 
                                                     >> 1U))
                                                  : vlSelf->alu__DOT__shift_module__DOT__T2)
                                                 : 0U)))
                               : 0U)),32);
    bufp->chgIData(oldp+722,(((2U == (3U & ((IData)(vlSelf->fn) 
                                            >> 2U)))
                               ? ((1U == (3U & ((IData)(vlSelf->fn) 
                                                >> 2U)))
                                   ? (0U == vlSelf->alu__DOT__S)
                                   : ((3U == (3U & 
                                              ((IData)(vlSelf->fn) 
                                               >> 2U)))
                                       ? ((IData)(vlSelf->zero) 
                                          | (0U == vlSelf->alu__DOT__S))
                                       : (IData)(vlSelf->zero)))
                               : 0U)),32);
    bufp->chgIData(oldp+723,(((0U == (3U & ((IData)(vlSelf->fn) 
                                            >> 2U)))
                               ? vlSelf->alu__DOT__S
                               : 0U)),32);
    bufp->chgIData(oldp+724,(((1U == (3U & ((IData)(vlSelf->fn) 
                                            >> 2U)))
                               ? (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__31__KET____DOT__mux____pinNumber1) 
                                   << 0x1fU) | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__30__KET____DOT__mux____pinNumber1) 
                                                 << 0x1eU) 
                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__29__KET____DOT__mux____pinNumber1) 
                                                    << 0x1dU) 
                                                   | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__28__KET____DOT__mux____pinNumber1) 
                                                       << 0x1cU) 
                                                      | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__27__KET____DOT__mux____pinNumber1) 
                                                          << 0x1bU) 
                                                         | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__26__KET____DOT__mux____pinNumber1) 
                                                             << 0x1aU) 
                                                            | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__25__KET____DOT__mux____pinNumber1) 
                                                                << 0x19U) 
                                                               | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__24__KET____DOT__mux____pinNumber1) 
                                                                   << 0x18U) 
                                                                  | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__23__KET____DOT__mux____pinNumber1) 
                                                                      << 0x17U) 
                                                                     | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__22__KET____DOT__mux____pinNumber1) 
                                                                         << 0x16U) 
                                                                        | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__21__KET____DOT__mux____pinNumber1) 
                                                                            << 0x15U) 
                                                                           | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__20__KET____DOT__mux____pinNumber1) 
                                                                               << 0x14U) 
                                                                              | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__19__KET____DOT__mux____pinNumber1) 
                                                                                << 0x13U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__18__KET____DOT__mux____pinNumber1) 
                                                                                << 0x12U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__17__KET____DOT__mux____pinNumber1) 
                                                                                << 0x11U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__16__KET____DOT__mux____pinNumber1) 
                                                                                << 0x10U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__15__KET____DOT__mux____pinNumber1) 
                                                                                << 0xfU) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__14__KET____DOT__mux____pinNumber1) 
                                                                                << 0xeU) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__13__KET____DOT__mux____pinNumber1) 
                                                                                << 0xdU) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__12__KET____DOT__mux____pinNumber1) 
                                                                                << 0xcU) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__11__KET____DOT__mux____pinNumber1) 
                                                                                << 0xbU) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__10__KET____DOT__mux____pinNumber1) 
                                                                                << 0xaU) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__9__KET____DOT__mux____pinNumber1) 
                                                                                << 9U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__8__KET____DOT__mux____pinNumber1) 
                                                                                << 8U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__7__KET____DOT__mux____pinNumber1) 
                                                                                << 7U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__6__KET____DOT__mux____pinNumber1) 
                                                                                << 6U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__5__KET____DOT__mux____pinNumber1) 
                                                                                << 5U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__4__KET____DOT__mux____pinNumber1) 
                                                                                << 4U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__3__KET____DOT__mux____pinNumber1) 
                                                                                << 3U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__2__KET____DOT__mux____pinNumber1) 
                                                                                << 2U) 
                                                                                | (((IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__1__KET____DOT__mux____pinNumber1) 
                                                                                << 1U) 
                                                                                | (IData)(vlSelf->alu__DOT__bool_module__DOT____Vcellout__bool__BRA__0__KET____DOT__mux____pinNumber1))))))))))))))))))))))))))))))))
                               : 0U)),32);
    bufp->chgBit(oldp+725,((1U & ((IData)(vlSelf->fn) 
                                  >> 1U))));
    bufp->chgSData(oldp+726,((0xffffU & vlSelf->x)),16);
    bufp->chgSData(oldp+727,((((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__adder_4__DOT__t) 
                                 ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_4__c)) 
                                << 0xfU) | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                              ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_3__c)) 
                                             << 0xeU) 
                                            | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                 ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_2__c)) 
                                                << 0xdU) 
                                               | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__adder_1__DOT__t) 
                                                   ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_4__cin)) 
                                                  << 0xcU)))) 
                              | (((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__adder_4__DOT__t) 
                                    ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_4__c)) 
                                   << 0xbU) | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                                 ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_3__c)) 
                                                << 0xaU) 
                                               | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                    ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_2__c)) 
                                                   << 9U) 
                                                  | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__adder_1__DOT__t) 
                                                      ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_3__cin)) 
                                                     << 8U)))) 
                                 | (((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__adder_4__DOT__t) 
                                       ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_4__c)) 
                                      << 7U) | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                                  ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_3__c)) 
                                                 << 6U) 
                                                | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                     ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_2__c)) 
                                                    << 5U) 
                                                   | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__adder_1__DOT__t) 
                                                       ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_2__cin)) 
                                                      << 4U)))) 
                                    | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__adder_4__DOT__t) 
                                         ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_4__c)) 
                                        << 3U) | ((
                                                   ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                                    ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_3__c)) 
                                                   << 2U) 
                                                  | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                       ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_2__c)) 
                                                      << 1U) 
                                                     | (1U 
                                                        & ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__adder_1__DOT__t) 
                                                           ^ 
                                                           ((IData)(vlSelf->fn) 
                                                            >> 1U)))))))))),16);
    bufp->chgCData(oldp+728,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_4__cin) 
                               << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_3__cin) 
                                          << 2U) | 
                                         (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT____Vcellinp__adder4_2__cin) 
                                           << 1U) | 
                                          (1U & ((IData)(vlSelf->fn) 
                                                 >> 1U)))))),4);
    bufp->chgCData(oldp+729,((0xfU & vlSelf->x)),4);
    bufp->chgCData(oldp+730,(((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__adder_4__DOT__t) 
                                ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_4__c)) 
                               << 3U) | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                           ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_3__c)) 
                                          << 2U) | 
                                         ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                            ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_2__c)) 
                                           << 1U) | 
                                          (1U & ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__adder_1__DOT__t) 
                                                 ^ 
                                                 ((IData)(vlSelf->fn) 
                                                  >> 1U))))))),4);
    bufp->chgCData(oldp+731,(((0xfffffff8U & (vlSelf->x 
                                              & ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_4__y) 
                                                 << 3U))) 
                              | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____VdfgTmp_hee7d100a__0) 
                                  << 2U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_haf936f7f__0) 
                                             << 1U) 
                                            | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_haf9f3eea__0))))),4);
    bufp->chgCData(oldp+732,((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_4__c) 
                               << 3U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_3__c) 
                                          << 2U) | 
                                         (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT____Vcellinp__adder_2__c) 
                                           << 1U) | 
                                          (1U & ((IData)(vlSelf->fn) 
                                                 >> 1U)))))),4);
    bufp->chgBit(oldp+733,((1U & vlSelf->x)));
    bufp->chgBit(oldp+734,((1U & ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_1__DOT__adder_1__DOT__t) 
                                  ^ ((IData)(vlSelf->fn) 
                                     >> 1U)))));
    bufp->chgBit(oldp+735,((1U & (vlSelf->x >> 1U))));
    bufp->chgBit(oldp+736,((1U & (vlSelf->x >> 2U))));
    bufp->chgBit(oldp+737,((1U & (vlSelf->x >> 3U))));
    bufp->chgCData(oldp+738,((0xfU & (vlSelf->x >> 4U))),4);
    bufp->chgCData(oldp+739,(((0xffffff8U & ((vlSelf->x 
                                              >> 4U) 
                                             & ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____Vcellinp__adder_4__y) 
                                                << 3U))) 
                              | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT____VdfgTmp_hee7d100a__0) 
                                  << 2U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_haf936f7f__0) 
                                             << 1U) 
                                            | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_haf9f3eea__0))))),4);
    bufp->chgBit(oldp+740,((1U & (vlSelf->x >> 4U))));
    bufp->chgBit(oldp+741,((1U & (vlSelf->x >> 5U))));
    bufp->chgBit(oldp+742,((1U & (vlSelf->x >> 6U))));
    bufp->chgBit(oldp+743,((1U & (vlSelf->x >> 7U))));
    bufp->chgCData(oldp+744,((0xfU & (vlSelf->x >> 8U))),4);
    bufp->chgCData(oldp+745,(((0xfffff8U & ((vlSelf->x 
                                             >> 8U) 
                                            & ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____Vcellinp__adder_4__y) 
                                               << 3U))) 
                              | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT____VdfgTmp_hee7d100a__0) 
                                  << 2U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_haf936f7f__0) 
                                             << 1U) 
                                            | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_haf9f3eea__0))))),4);
    bufp->chgBit(oldp+746,((1U & (vlSelf->x >> 8U))));
    bufp->chgBit(oldp+747,((1U & (vlSelf->x >> 9U))));
    bufp->chgBit(oldp+748,((1U & (vlSelf->x >> 0xaU))));
    bufp->chgBit(oldp+749,((1U & (vlSelf->x >> 0xbU))));
    bufp->chgCData(oldp+750,((0xfU & (vlSelf->x >> 0xcU))),4);
    bufp->chgCData(oldp+751,(((0xffff8U & ((vlSelf->x 
                                            >> 0xcU) 
                                           & ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____Vcellinp__adder_4__y) 
                                              << 3U))) 
                              | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT____VdfgTmp_hee7d100a__0) 
                                  << 2U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_haf936f7f__0) 
                                             << 1U) 
                                            | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_1__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_haf9f3eea__0))))),4);
    bufp->chgBit(oldp+752,((1U & (vlSelf->x >> 0xcU))));
    bufp->chgBit(oldp+753,((1U & (vlSelf->x >> 0xdU))));
    bufp->chgBit(oldp+754,((1U & (vlSelf->x >> 0xeU))));
    bufp->chgBit(oldp+755,((1U & (vlSelf->x >> 0xfU))));
    bufp->chgSData(oldp+756,((vlSelf->x >> 0x10U)),16);
    bufp->chgSData(oldp+757,(((((IData)(vlSelf->zero) 
                                << 0xfU) | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                              ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_3__c)) 
                                             << 0xeU) 
                                            | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                 ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_2__c)) 
                                                << 0xdU) 
                                               | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__adder_1__DOT__t) 
                                                   ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_4__cin)) 
                                                  << 0xcU)))) 
                              | (((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__adder_4__DOT__t) 
                                    ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_4__c)) 
                                   << 0xbU) | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                                 ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_3__c)) 
                                                << 0xaU) 
                                               | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                    ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_2__c)) 
                                                   << 9U) 
                                                  | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__adder_1__DOT__t) 
                                                      ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_3__cin)) 
                                                     << 8U)))) 
                                 | (((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__adder_4__DOT__t) 
                                       ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_4__c)) 
                                      << 7U) | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                                  ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_3__c)) 
                                                 << 6U) 
                                                | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                     ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_2__c)) 
                                                    << 5U) 
                                                   | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__adder_1__DOT__t) 
                                                       ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_2__cin)) 
                                                      << 4U)))) 
                                    | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__adder_4__DOT__t) 
                                         ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_4__c)) 
                                        << 3U) | ((
                                                   ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                                    ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_3__c)) 
                                                   << 2U) 
                                                  | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                                       ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_2__c)) 
                                                      << 1U) 
                                                     | ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__adder_1__DOT__t) 
                                                        ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__c_16))))))))),16);
    bufp->chgCData(oldp+758,((0xfU & (vlSelf->x >> 0x10U))),4);
    bufp->chgCData(oldp+759,(((0xfff8U & ((vlSelf->x 
                                           >> 0x10U) 
                                          & ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____Vcellinp__adder_4__y) 
                                             << 3U))) 
                              | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT____VdfgTmp_hee7d100a__0) 
                                  << 2U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_haf936f7f__0) 
                                             << 1U) 
                                            | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_1__DOT__carry_in__DOT____VdfgTmp_haf9f3eea__0))))),4);
    bufp->chgBit(oldp+760,((1U & (vlSelf->x >> 0x10U))));
    bufp->chgBit(oldp+761,((1U & (vlSelf->x >> 0x11U))));
    bufp->chgBit(oldp+762,((1U & (vlSelf->x >> 0x12U))));
    bufp->chgBit(oldp+763,((1U & (vlSelf->x >> 0x13U))));
    bufp->chgCData(oldp+764,((0xfU & (vlSelf->x >> 0x14U))),4);
    bufp->chgCData(oldp+765,(((0xff8U & ((vlSelf->x 
                                          >> 0x14U) 
                                         & ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____Vcellinp__adder_4__y) 
                                            << 3U))) 
                              | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT____VdfgTmp_hee7d100a__0) 
                                  << 2U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_haf936f7f__0) 
                                             << 1U) 
                                            | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_2__DOT__carry_in__DOT____VdfgTmp_haf9f3eea__0))))),4);
    bufp->chgBit(oldp+766,((1U & (vlSelf->x >> 0x14U))));
    bufp->chgBit(oldp+767,((1U & (vlSelf->x >> 0x15U))));
    bufp->chgBit(oldp+768,((1U & (vlSelf->x >> 0x16U))));
    bufp->chgBit(oldp+769,((1U & (vlSelf->x >> 0x17U))));
    bufp->chgCData(oldp+770,((0xfU & (vlSelf->x >> 0x18U))),4);
    bufp->chgCData(oldp+771,(((0xf8U & ((vlSelf->x 
                                         >> 0x18U) 
                                        & ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____Vcellinp__adder_4__y) 
                                           << 3U))) 
                              | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT____VdfgTmp_hee7d100a__0) 
                                  << 2U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_haf936f7f__0) 
                                             << 1U) 
                                            | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_3__DOT__carry_in__DOT____VdfgTmp_haf9f3eea__0))))),4);
    bufp->chgBit(oldp+772,((1U & (vlSelf->x >> 0x18U))));
    bufp->chgBit(oldp+773,((1U & (vlSelf->x >> 0x19U))));
    bufp->chgBit(oldp+774,((1U & (vlSelf->x >> 0x1aU))));
    bufp->chgBit(oldp+775,((1U & (vlSelf->x >> 0x1bU))));
    bufp->chgCData(oldp+776,((vlSelf->x >> 0x1cU)),4);
    bufp->chgCData(oldp+777,((((IData)(vlSelf->zero) 
                               << 3U) | ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3bc9dda8__0) 
                                           ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_3__c)) 
                                          << 2U) | 
                                         ((((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_h3b0bad67__0) 
                                            ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_2__c)) 
                                           << 1U) | 
                                          ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__adder_1__DOT__t) 
                                           ^ (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT____Vcellinp__adder4_4__cin)))))),4);
    bufp->chgCData(oldp+778,(((8U & ((vlSelf->x >> 0x1cU) 
                                     & ((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____Vcellinp__adder_4__y) 
                                        << 3U))) | 
                              (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT____VdfgTmp_hee7d100a__0) 
                                << 2U) | (((IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_haf936f7f__0) 
                                           << 1U) | (IData)(vlSelf->alu__DOT__arith_module__DOT__adder16_2__DOT__adder4_4__DOT__carry_in__DOT____VdfgTmp_haf9f3eea__0))))),4);
    bufp->chgBit(oldp+779,((1U & (vlSelf->x >> 0x1cU))));
    bufp->chgBit(oldp+780,((1U & (vlSelf->x >> 0x1dU))));
    bufp->chgBit(oldp+781,((1U & (vlSelf->x >> 0x1eU))));
    bufp->chgBit(oldp+782,((vlSelf->x >> 0x1fU)));
    bufp->chgCData(oldp+783,(((4U == (IData)(vlSelf->fn))
                               ? 8U : ((5U == (IData)(vlSelf->fn))
                                        ? 0xeU : ((6U 
                                                   == (IData)(vlSelf->fn))
                                                   ? 6U
                                                   : 1U)))),4);
    bufp->chgCData(oldp+784,((3U & ((IData)(vlSelf->fn) 
                                    >> 2U))),2);
    bufp->chgBit(oldp+785,(((1U == (3U & ((IData)(vlSelf->fn) 
                                          >> 2U))) ? 
                            (0U == vlSelf->alu__DOT__S)
                             : ((3U == (3U & ((IData)(vlSelf->fn) 
                                              >> 2U)))
                                 ? ((IData)(vlSelf->zero) 
                                    | (0U == vlSelf->alu__DOT__S))
                                 : (IData)(vlSelf->zero)))));
    bufp->chgCData(oldp+786,((0x1fU & vlSelf->y)),5);
    bufp->chgCData(oldp+787,((3U & (IData)(vlSelf->fn))),2);
    bufp->chgIData(oldp+788,(((1U & vlSelf->y) ? (vlSelf->alu__DOT__shift_module__DOT__T 
                                                  << 1U)
                               : vlSelf->alu__DOT__shift_module__DOT__T)),32);
    bufp->chgIData(oldp+789,(((1U & vlSelf->y) ? (vlSelf->alu__DOT__shift_module__DOT__T1 
                                                  >> 1U)
                               : vlSelf->alu__DOT__shift_module__DOT__T1)),32);
    bufp->chgIData(oldp+790,(((1U & vlSelf->y) ? ((0x80000000U 
                                                   & vlSelf->x) 
                                                  | (vlSelf->alu__DOT__shift_module__DOT__T2 
                                                     >> 1U))
                               : vlSelf->alu__DOT__shift_module__DOT__T2)),32);
    bufp->chgIData(oldp+791,(((0U == (3U & (IData)(vlSelf->fn)))
                               ? ((1U & vlSelf->y) ? 
                                  (vlSelf->alu__DOT__shift_module__DOT__T 
                                   << 1U) : vlSelf->alu__DOT__shift_module__DOT__T)
                               : 0U)),32);
    bufp->chgIData(oldp+792,(((1U == (3U & (IData)(vlSelf->fn)))
                               ? ((1U & vlSelf->y) ? 
                                  (vlSelf->alu__DOT__shift_module__DOT__T1 
                                   >> 1U) : vlSelf->alu__DOT__shift_module__DOT__T1)
                               : 0U)),32);
    bufp->chgIData(oldp+793,(((3U == (3U & (IData)(vlSelf->fn)))
                               ? ((1U & vlSelf->y) ? 
                                  ((0x80000000U & vlSelf->x) 
                                   | (vlSelf->alu__DOT__shift_module__DOT__T2 
                                      >> 1U)) : vlSelf->alu__DOT__shift_module__DOT__T2)
                               : 0U)),32);
}

void Valu___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Valu___024root__trace_cleanup\n"); );
    // Init
    Valu___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Valu___024root*>(voidSelf);
    Valu__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
}
