#include <am.h>
#include <klib-macros.h>
#include <klib.h>
#include "/home/yuanxiao/ysyx-workbench/abstract-machine/am/src/riscv/npc/npc.h"

# define npc_trap(code) asm volatile("mv a0, %0; ebreak" : :"r"(code))


#define CSR_MVENDORID 0xF11
#define CSR_MARCHID   0xF12

#define UART_BASE 0x10000000L
#define UART_TX   0
#define UART_LCR  UART_BASE + 3
#define UART_LSR  UART_BASE + 5



extern char _heap_start;
int main(const char *args);

extern char _pmem_start;
#define PMEM_SIZE (128 * 1024 * 1024)
#define PMEM_END  ((uintptr_t)&_pmem_start + PMEM_SIZE)

Area heap = RANGE(&_heap_start, PMEM_END);
static const char mainargs[MAINARGS_MAX_LEN] = TOSTRING(MAINARGS_PLACEHOLDER); // defined in CFLAGS


void init_div_uart(uint16_t divisor){
  outb(UART_LCR,128);//LCR第七位设置为1,开始访问除数寄存器

  outb(UART_BASE + 1,(divisor >> 8) & 0xFF);//高8
  outb(UART_BASE ,divisor & 0xFF);//低8
  
  outb(UART_LCR,0);//LCR第七位设置为0,停止访问除数寄存器,开始访问正常寄存器
}

void wait_fifo_empty()//轮询
{
  while((inb(UART_LSR) & 0x20) == 0){

  }
  return;
}



void read_csr(){
  uint32_t mvendorid_data,marchid_data;
  __asm__ volatile ("csrr %0, %1" : "=r"(mvendorid_data) : "i"(0xF11));
  __asm__ volatile ("csrr %0, %1" : "=r"(marchid_data) : "i"(0xF12));
    
    // 可以使用读取到的值
     printf("MVENDORID: 0x%d\n", mvendorid_data);
     printf("MARCHID: 0x%d\n", marchid_data);

}

void putch(char ch) {
  wait_fifo_empty();
  outb(UART_BASE + UART_TX, ch);
}

void halt(int code) {
 npc_trap(code);
  while (1);
}

void _trm_init() {
 
  init_div_uart(2);
 // read_csr();
  int ret = main(mainargs);
  halt(ret);
}
