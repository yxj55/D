/***************************************************************************************
* Copyright (c) 2014-2024 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#ifndef __REG_H__
#define __REG_H__

#include <common.h>
#include <isa.h>
extern Vysyx_25030093_top___024root* rootp ;

/*
static inline int csr_name(int i){

  int csr_addr[]={0x305,0x341,0x342,0x300};
  for(int p=0;p<4;p++){
    if(csr_addr[p]==i) {return rootp->ysyx_25030093_top__DOT__u_ysyx_25030093_CSR_REG__DOT__csr[p];}
  }
  assert(0 && "Not Found csr");
  return -1;
}
*/
static inline int check_reg_idx(int idx) {
  const char *regs[] = {
    "$0", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
    "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
    "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
    "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"
  };
   assert(idx >= 0 && idx < 32);
  bool success=true;
  return isa_reg_str2val(regs[idx],&success);
}

//#define sr(i) (cpu.sr[csr_name(i)])

#define gpr(idx) (check_reg_idx(idx))

static inline const char* reg_name(int idx) {
  extern const char* regs[];
  return regs[check_reg_idx(idx)];
}

#endif
