// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VRAM1__SYMS_H_
#define VERILATED_VRAM1__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vram1.h"

// INCLUDE MODULE CLASSES
#include "Vram1___024root.h"

// SYMS CLASS (contains all model state)
class Vram1__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vram1* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vram1___024root                TOP;

    // CONSTRUCTORS
    Vram1__Syms(VerilatedContext* contextp, const char* namep, Vram1* modelp);
    ~Vram1__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

#endif  // guard
