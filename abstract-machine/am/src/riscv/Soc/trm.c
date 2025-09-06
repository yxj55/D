#include <am.h>
#include <klib-macros.h>
#include <klib.h>
#include<Soc.h>

#define UART_BASE 0x10000000L
#define UART_TX   0
#define UART_LCR  UART_BASE + 3
#define UART_LSR  UART_BASE + 5

# define Soc_trap(code) asm volatile("mv a0, %0; ebreak" : :"r"(code))



//  extern char _heap_start;
int main(const char *args);

//  extern char _pmem_start;
//  #define PMEM_SIZE (16 * 1024 * 1024)
//  #define PMEM_END  ((uintptr_t)&_pmem_start + PMEM_SIZE)

//  Area heap = RANGE(&_heap_start, PMEM_END);//指示堆区的开头结尾
static const char mainargs[MAINARGS_MAX_LEN] = MAINARGS_PLACEHOLDER; // defined in CFLAGS

void SPI_Flash_init();
void SPI_Bitrev_init();

void wait_fifo_empty()//轮询
{
  while((inb(UART_LSR) & 0x20) == 0){

  }
  return;
}


void putch(char ch) {

     wait_fifo_empty();
     outb(UART_BASE + UART_TX,ch);
}


void init_div_uart(uint16_t divisor){
  outb(UART_LCR,128);//LCR第七位设置为1,开始访问除数寄存器

  outb(UART_BASE + 1,(divisor >> 8) & 0xFF);//高8
  outb(UART_BASE ,divisor & 0xFF);//低8
  
  outb(UART_LCR,0);//LCR第七位设置为0,停止访问除数寄存器,开始访问正常寄存器
}

void halt(int code) {
  Soc_trap(code);
  while (1);
}




void _trm_init() {
  extern uint8_t _sidata[];  /* ROM中的源地址 */
  extern uint8_t _sdata[];   /* SRAM中的目标地址 */
  extern uint8_t _edata[]; 
 size_t data_len =(size_t)(_edata - _sdata);

  if(data_len >0){
  memcpy(_sdata,_sidata,data_len);
  }

  extern uint8_t _bss_start[], _ebss[];
  size_t bss_len = (size_t)(_ebss - _bss_start);
  if (bss_len > 0) {
    memset(_bss_start, 0, bss_len);
  }
  
  
  init_div_uart(200);

  SPI_Flash_init(); 
  int ret = main(mainargs);
  halt(ret);
}
