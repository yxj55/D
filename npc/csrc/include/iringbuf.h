#ifdef __IRINGBUF_H__
#define __IRINGBUF_H__


void iringbuf_push(vaddr_t pc,uint32_t inst);
void iringbuf_printf();
#endif
