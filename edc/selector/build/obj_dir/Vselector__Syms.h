// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VSELECTOR__SYMS_H_
#define VERILATED_VSELECTOR__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vselector.h"

// INCLUDE MODULE CLASSES
#include "Vselector___024root.h"

// SYMS CLASS (contains all model state)
class Vselector__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vselector* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vselector___024root            TOP;

    // CONSTRUCTORS
    Vselector__Syms(VerilatedContext* contextp, const char* namep, Vselector* modelp);
    ~Vselector__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

#endif  // guard
