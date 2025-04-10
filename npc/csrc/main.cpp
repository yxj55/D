#include "verilated.h"
#include "verilated_fst_c.h"
#include "obj_dir/VIFU.h"

VerilatedContext* contextp = NULL;
VerilatedFstC* tfp = NULL;

static VIFU* top;

void step_and_dump_wave(){
  contextp->timeInc(1);
  tfp->dump(contextp->time());
}
void sim_init(){
  contextp = new VerilatedContext;
  tfp = new VerilatedFstC;
  top = new Valu;
  contextp->traceEverOn(true);
  top->trace(tfp, 99);
  tfp->open("dump.fst");
}

void sim_exit(){
  step_and_dump_wave();
  tfp->close();
}

int main() {
  sim_init();
  while (1)
  {
    top->inst = peme_read(top->pc);
    top->eval();
  }
  


  sim_exit();
}