// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vram1.h for the primary calling header

#include "verilated.h"

#include "Vram1__Syms.h"
#include "Vram1___024root.h"

void Vram1___024root___ctor_var_reset(Vram1___024root* vlSelf);

Vram1___024root::Vram1___024root(Vram1__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vram1___024root___ctor_var_reset(this);
}

void Vram1___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vram1___024root::~Vram1___024root() {
}
