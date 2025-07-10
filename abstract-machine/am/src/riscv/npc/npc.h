#ifndef NPC_H__
#define NPC_H__

#include "/home/yuanxiao/ysyx-workbench/abstract-machine/am/src/riscv/riscv.h"


# define DEVICE_BASE 0xa0000000


#define SERIAL_PORT     (DEVICE_BASE + 0x00003f8)
#define RTC_ADDR        (DEVICE_BASE + 0x0000048)

#endif