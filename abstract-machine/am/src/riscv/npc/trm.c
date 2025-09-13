#include <am.h>
#include <klib-macros.h>
#include "/home/yuanxiao/ysyx-workbench/abstract-machine/am/src/riscv/npc/npc.h"

# define npc_trap(code) asm volatile("mv a0, %0; ebreak" : :"r"(code))


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


void putch(char ch) {
  wait_fifo_empty();
  outb(SERIAL_PORT, ch);
}

void halt(int code) {
 npc_trap(code);
  while (1);
}

void _trm_init() {
  init_div_uart(200);
  int ret = main(mainargs);
  halt(ret);
}
