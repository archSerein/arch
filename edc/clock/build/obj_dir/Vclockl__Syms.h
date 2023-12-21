// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VCLOCKL__SYMS_H_
#define VERILATED_VCLOCKL__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vclockl.h"

// INCLUDE MODULE CLASSES
#include "Vclockl___024root.h"

// SYMS CLASS (contains all model state)
class Vclockl__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vclockl* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vclockl___024root              TOP;

    // CONSTRUCTORS
    Vclockl__Syms(VerilatedContext* contextp, const char* namep, Vclockl* modelp);
    ~Vclockl__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

#endif  // guard
