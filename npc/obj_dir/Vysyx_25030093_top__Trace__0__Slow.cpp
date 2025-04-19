// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vysyx_25030093_top__Syms.h"


VL_ATTR_COLD void Vysyx_25030093_top___024root__trace_init_sub__TOP__0(Vysyx_25030093_top___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vysyx_25030093_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_25030093_top___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBit(c+34,"clk", false,-1);
    tracep->declBus(c+35,"io_pc", false,-1, 31,0);
    tracep->declBus(c+36,"inst", false,-1, 31,0);
    tracep->declBit(c+37,"rst", false,-1);
    tracep->pushNamePrefix("ysyx_25030093_top ");
    tracep->declBit(c+34,"clk", false,-1);
    tracep->declBus(c+35,"io_pc", false,-1, 31,0);
    tracep->declBus(c+36,"inst", false,-1, 31,0);
    tracep->declBit(c+37,"rst", false,-1);
    tracep->declBus(c+43,"imm_type", false,-1, 2,0);
    tracep->declBit(c+44,"Regwrite", false,-1);
    tracep->declBus(c+38,"rd", false,-1, 4,0);
    tracep->declBus(c+39,"rs1", false,-1, 4,0);
    tracep->declBus(c+40,"imm_data", false,-1, 31,0);
    tracep->pushNamePrefix("u_ysyx_25030093_EXU ");
    tracep->declBit(c+34,"clk", false,-1);
    tracep->declBus(c+40,"imm_data", false,-1, 31,0);
    tracep->declBit(c+44,"Regwrite", false,-1);
    tracep->declBus(c+38,"rd", false,-1, 4,0);
    tracep->declBus(c+39,"rs1", false,-1, 4,0);
    tracep->declBus(c+41,"rs1_data_reg", false,-1, 31,0);
    tracep->declBus(c+42,"rd_data", false,-1, 31,0);
    tracep->pushNamePrefix("u_Register ");
    tracep->declBus(c+45,"ADDR_WIDTH", false,-1, 31,0);
    tracep->declBus(c+46,"DATA_WIDTH", false,-1, 31,0);
    tracep->declBit(c+34,"clk", false,-1);
    tracep->declBus(c+42,"wdata", false,-1, 31,0);
    tracep->declBus(c+38,"waddr", false,-1, 4,0);
    tracep->declBit(c+44,"wen", false,-1);
    tracep->declBus(c+41,"rs1_data", false,-1, 31,0);
    tracep->declBus(c+39,"rs1_addr", false,-1, 4,0);
    for (int i = 0; i < 32; ++i) {
        tracep->declBus(c+1+i*1,"rf", true,(i+0), 31,0);
    }
    tracep->popNamePrefix(1);
    tracep->pushNamePrefix("u_addi ");
    tracep->declBus(c+41,"rs1_data", false,-1, 31,0);
    tracep->declBus(c+40,"imm_data", false,-1, 31,0);
    tracep->declBus(c+42,"rd_data", false,-1, 31,0);
    tracep->popNamePrefix(2);
    tracep->pushNamePrefix("u_ysyx_25030093_IDU ");
    tracep->declBus(c+36,"inst", false,-1, 31,0);
    tracep->declBus(c+43,"imm_type", false,-1, 2,0);
    tracep->declBit(c+44,"Regwrite", false,-1);
    tracep->declBus(c+47,"I", false,-1, 31,0);
    tracep->popNamePrefix(1);
    tracep->pushNamePrefix("u_ysyx_25030093_IFU ");
    tracep->declBit(c+34,"clk", false,-1);
    tracep->declBus(c+35,"io_pc", false,-1, 31,0);
    tracep->declBit(c+37,"rst", false,-1);
    tracep->declBus(c+33,"pc", false,-1, 31,0);
    tracep->popNamePrefix(1);
    tracep->pushNamePrefix("u_ysyx_25030093_imm ");
    tracep->declBus(c+36,"inst", false,-1, 31,0);
    tracep->declBus(c+43,"imm_type", false,-1, 2,0);
    tracep->declBus(c+40,"imm_ex", false,-1, 31,0);
    tracep->declBus(c+40,"imm_I", false,-1, 31,0);
    tracep->popNamePrefix(2);
}

VL_ATTR_COLD void Vysyx_25030093_top___024root__trace_init_top(Vysyx_25030093_top___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vysyx_25030093_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_25030093_top___024root__trace_init_top\n"); );
    // Body
    Vysyx_25030093_top___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vysyx_25030093_top___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vysyx_25030093_top___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vysyx_25030093_top___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vysyx_25030093_top___024root__trace_register(Vysyx_25030093_top___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vysyx_25030093_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_25030093_top___024root__trace_register\n"); );
    // Body
    tracep->addFullCb(&Vysyx_25030093_top___024root__trace_full_top_0, vlSelf);
    tracep->addChgCb(&Vysyx_25030093_top___024root__trace_chg_top_0, vlSelf);
    tracep->addCleanupCb(&Vysyx_25030093_top___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vysyx_25030093_top___024root__trace_full_sub_0(Vysyx_25030093_top___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vysyx_25030093_top___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_25030093_top___024root__trace_full_top_0\n"); );
    // Init
    Vysyx_25030093_top___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vysyx_25030093_top___024root*>(voidSelf);
    Vysyx_25030093_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vysyx_25030093_top___024root__trace_full_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vysyx_25030093_top___024root__trace_full_sub_0(Vysyx_25030093_top___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vysyx_25030093_top__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vysyx_25030093_top___024root__trace_full_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullIData(oldp+1,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[0]),32);
    bufp->fullIData(oldp+2,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[1]),32);
    bufp->fullIData(oldp+3,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[2]),32);
    bufp->fullIData(oldp+4,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[3]),32);
    bufp->fullIData(oldp+5,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[4]),32);
    bufp->fullIData(oldp+6,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[5]),32);
    bufp->fullIData(oldp+7,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[6]),32);
    bufp->fullIData(oldp+8,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[7]),32);
    bufp->fullIData(oldp+9,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[8]),32);
    bufp->fullIData(oldp+10,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[9]),32);
    bufp->fullIData(oldp+11,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[10]),32);
    bufp->fullIData(oldp+12,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[11]),32);
    bufp->fullIData(oldp+13,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[12]),32);
    bufp->fullIData(oldp+14,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[13]),32);
    bufp->fullIData(oldp+15,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[14]),32);
    bufp->fullIData(oldp+16,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[15]),32);
    bufp->fullIData(oldp+17,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[16]),32);
    bufp->fullIData(oldp+18,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[17]),32);
    bufp->fullIData(oldp+19,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[18]),32);
    bufp->fullIData(oldp+20,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[19]),32);
    bufp->fullIData(oldp+21,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[20]),32);
    bufp->fullIData(oldp+22,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[21]),32);
    bufp->fullIData(oldp+23,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[22]),32);
    bufp->fullIData(oldp+24,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[23]),32);
    bufp->fullIData(oldp+25,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[24]),32);
    bufp->fullIData(oldp+26,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[25]),32);
    bufp->fullIData(oldp+27,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[26]),32);
    bufp->fullIData(oldp+28,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[27]),32);
    bufp->fullIData(oldp+29,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[28]),32);
    bufp->fullIData(oldp+30,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[29]),32);
    bufp->fullIData(oldp+31,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[30]),32);
    bufp->fullIData(oldp+32,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__u_Register__DOT__rf[31]),32);
    bufp->fullIData(oldp+33,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_IFU__DOT__pc),32);
    bufp->fullBit(oldp+34,(vlSelf->clk));
    bufp->fullIData(oldp+35,(vlSelf->io_pc),32);
    bufp->fullIData(oldp+36,(vlSelf->inst),32);
    bufp->fullBit(oldp+37,(vlSelf->rst));
    bufp->fullCData(oldp+38,((0x1fU & (vlSelf->inst 
                                       >> 7U))),5);
    bufp->fullCData(oldp+39,((0x1fU & (vlSelf->inst 
                                       >> 0xfU))),5);
    bufp->fullIData(oldp+40,((((- (IData)((vlSelf->inst 
                                           >> 0x1fU))) 
                               << 0xbU) | (0x7ffU & 
                                           (vlSelf->inst 
                                            >> 0x14U)))),32);
    bufp->fullIData(oldp+41,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__rs1_data_reg),32);
    bufp->fullIData(oldp+42,(vlSelf->ysyx_25030093_top__DOT__u_ysyx_25030093_EXU__DOT__rd_data),32);
    bufp->fullCData(oldp+43,(0U),3);
    bufp->fullBit(oldp+44,(1U));
    bufp->fullIData(oldp+45,(5U),32);
    bufp->fullIData(oldp+46,(0x20U),32);
    bufp->fullIData(oldp+47,(0U),32);
}
