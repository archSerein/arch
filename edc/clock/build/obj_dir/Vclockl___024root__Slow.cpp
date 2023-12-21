// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vclockl.h for the primary calling header

#include "verilated.h"

#include "Vclockl__Syms.h"
#include "Vclockl___024root.h"

void Vclockl___024root___ctor_var_reset(Vclockl___024root* vlSelf);

Vclockl___024root::Vclockl___024root(Vclockl__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vclockl___024root___ctor_var_reset(this);
}

void Vclockl___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vclockl___024root::~Vclockl___024root() {
}
