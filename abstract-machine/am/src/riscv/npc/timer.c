#include <am.h>
#include <klib.h>
#include "npc.h"


void __am_timer_init() {
  outl(mcycle_ADDR, 0);
  outl(mcycleh_ADDR, 0);
}

void __am_timer_uptime(AM_TIMER_UPTIME_T *uptime) {
  uint32_t high;
  uint32_t low ;
  __asm__ volatile ("csrr %0, mcycleh" : "=r"(high));
  __asm__ volatile ("csrr %0, mcycle" : "=r"(low));
  uint64_t cycles = ((uint64_t)high << 32) | low;
 
 
  // 避免溢出的计算方法：先除后乘
  uptime->us =cycles / 50;

 
  //  printf("now AM us = %d\n",uptime->us);
}

void __am_timer_rtc(AM_TIMER_RTC_T *rtc) {
  rtc->second = 0;
  rtc->minute = 0;
  rtc->hour   = 0;
  rtc->day    = 0;
  rtc->month  = 0;
  rtc->year   = 1900;
}
