#ifndef __SIM_H__
#define __SIM_H__

#include <isa.h>


extern "C" void npc_ebreak();

void step_and_dump_wave();
 
void single_clk();
 
 void reset(int n);
void sim_exit();



#endif