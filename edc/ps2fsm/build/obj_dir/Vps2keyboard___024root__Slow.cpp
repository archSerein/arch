// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vps2keyboard.h for the primary calling header

#include "verilated.h"

#include "Vps2keyboard__Syms.h"
#include "Vps2keyboard___024root.h"

void Vps2keyboard___024root___ctor_var_reset(Vps2keyboard___024root* vlSelf);

Vps2keyboard___024root::Vps2keyboard___024root(Vps2keyboard__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vps2keyboard___024root___ctor_var_reset(this);
}

void Vps2keyboard___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vps2keyboard___024root::~Vps2keyboard___024root() {
}
