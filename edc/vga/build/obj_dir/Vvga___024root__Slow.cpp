// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vvga.h for the primary calling header

#include "verilated.h"

#include "Vvga__Syms.h"
#include "Vvga___024root.h"

void Vvga___024root___ctor_var_reset(Vvga___024root* vlSelf);

Vvga___024root::Vvga___024root(Vvga__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vvga___024root___ctor_var_reset(this);
}

void Vvga___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vvga___024root::~Vvga___024root() {
}
