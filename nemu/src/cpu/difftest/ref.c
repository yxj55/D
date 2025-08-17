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

#include <isa.h>
#include <cpu/cpu.h>
#include <difftest-def.h>
#include <memory/paddr.h>

__EXPORT void difftest_memcpy(uint32_t addr, void *buf, size_t n, bool direction) {
  printf("进入成功11\n\n");
  if(direction == DIFFTEST_TO_REF){
    memcpy(guest_to_host(addr),buf,n);
  } else {
    printf("DUT here\n\n");
  assert(0);
  }
}

__EXPORT void difftest_regcpy(CPU_state *dut, bool direction) {
 if(direction == DIFFTEST_TO_DUT){
    for(int i=0;i<32;i++){
      dut->gpr[i] = cpu.gpr[i];
    }
    dut->pc = cpu.pc;
 } 
}

__EXPORT void difftest_exec(uint64_t n) {
  cpu_exec(n);
}

__EXPORT void difftest_raise_intr(word_t NO) {
  assert(0);
}

__EXPORT void difftest_init(int port) {
  void init_mem();
  init_mem();
  /* Perform ISA dependent initialization. */
  init_isa();
}
