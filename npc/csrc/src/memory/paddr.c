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

#include <memory/host.h>
#include <memory/paddr.h>
#include <common.h>
//#include <device/mmio.h>
#include <isa.h>
#include<sim.h>
#include <utils.h>


#if   defined(CONFIG_PMEM_MALLOC)
static uint8_t *pmem = NULL;
#else // CONFIG_PMEM_GARRAY
static uint8_t pmem[CONFIG_MSIZE] PG_ALIGN = {};
#endif

uint8_t* guest_to_host(paddr_t paddr) { return pmem + paddr - CONFIG_MBASE; }
paddr_t host_to_guest(uint8_t *haddr) { return haddr - pmem + CONFIG_MBASE; }

static int pmem_read(paddr_t addr,int len) {
  if(addr ==0){return 0;}
  word_t ret = host_read(guest_to_host(addr) ,len);
  return ret;
}

static void pmem_write(paddr_t addr, int len, word_t data) {
  host_write(guest_to_host(addr), len, data);
}

static void out_of_bound(paddr_t addr) {
 // single_clk();
  sim_exit();
  panic("address = " FMT_PADDR " is out of bound of pmem [" FMT_PADDR ", " FMT_PADDR "] at pc = " FMT_WORD,
      addr, PMEM_LEFT, PMEM_RIGHT,top->pc );
}

void init_mem() {
#if   defined(CONFIG_PMEM_MALLOC)
printf("inin_mem right\n");
  pmem = malloc(CONFIG_MSIZE);
  assert(pmem);
#endif
  IFDEF(CONFIG_MEM_RANDOM, memset(pmem, rand(), CONFIG_MSIZE));
  Log("physical memory area [" FMT_PADDR ", " FMT_PADDR "]", PMEM_LEFT, PMEM_RIGHT);
}

extern "C" int paddr_read(paddr_t addr,int len) {
  //printf("npc here\n");
  //检查内存是否溢出
  if (likely(in_pmem(addr))) {
    
    #ifdef CONFIG_MTRACE
        printf("now addr : 0x%08x , len = %d\n",addr,len);
    #endif
    return  pmem_read(addr,len);}
   // printf("read now addr =0x%08x\n",addr);
    if (addr == 0xa0000048 || addr == 0xa000004c) {
      uint64_t us = get_time();
      if (addr == 0xa0000048) {
          return (uint32_t)(us & 0xFFFFFFFF);  // 返回低 32 位
      } else {
          return (uint32_t)(us >> 32);         // 返回高 32 位
      }
  }

  // 处理串口输出 (UART)
  if (addr == 0xa00003F8) {
      return 0;  // 串口读取
  }

//  IFDEF(CONFIG_DEVICE, return mmio_read(addr, len));
//printf(ANSI_BG_RED "addr read\n" ANSI_NONE);
//printf("read\n\n");
out_of_bound(addr);
  return 0;
}

extern "C" void paddr_write(paddr_t addr, int len, word_t data) {
  if (likely(in_pmem(addr))) { 
    /*
    #ifdef CONFIG_MTRACE
      printf("now write addr =0x%08x ,len = %d\n",addr,len);
    #endif
    */
    pmem_write(addr, len, data); return; }
    // 处理串口输出
   // printf("now addr =0x%08x\n",addr);
    if (addr == 0xa00003f8) {
      putchar((char)data);  // 输出字符
      return;
  }
  // 处理计时器
  if (addr == 0xa0000048 || addr == 0xa000004c) {
      return;  
  }
   // printf("write\n\n");
 // IFDEF(CONFIG_DEVICE, mmio_write(addr, len, data); return);
 //printf(ANSI_BG_RED "addr write\n" ANSI_NONE);
out_of_bound(addr);
  return;
}
