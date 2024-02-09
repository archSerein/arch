// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VFSM__SYMS_H_
#define VERILATED_VFSM__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vfsm.h"

// INCLUDE MODULE CLASSES
#include "Vfsm___024root.h"

// SYMS CLASS (contains all model state)
class Vfsm__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vfsm* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vfsm___024root                 TOP;

    // CONSTRUCTORS
    Vfsm__Syms(VerilatedContext* contextp, const char* namep, Vfsm* modelp);
    ~Vfsm__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

#endif  // guard
