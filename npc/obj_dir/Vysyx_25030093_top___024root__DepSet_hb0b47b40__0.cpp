// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vysyx_25030093_top.h for the primary calling header

#include "verilated.h"
#include "verilated_dpi.h"

#include "Vysyx_25030093_top__Syms.h"
#include "Vysyx_25030093_top___024root.h"

extern "C" void npc_ebreak();

VL_INLINE_OPT void Vysyx_25030093_top___024root____Vdpiimwrap_ysyx_25030093_top__DOT__u_ysyx_25030093_IDU__DOT__npc_ebreak_TOP() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_25030093_top___024root____Vdpiimwrap_ysyx_25030093_top__DOT__u_ysyx_25030093_IDU__DOT__npc_ebreak_TOP\n"); );
    // Body
    npc_ebreak();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vysyx_25030093_top___024root___dump_triggers__ico(Vysyx_25030093_top___024root* vlSelf);
#endif  // VL_DEBUG

void Vysyx_25030093_top___024root___eval_triggers__ico(Vysyx_25030093_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vysyx_25030093_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_25030093_top___024root___eval_triggers__ico\n"); );
    // Body
    vlSelf->__VicoTriggered.at(0U) = (0U == vlSelf->__VicoIterCount);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vysyx_25030093_top___024root___dump_triggers__ico(vlSelf);
    }
#endif
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vysyx_25030093_top___024root___dump_triggers__act(Vysyx_25030093_top___024root* vlSelf);
#endif  // VL_DEBUG

void Vysyx_25030093_top___024root___eval_triggers__act(Vysyx_25030093_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vysyx_25030093_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_25030093_top___024root___eval_triggers__act\n"); );
    // Body
    vlSelf->__VactTriggered.at(0U) = ((IData)(vlSelf->clk) 
                                      & (~ (IData)(vlSelf->__Vtrigrprev__TOP__clk)));
    vlSelf->__VactTriggered.at(1U) = (vlSelf->inst 
                                      != vlSelf->__Vtrigrprev__TOP__inst);
    vlSelf->__Vtrigrprev__TOP__clk = vlSelf->clk;
    vlSelf->__Vtrigrprev__TOP__inst = vlSelf->inst;
    if (VL_UNLIKELY((1U & (~ (IData)(vlSelf->__VactDidInit))))) {
        vlSelf->__VactDidInit = 1U;
        vlSelf->__VactTriggered.at(1U) = 1U;
    }
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vysyx_25030093_top___024root___dump_triggers__act(vlSelf);
    }
#endif
}
