// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vysyx_25030093_top.h for the primary calling header

#include "verilated.h"
#include "verilated_dpi.h"

#include "Vysyx_25030093_top___024root.h"

VL_INLINE_OPT void Vysyx_25030093_top___024root___ico_sequent__TOP__0(Vysyx_25030093_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vysyx_25030093_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_25030093_top___024root___ico_sequent__TOP__0\n"); );
    // Body
    vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__rs1_data_reg 
        = ((0U == (0x1fU & (vlSelf->inst >> 0xfU)))
            ? 0U : vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf
           [(0x1fU & (vlSelf->inst >> 0xfU))]);
    vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__rd_data 
        = ((((- (IData)((vlSelf->inst >> 0x1fU))) << 0xbU) 
            | (0x7ffU & (vlSelf->inst >> 0x14U))) + vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__rs1_data_reg);
}

void Vysyx_25030093_top___024root___eval_ico(Vysyx_25030093_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vysyx_25030093_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_25030093_top___024root___eval_ico\n"); );
    // Body
    if (vlSelf->__VicoTriggered.at(0U)) {
        Vysyx_25030093_top___024root___ico_sequent__TOP__0(vlSelf);
    }
}

void Vysyx_25030093_top___024root___eval_act(Vysyx_25030093_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vysyx_25030093_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_25030093_top___024root___eval_act\n"); );
}

void Vysyx_25030093_top___024root____Vdpiimwrap_ysyx_25030093_top__DOT__u_ysyx_25030093_IDU__DOT__npc_ebreak_TOP();

VL_INLINE_OPT void Vysyx_25030093_top___024root___nba_sequent__TOP__0(Vysyx_25030093_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vysyx_25030093_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_25030093_top___024root___nba_sequent__TOP__0\n"); );
    // Body
    if ((IData)((0x100073U == (0xfff0007fU & vlSelf->inst)))) {
        Vysyx_25030093_top___024root____Vdpiimwrap_ysyx_25030093_top__DOT__u_ysyx_25030093_IDU__DOT__npc_ebreak_TOP();
    }
}

VL_INLINE_OPT void Vysyx_25030093_top___024root___nba_sequent__TOP__1(Vysyx_25030093_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vysyx_25030093_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_25030093_top___024root___nba_sequent__TOP__1\n"); );
    // Init
    CData/*4:0*/ __Vdlyvdim0__ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf__v0;
    __Vdlyvdim0__ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf__v0 = 0;
    IData/*31:0*/ __Vdlyvval__ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf__v0;
    __Vdlyvval__ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf__v0 = 0;
    CData/*0:0*/ __Vdlyvset__ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf__v0;
    __Vdlyvset__ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf__v0 = 0;
    // Body
    __Vdlyvset__ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf__v0 = 0U;
    vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_IFU__DOT__pc 
        = ((IData)(vlSelf->rst) ? 0x80000000U : ((IData)(4U) 
                                                 + vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_IFU__DOT__pc));
    if ((0U != (0x1fU & (vlSelf->inst >> 7U)))) {
        __Vdlyvval__ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf__v0 
            = vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__rd_data;
        __Vdlyvset__ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf__v0 = 1U;
        __Vdlyvdim0__ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf__v0 
            = (0x1fU & (vlSelf->inst >> 7U));
    }
    if (__Vdlyvset__ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf__v0) {
        vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[__Vdlyvdim0__ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf__v0] 
            = __Vdlyvval__ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf__v0;
    }
    vlSelf->io_pc = vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_IFU__DOT__pc;
    vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__rs1_data_reg 
        = ((0U == (0x1fU & (vlSelf->inst >> 0xfU)))
            ? 0U : vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf
           [(0x1fU & (vlSelf->inst >> 0xfU))]);
    vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__rd_data 
        = ((((- (IData)((vlSelf->inst >> 0x1fU))) << 0xbU) 
            | (0x7ffU & (vlSelf->inst >> 0x14U))) + vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__rs1_data_reg);
}

void Vysyx_25030093_top___024root___eval_nba(Vysyx_25030093_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vysyx_25030093_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_25030093_top___024root___eval_nba\n"); );
    // Body
    if (vlSelf->__VnbaTriggered.at(1U)) {
        Vysyx_25030093_top___024root___nba_sequent__TOP__0(vlSelf);
    }
    if (vlSelf->__VnbaTriggered.at(0U)) {
        Vysyx_25030093_top___024root___nba_sequent__TOP__1(vlSelf);
        vlSelf->__Vm_traceActivity[1U] = 1U;
    }
}

void Vysyx_25030093_top___024root___eval_triggers__ico(Vysyx_25030093_top___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vysyx_25030093_top___024root___dump_triggers__ico(Vysyx_25030093_top___024root* vlSelf);
#endif  // VL_DEBUG
void Vysyx_25030093_top___024root___eval_triggers__act(Vysyx_25030093_top___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vysyx_25030093_top___024root___dump_triggers__act(Vysyx_25030093_top___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vysyx_25030093_top___024root___dump_triggers__nba(Vysyx_25030093_top___024root* vlSelf);
#endif  // VL_DEBUG

void Vysyx_25030093_top___024root___eval(Vysyx_25030093_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vysyx_25030093_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_25030093_top___024root___eval\n"); );
    // Init
    CData/*0:0*/ __VicoContinue;
    VlTriggerVec<2> __VpreTriggered;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    vlSelf->__VicoIterCount = 0U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        __VicoContinue = 0U;
        Vysyx_25030093_top___024root___eval_triggers__ico(vlSelf);
        if (vlSelf->__VicoTriggered.any()) {
            __VicoContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VicoIterCount))) {
#ifdef VL_DEBUG
                Vysyx_25030093_top___024root___dump_triggers__ico(vlSelf);
#endif
                VL_FATAL_MT("vsrc/ysyx_25030093_top.v", 1, "", "Input combinational region did not converge.");
            }
            vlSelf->__VicoIterCount = ((IData)(1U) 
                                       + vlSelf->__VicoIterCount);
            Vysyx_25030093_top___024root___eval_ico(vlSelf);
        }
    }
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        __VnbaContinue = 0U;
        vlSelf->__VnbaTriggered.clear();
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            vlSelf->__VactContinue = 0U;
            Vysyx_25030093_top___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vysyx_25030093_top___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("vsrc/ysyx_25030093_top.v", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.set(vlSelf->__VactTriggered);
                Vysyx_25030093_top___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vysyx_25030093_top___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("vsrc/ysyx_25030093_top.v", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vysyx_25030093_top___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vysyx_25030093_top___024root___eval_debug_assertions(Vysyx_25030093_top___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vysyx_25030093_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_25030093_top___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->rst & 0xfeU))) {
        Verilated::overWidthError("rst");}
}
#endif  // VL_DEBUG
