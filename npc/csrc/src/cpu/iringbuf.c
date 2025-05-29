#include <common.h>
#include <utils.h>


typedef struct iringbuf
{
    vaddr_t pc[32];//pc
    uint32_t inst[32];//inst
    uint32_t head;//读取数据节点
    uint32_t tail;//写入数据节点
}iringbuf;

iringbuf rb;

//写入
void iringbuf_push(vaddr_t pc,uint32_t inst){
    rb.pc[rb.tail]=pc;
    rb.inst[rb.tail]=inst;
    rb.tail=(rb.tail+1)%32;//更新位置
    if(rb.head==rb.tail){
        rb.tail=(rb.tail+1)%32;
    }
}
void iringbuf_printf(){
    char logbuf[128];
    while(rb.head != rb.tail){
        char *p=logbuf;
        if(rb.head +1 ==rb.tail){//为最后一个数据,也就是错误位置
            p+=sprintf(p,"%s",ANSI_FG_RED "here-->");
        }else {
            memset(p,' ',4);
        }
        p += snprintf(p, sizeof(logbuf), FMT_WORD ":", rb.pc[rb.head]);
        int i;
        uint8_t *inst = (uint8_t *)&rb.inst[rb.head];
        for (i = 3; i >= 0; i --) {
            p += snprintf(p, 4, " %02x", inst[i]);
        }
        memset(p,' ',4);
        p+=4;
        void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);
    disassemble(p, logbuf + sizeof(logbuf) - p,rb.pc[rb.head],(uint8_t *)&rb.inst[rb.head],4);
    printf("%s\n",logbuf);
    rb.head=(rb.head+1)%32;
    }


}
