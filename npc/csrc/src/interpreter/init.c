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
#include <memory/paddr.h>

// this is not consistent with uint8_t
// but it is ok since we do not access the array directly
static const uint32_t img [] = {
  0x00000097, // auipc x1, 0
  0x00100073 // ebreak
};


#include <isa.h>

VerilatedContext* contextp = NULL;  
VerilatedVcdC* tfp = NULL;         
Vysyx_25030093_top *top = NULL;    
; 
void sim_init() {
  contextp = new VerilatedContext;
  tfp = new VerilatedVcdC;
  top = new Vysyx_25030093_top;
  contextp->traceEverOn(true);
  top->trace(tfp, 5);
  tfp->open("dump.vcd");
}
static void restart() {
  /* Set the initial program counter. */
  top->pc = RESET_VECTOR;

  /* The zero register is always 0. */
  
}

void init_isa() {
  /* Load built-in image. */
   restart();
  memcpy(guest_to_host(RESET_VECTOR), img, sizeof(img));

  /* Initialize this virtual computer system. */

}
