#include <am.h>
#include <klib.h>
#include "npc.h"

#define CPU_FREQ 10000000  // 15 MHz
#define US_PER_SEC 1000000   // 1秒 = 1,000,000微秒

void __am_timer_init() {
}

void __am_timer_uptime(AM_TIMER_UPTIME_T *uptime) {
  uint32_t high;
  uint32_t low ;
  __asm__ volatile ("csrr %0, %1" : "=r"(high) : "i"(mcycleh_ADDR));
  __asm__ volatile ("csrr %0, %1" : "=r"(low) : "i"(mcycle_ADDR));
  uint64_t cycles = ((uint64_t)high << 32) | low;
 
 

  uptime->us = (cycles * US_PER_SEC) / CPU_FREQ;
 
   // printf("now AM us = %d\n",uptime->us);
}

void __am_timer_rtc(AM_TIMER_RTC_T *rtc) {
  rtc->second = 0;
  rtc->minute = 0;
  rtc->hour   = 0;
  rtc->day    = 0;
  rtc->month  = 0;
  rtc->year   = 1900;
}
