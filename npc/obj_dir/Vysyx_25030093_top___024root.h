// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vysyx_25030093_top.h for the primary calling header

#ifndef VERILATED_VYSYX_25030093_TOP___024ROOT_H_
#define VERILATED_VYSYX_25030093_TOP___024ROOT_H_  // guard

#include "verilated.h"

class Vysyx_25030093_top__Syms;

class Vysyx_25030093_top___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(rst,0,0);
    CData/*0:0*/ __Vtrigrprev__TOP__clk;
    CData/*0:0*/ __VactDidInit;
    CData/*0:0*/ __VactContinue;
    VL_OUT(io_pc,31,0);
    VL_IN(inst,31,0);
    IData/*31:0*/ ysyx_25030093_top__DOT__u_ysyx_25030093_IFU__DOT__pc;
    IData/*31:0*/ ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__rs1_data_reg;
    IData/*31:0*/ ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__rd_data;
    IData/*31:0*/ __VstlIterCount;
    IData/*31:0*/ __VicoIterCount;
    IData/*31:0*/ __Vtrigrprev__TOP__inst;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<IData/*31:0*/, 32> ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf;
    VlUnpacked<CData/*0:0*/, 2> __Vm_traceActivity;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<2> __VactTriggered;
    VlTriggerVec<2> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vysyx_25030093_top__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vysyx_25030093_top___024root(Vysyx_25030093_top__Syms* symsp, const char* v__name);
    ~Vysyx_25030093_top___024root();
    VL_UNCOPYABLE(Vysyx_25030093_top___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
