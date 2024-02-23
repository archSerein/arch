// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary model header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef VERILATED_VTOP_H_
#define VERILATED_VTOP_H_  // guard

#include "verilated.h"

class Vtop__Syms;
class Vtop___024root;

// This class is the main interface to the Verilated model
class Vtop VL_NOT_FINAL : public VerilatedModel {
  private:
    // Symbol table holding complete model state (owned by this class)
    Vtop__Syms* const vlSymsp;

  public:

    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    VL_IN8(&clk,0,0);
    VL_IN8(&rst,0,0);
    VL_IN8(&aluc,3,0);
    VL_IN8(&byteena_a,3,0);
    VL_IN8(&wren,0,0);
    VL_IN8(&ra,4,0);
    VL_IN8(&rb,4,0);
    VL_IN8(&rw,4,0);
    VL_IN8(&regwr,0,0);
    VL_OUT8(&zero,0,0);
    VL_OUT8(&less,0,0);
    VL_OUT8(&seg0,6,0);
    VL_OUT8(&seg1,6,0);
    VL_OUT8(&seg2,6,0);
    VL_OUT8(&seg3,6,0);
    VL_OUT8(&seg4,6,0);
    VL_OUT8(&seg5,6,0);
    VL_OUT8(&seg6,6,0);
    VL_OUT8(&seg7,6,0);
    VL_IN16(&rdaddress,14,0);
    VL_IN16(&wraddress,14,0);
    VL_IN(&a,31,0);
    VL_IN(&b,31,0);
    VL_IN(&data,31,0);
    VL_IN(&busw,31,0);
    VL_OUT(&busa,31,0);
    VL_OUT(&busb,31,0);
    VL_OUT(&out,31,0);
    VL_OUT(&q,31,0);

    // CELLS
    // Public to allow access to /* verilator public */ items.
    // Otherwise the application code can consider these internals.

    // Root instance pointer to allow access to model internals,
    // including inlined /* verilator public_flat_* */ items.
    Vtop___024root* const rootp;

    // CONSTRUCTORS
    /// Construct the model; called by application code
    /// If contextp is null, then the model will use the default global context
    /// If name is "", then makes a wrapper with a
    /// single model invisible with respect to DPI scope names.
    explicit Vtop(VerilatedContext* contextp, const char* name = "TOP");
    explicit Vtop(const char* name = "TOP");
    /// Destroy the model; called (often implicitly) by application code
    virtual ~Vtop();
  private:
    VL_UNCOPYABLE(Vtop);  ///< Copying not allowed

  public:
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval() { eval_step(); }
    /// Evaluate when calling multiple units/models per time step.
    void eval_step();
    /// Evaluate at end of a timestep for tracing, when using eval_step().
    /// Application must call after all eval() and before time changes.
    void eval_end_step() {}
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    /// Are there scheduled events to handle?
    bool eventsPending();
    /// Returns time at next time slot. Aborts if !eventsPending()
    uint64_t nextTimeSlot();
    /// Retrieve name of this model instance (as passed to constructor).
    const char* name() const;

    // Abstract methods from VerilatedModel
    const char* hierName() const override final;
    const char* modelName() const override final;
    unsigned threads() const override final;
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

#endif  // guard
