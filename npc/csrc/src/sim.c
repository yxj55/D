#include <isa.h>
#include<sim.h>
#include "Vysyx_25030093_top___024root.h"
#include<cpu.h>
#include <reg.h>




void step_and_dump_wave(){
  contextp->timeInc(1);
  tfp->dump(contextp->time());
}
void single_clk(){
  // 上升沿
    top->clk = 1;
    top->eval();
    tfp->dump(contextp->time());  // 记录下降沿波形
    contextp->timeInc(1);

    // 下降沿
    top->clk = 0;
    top->eval();
    tfp->dump(contextp->time());  // 记录上升沿波形
    contextp->timeInc(1);
}
void reset(int n){
  top->rst=1;
  while(n--) single_clk();
  top->rst=0;
}
void sim_exit(){
  single_clk();
  tfp->close();
}
extern "C" void npc_ebreak(){

 // printf("ebreak here\n");
  NPCTRAP(top->pc,cpu.gpr[10]);
  //printf("NOW NPC_state %d\n",npc_state.state);
 // isa_reg_display();
 //printf("here error\n");
// single_clk();
 sim_exit();
 free(top);
}
