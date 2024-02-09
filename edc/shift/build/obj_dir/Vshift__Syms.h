// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VSHIFT__SYMS_H_
#define VERILATED_VSHIFT__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vshift.h"

// INCLUDE MODULE CLASSES
#include "Vshift___024root.h"

// SYMS CLASS (contains all model state)
class Vshift__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vshift* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vshift___024root               TOP;

    // CONSTRUCTORS
    Vshift__Syms(VerilatedContext* contextp, const char* namep, Vshift* modelp);
    ~Vshift__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

#endif  // guard
