#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vysyx_25030093_top.h"
#include <common.h>
#include <memory/paddr.h>
#include <isa.h>
#include <ifetch.h>



//uint32_t guest_to_host_test(uint32_t addr){return addr -0x80000000;}
void init_monitor(int argc, char *argv[]);

void sdb_mainloop();

#ifdef CONFIG_VERILATORTEST
uint32_t *init_mem (size_t size){
  uint32_t* memory = (uint32_t *) malloc(size *sizeof(uint32_t));
  memcpy(memory,img,sizeof(img));
  if(memory==NULL){
    exit(0);
  }
  return memory;
}


uint32_t pmem_read(uint32_t *memory,uint32_t vaddr){
  uint32_t paddr = guest_to_host_test(vaddr);
  //printf("paddr :%d\n",paddr);
  //printf("memory[0]:%d\n",memory[0]);
  return memory[paddr/4];
}
#endif




int main(int argc, char *argv[]) {
 init_monitor(argc,argv);

// uint32_t *memory = init_mem(4);
 //printf("right\n");
  reset(5);

 sdb_mainloop();
 
// printf("here\n");
  sim_exit();
}
