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
#include <device/mmio.h>
#include <isa.h>



#if   defined(CONFIG_PMEM_MALLOC)
static uint8_t *pmem = NULL;
#else // CONFIG_PMEM_GARRAY
static uint8_t pmem[CONFIG_MSIZE] PG_ALIGN = {};
#endif

uint8_t* guest_to_host(paddr_t paddr) { return pmem + paddr - CONFIG_MBASE; }
paddr_t host_to_guest(uint8_t *haddr) { return haddr - pmem + CONFIG_MBASE; }

static word_t pmem_read(paddr_t addr, int len) {
  //printf("addr=0x%08x\n",addr);
  //printf("guest addr =0x%08x\n",*guest_to_host(addr));
  word_t ret = host_read(guest_to_host(addr), len);
  //printf("ret =0x%08x\n",ret);
  return ret;
}

static void pmem_write(paddr_t addr, int len, word_t data) {
//  printf("addr=0x%08x\n",addr);
  host_write(guest_to_host(addr), len, data);
}

static void out_of_bound(paddr_t addr) {
  panic("address = " FMT_PADDR " is out of bound of pmem [" FMT_PADDR ", " FMT_PADDR "] at pc = " FMT_WORD,
      addr, PMEM_LEFT, PMEM_RIGHT, cpu.pc);

}

void init_mem() {
#if   defined(CONFIG_PMEM_MALLOC)
  pmem = malloc(CONFIG_MSIZE);
  assert(pmem);
#endif
  IFDEF(CONFIG_MEM_RANDOM, memset(pmem, rand(), CONFIG_MSIZE));
  Log("physical memory area [" FMT_PADDR ", " FMT_PADDR "]", PMEM_LEFT, PMEM_RIGHT);
}

word_t paddr_read(paddr_t addr, int len) {
 // printf("nemu here\n");
  //检查内存是否溢出
  if (likely(in_pmem(addr))) {
    #ifdef CONFIG_MTRACE
        printf("now addr : 0x%08x , len = %d\n",addr,len);
    #endif
    return pmem_read(addr, len);}
    
    if (addr == 0xa0000048 || addr == 0xa000004c) {
      uint64_t us = get_time();
      if (addr == 0xa0000048) {
          return (uint32_t)(us & 0xFFFFFFFF);  // 返回低 32 位
      } else {
          return (uint32_t)(us >> 32);         // 返回高 32 位
      }
  }
  // 处理串口输出 
  if (addr == 0xa00003F8) {
      return 0;  
  }
    //npc diff 
  IFDEF(CONFIG_DEVICE, return mmio_read(addr, len));
  out_of_bound(addr);
  return 0;
}

void paddr_write(paddr_t addr, int len, word_t data) {
  if (likely(in_pmem(addr))) { 
    #ifdef CONFIG_MTRACE
      printf("now write addr =0x%08x ,len = %d\n",addr,len);
    #endif
    pmem_write(addr, len, data); return; }
    
    if (addr == 0xa00003f8) {
    //  putchar((char)data);  // 输出字符
      return;
  }
  // 处理计时器
  if (addr == 0xa0000048 || addr == 0xa000004c) {
      return;  
  }
     //npc diff 
   // printf("other addr=0x%08x\n",addr);
  IFDEF(CONFIG_DEVICE, mmio_write(addr, len, data); return);
 out_of_bound(addr);
}
