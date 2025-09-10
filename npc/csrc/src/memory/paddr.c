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
static uint8_t pmem[CONFIG_MSIZE + CONFIG_SSIZE] PG_ALIGN = {};
// static uint8_t pmem_flash[16 * 1024 * 1024] = {};
#endif


// uint8_t *Flash_guest_to_host(uint32_t addr){
//   return pmem_flash + addr;
// }


uint8_t* guest_to_host(uint32_t addr) { 
  uint32_t op=0;
  if(((addr >= 0x30000000) & (addr < 0x3fffffff))){
   
    op = addr -CONFIG_MBASE;
    // printf("here and now op == %d\n",op);
 }
 else{
   op = addr -CONFIG_SBASE + CONFIG_MSIZE;
  //  printf("SBASE here and now op == %d\n",op);
 }
  
  return pmem + op;
 }
paddr_t host_to_guest(uint8_t *haddr) { return haddr - pmem + CONFIG_MBASE; }

static int pmem_read(paddr_t addr,int len) {
  if(addr ==0){return 0;}

 // printf("now addr = 0x%08x\n",addr);
// printf("now addr 0x%08x\n",addr);

 // printf("op == %d\n",op);
  word_t ret = host_read(guest_to_host(addr) ,len);
  //printf("npc ret = 0x%08x\n",ret);
  return ret;
}

static void pmem_write(paddr_t addr, int len, word_t data) {
  host_write(guest_to_host(addr), len, data);
}

static void out_of_bound(paddr_t addr) {
 // single_clk();
  sim_exit();
  panic("address = " FMT_PADDR " is out of bound of pmem [" FMT_PADDR ", " FMT_PADDR "] at pc = " FMT_WORD,
      addr, PMEM_LEFT, PMEM_RIGHT,cpu.pc );
}

void init_mem() {
#if   defined(CONFIG_PMEM_MALLOC)
printf("inin_mem right\n");
  pmem = malloc(CONFIG_MSIZE);
  assert(pmem);
#endif
  IFDEF(CONFIG_MEM_RANDOM, memset(pmem, rand(), (CONFIG_MSIZE + CONFIG_SSIZE)));
  IFDEF(CONFIG_MEM_RANDOM, memset(pmem_flash, rand(), 4096));
  Log("physical memory area [" FMT_PADDR ", " FMT_PADDR "]", PMEM_LEFT, PMEM_RIGHT);
}



extern "C" void flash_read(int32_t addr, int32_t *data) { 
  //printf("addr = %x\n",addr);
  *data = host_read(guest_to_host(addr) ,4);


 }
extern "C" void mrom_read(int32_t addr, int32_t *data) { 


  // printf("%02x\n",pmem[0+8]);
  // printf("%02x\n",pmem[1+8]);
  // printf("%02x\n",pmem[2+8]);
  // printf("%02x\n",pmem[3+8]);
  // printf("%02x\n",pmem[4+8]);
  // printf("%02x\n",pmem[5+8]);
  // printf("%02x\n",pmem[6+8]);
  // printf("%02x\n",pmem[7+8]);
 // printf("%02x\n",pmem[8]);
  // printf("end\n\n");
//printf("now addr = 0x%08x\n",addr);

  if(likely(in_mrom(addr)|(in_sram(addr)))) {

    *data =  pmem_read(addr,4);
    return;
  }
  

  out_of_bound(addr);
 }




// extern "C" int paddr_read(paddr_t addr) {
//   //printf("npc here\n");
//   //检查内存是否溢出
 //  if (likely(in_pmem(addr))) {
    
//     #ifdef CONFIG_MTRACE
//         printf("now addr : 0x%08x , len = %d\n",addr,len);
//     #endif
//     return  pmem_read(addr,4);}
//    // printf("read now addr =0x%08x\n",addr);
//   //   if (addr == 0xa0000048 || addr == 0xa000004c) {
//   //     uint64_t us = get_time();
//   //     if (addr == 0xa0000048) {
//   //         return (uint32_t)(us & 0xFFFFFFFF);  // 返回低 32 位
//   //     } else {
//   //         return (uint32_t)(us >> 32);         // 返回高 32 位
//   //     }
//   // }

//   // 处理串口输出 (UART)
//   // if (addr == 0xa00003F8) {
//   //     return 0;  // 串口读取
//   // }

// //  IFDEF(CONFIG_DEVICE, return mmio_read(addr, len));
// //printf(ANSI_BG_RED "addr read\n" ANSI_NONE);
// //printf("read\n\n");
// out_of_bound(addr);
//   return 0;
// }

// extern "C" void paddr_write(paddr_t addr, char wstrb, word_t data) {
//   if (likely(in_pmem(addr))) { 
//     /*
//     #ifdef CONFIG_MTRACE
//       printf("now write addr =0x%08x ,len = %d\n",addr,len);
//     #endif
//     */
//     pmem_write(addr, wstrb, data); return; }
//     // 处理串口输出
//    // printf("now addr =0x%08x\n",addr);
//   //   if (addr == 0xa00003f8) {
//   //     putchar((char)data);  // 输出字符
//   //     return;
//   // }
//   // 处理计时器
//   // if (addr == 0xa0000048 || addr == 0xa000004c) {
//   //     return;  
//   // }
//    // printf("write\n\n");
//  // IFDEF(CONFIG_DEVICE, mmio_write(addr, len, data); return);
//  //printf(ANSI_BG_RED "addr write\n" ANSI_NONE);
// out_of_bound(addr);
//   return;
// }
