#include "verilated.h"
#include "verilated_vcd_c.h"
#include "../obj_dir/Vysyx_25030093_top.h"
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

static uint32_t inst[]={
  0b00000000010100000000000010010011, //addi,x1,x0,5
	0b00000000011000001000000010010011, //addi,x1,x1,6
  0b00000000000100000000000001110011,//ebreak
  0b00000000000100001000000010010011, //addi,x1,x1,1
};
uint32_t *init_mem (size_t size){
  uint32_t* memory = (uint32_t *) malloc(size *sizeof(uint32_t));
  memcpy(memory,inst,sizeof(inst));
  if(memory==NULL){
    exit(0);
  }
  return memory;
}
uint32_t guest_to_host(uint32_t addr){return addr-0x80000000;}
uint32_t pmem_read(uint32_t *memory,uint32_t vaddr){
  uint32_t paddr = guest_to_host(vaddr);
  printf("paddr :%d\n",paddr);
  printf("memory[0]:%d\n",memory[0]);
  return memory[paddr/4];
}


VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;

static Vysyx_25030093_top* top;

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
static void reset(int n){
  top->rst=1;
  while(n--) single_clk();
  top->rst=0;
}
void sim_init(){
  contextp = new VerilatedContext;
  tfp = new VerilatedVcdC;
  top = new Vysyx_25030093_top;
  contextp->traceEverOn(true);
  top->trace(tfp, 5);
  tfp->open("dump.vcd");
}

void sim_exit(){
  tfp->close();
}
extern "C" void npc_ebreak(){
 single_clk();
 sim_exit();
}
int main() {
  uint32_t *memory;
  memory=init_mem(2);
  sim_init();
  reset(2);
  for(int i=0;i<3;i++)
  {
  top->inst = pmem_read(memory,top->io_pc);
  single_clk(); 
    //step_and_dump_wave();
  }
  sim_exit();
}
