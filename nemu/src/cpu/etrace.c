#include <common.h>
#include <utils.h>
#include <isa.h>
#include </home/yuanxiao/ysyx-workbench/nemu/include/cpu/decode.h>
#ifdef CONFIG_ETRACE
void etrace_printf( Decode *s){

    char *p = s->logbuf;
    p += snprintf(p, sizeof(s->logbuf), FMT_WORD ":", s->pc);
    int ilen = s->snpc - s->pc;
    int i;
    uint8_t *inst = (uint8_t *)&s->isa.inst;
    
  for (i = ilen - 1; i >= 0; i --) {

    p += snprintf(p, 4, " %02x", inst[i]);
  }
  int ilen_max = MUXDEF(CONFIG_ISA_x86, 8, 4);
  int space_len = ilen_max - ilen;
  if (space_len < 0) space_len = 0;
  space_len = space_len * 3 + 1;
  memset(p, ' ', space_len);
  p += space_len;

  void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);
  disassemble(p, s->logbuf + sizeof(s->logbuf) - p,
      MUXDEF(CONFIG_ISA_x86, s->snpc, s->pc), (uint8_t *)&s->isa.inst, ilen);
printf("%s  now pc :0x%08x  dnpc :0x%08x\n",s->logbuf,s->pc,s->dnpc);
}
#endif