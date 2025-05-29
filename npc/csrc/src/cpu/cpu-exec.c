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

#include <cpu.h>
#include <isa.h>
#include <locale.h>
#include <ifetch.h>
#include <common.h>
#include <memory/paddr.h>

/* The assembly code of instructions executed is only output to the screen
 * when the number of instructions executed is less than this value.
 * This is useful when you use the `si' command.
 * You can modify this value as you want.
 */
#define MAX_INST_TO_PRINT 10
void npc_reg();
IFDEF(CONFIG_ITRACE, char logbuf[128]);
CPU_state cpu ={};
uint64_t g_nr_guest_inst = 0;
static uint64_t g_timer = 0; // unit: us
static bool g_print_step = false;

void device_update();
int update_watchpoint();
void iringbuf_printf();
void difftest_step(vaddr_t pc, vaddr_t npc);

void iringbuf_push(vaddr_t pc,uint32_t inst);
static void trace_and_difftest() {
  /*
#ifdef CONFIG_ITRACE_COND
  if (ITRACE_COND) { log_write("%s\n", logbuf); }
#endif
*/
  if (g_print_step) { IFDEF(CONFIG_ITRACE, puts(logbuf)); }
#ifdef CONFIG_DIFFTEST
  difftest_step(top->pc, top->pc);
#endif
#ifdef CONFIG_WATCHPOINT
  if(update_watchpoint()==1){
	  npc_state.state=NPC_STOP;
  }
#endif
}

static void exec_once(){
  
  top->inst = inst_fetch(&top->pc,4);//取指令
  //iringbuf_push(top->pc,top->inst);//写入iringbuf


#ifdef CONFIG_ITRACE
  char *p = logbuf;
  p += snprintf(p, sizeof(logbuf), FMT_WORD ":", top->pc);
  int ilen = 4;
  int i;
  uint8_t *inst = (uint8_t *)&top->inst;
#ifdef CONFIG_ISA_x86
  for (i = 0; i < ilen; i ++) {
#else
  for (i = ilen - 1; i >= 0; i --) {
#endif
    p += snprintf(p, 4, " %02x", inst[i]);
  }
  int ilen_max = MUXDEF(CONFIG_ISA_x86, 8, 4);
  int space_len = ilen_max - ilen;
  if (space_len < 0) space_len = 0;
  space_len = space_len * 3 + 1;
  memset(p, ' ', space_len);
  p += space_len;

  void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);
  disassemble(p, logbuf + sizeof(logbuf) - p,
      top->pc, (uint8_t *)&top->inst, ilen);
#endif
}

static void execute(uint64_t n) {

  for (;n > 0; n --) {
   
    exec_once();
    single_clk(); 
    g_nr_guest_inst ++;
    trace_and_difftest();
    if (npc_state.state != NPC_RUNNING) break;
    IFDEF(CONFIG_DEVICE, device_update());
  }
}
/*
static void statistic() {
  IFNDEF(CONFIG_TARGET_AM, setlocale(LC_NUMERIC, ""));
#define NUMBERIC_FMT MUXDEF(CONFIG_TARGET_AM, "%", "%'") PRIu64
  Log("host time spent = " NUMBERIC_FMT " us", g_timer);
  Log("total guest instructions = " NUMBERIC_FMT, g_nr_guest_inst);
  if (g_timer > 0) Log("simulation frequency = " NUMBERIC_FMT " inst/s", g_nr_guest_inst * 1000000 / g_timer);
  else Log("Finish running in less than 1 us and can not calculate the simulation frequency");
}

void assert_fail_msg() {
  isa_reg_display();
  statistic();
}
*/
/* Simulate how the CPU works. */
void cpu_exec(uint64_t n) {
  g_print_step = (n < MAX_INST_TO_PRINT);
  switch (npc_state.state) {
    case NPC_END: case NPC_ABORT: case NPC_QUIT:
      printf("Program execution has ended. To restart the program, exit NEMU and run again.\n");
      return;
    default: npc_state.state = NPC_RUNNING;
  }

 // uint64_t timer_start = get_time();

  execute(n);

 // uint64_t timer_end = get_time();
  //g_timer += timer_end - timer_start;

  switch (npc_state.state) {
    case NPC_RUNNING: npc_state.state = NPC_STOP; break;

    case NPC_END: case NPC_ABORT:
   // printf("NPC_STATE进入成功\n");
      Log("npc: %s at pc = " FMT_WORD,
          (npc_state.state == NPC_ABORT ? ANSI_FMT("ABORT", ANSI_FG_RED) :
           (npc_state.halt_ret == 0 ? ANSI_FMT("HIT GOOD TRAP", ANSI_FG_GREEN) :
            ANSI_FMT("HIT BAD TRAP", ANSI_FG_RED))),
          npc_state.halt_pc);
          #ifdef CONFIG_ITRACE
          if((npc_state.state==NPC_END)){
          // printf("itrace right\n");
            iringbuf_printf();
          }
          #endif
          
  }
}
