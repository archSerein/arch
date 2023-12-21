// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vencode.h for the primary calling header

#include "verilated.h"

#include "Vencode__Syms.h"
#include "Vencode___024root.h"

void Vencode___024root___ctor_var_reset(Vencode___024root* vlSelf);

Vencode___024root::Vencode___024root(Vencode__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vencode___024root___ctor_var_reset(this);
}

void Vencode___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vencode___024root::~Vencode___024root() {
}
