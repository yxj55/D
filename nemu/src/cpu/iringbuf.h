#ifdef __IRINGBUF_H__
#define __IRINGBUF_H__

void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);
void iringbuf_push(vaddr_t pc,uint32_t inst);
void iringbuf_printf();
#endif
