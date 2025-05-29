#include <common.h>
#include <utils.h>
#include <elf.h>

static uint32_t depth =0;//控制输出
typedef struct symbol_str
{
    char *name;
    Elf32_Addr addr;
    Elf32_Word size;
    unsigned char info;

}symbol_str;

static symbol_str *symbol_data=NULL;
static int symbol_count = 0;

void ftrace_elf(char * elf_file){
    if(elf_file == NULL){

        return;
    }
    FILE *fp=fopen(elf_file,"r");
    assert(fp !=NULL);
    Elf32_Ehdr ehdr;
    Elf32_Shdr *shdr;
    char *shstrtab = NULL;
   Elf32_Sym *symtab = NULL;
  char *strtab = NULL;
   int symtab_size =0;

//读取ELF文件的头
   if( fread(&ehdr,sizeof(Elf32_Ehdr),1,fp) != 1){
    fclose(fp);
    printf("fread ELF header error\n");
    return;
   }

//检查是否为ELF文件
    if(memcmp(ehdr.e_ident,ELFMAG,SELFMAG) !=0){
        printf("error not ELF\n");
        fclose(fp);
        return;
    }
//找到Section header
    fseek(fp,ehdr.e_shoff,SEEK_SET);
    shdr = malloc(ehdr.e_shnum * ehdr.e_shentsize);//所有的Section header
    if(!shdr){
        printf("error malloc\n");
        fclose(fp);
        return;
    }
//找到Section header的节区头表
    if(fread(shdr,ehdr.e_shentsize,ehdr.e_shnum,fp) != ehdr.e_shnum){
        printf("Section header error\n");
        free(shdr);
        fclose(fp);
        return;
    }
    Elf32_Shdr *shstrtab_shdr = &shdr[ehdr.e_shstrndx];//索引shstr
    if((shstrtab = malloc(shstrtab_shdr->sh_size))==NULL){//获取内容
        printf("shstrtab error\n");
        fclose(fp);
        free(shdr);
        return;
    }
    fseek(fp,shstrtab_shdr->sh_offset,SEEK_SET);
    if(fread(shstrtab,shstrtab_shdr->sh_size,1,fp) != 1){
        printf("shstrtab find error\n");
        fclose(fp);
        free(shdr);
        free(shstrtab);
        return;
    }
//遍历寻找.symtab .strtab
    for(int i=0;i< ehdr.e_shnum;i++){
       // printf("shstrtab : %s  shdr[i].sh_name %d\n",shstrtab,shdr[i].sh_name);
        char *Section_name = shstrtab + shdr[i].sh_name;//偏移shdr[i].sh_name的大小的位置
        //printf("Section_name : %s\n",Section_name);
        if(strcmp(Section_name,".symtab")==0){
            if((symtab = malloc(shdr[i].sh_size))==NULL){
                printf("symtab malloc\n");
                fclose(fp);
                free(shdr);
                free(shstrtab);
                return;
            }
            fseek(fp,shdr[i].sh_offset,SEEK_SET);
            if(fread(symtab,shdr[i].sh_size,1,fp)!=1){
                printf("fread symtab error\n");
                free(symtab);
                symtab = NULL;
                continue;
            }
            symtab_size = shdr[i].sh_size / sizeof(Elf32_Sym);
        }
        else if(strcmp(Section_name,".strtab")==0){
           if ((strtab = malloc(shdr[i].sh_size)) == NULL) {
                perror("malloc");
                free(shstrtab);
                free(shdr);
                if (symtab) free(symtab);
                fclose(fp);
                return;
            }
            fseek(fp, shdr[i].sh_offset, SEEK_SET);
            if (fread(strtab, shdr[i].sh_size, 1, fp) != 1) {
                perror("fread .strtab");
                free(strtab);
                strtab = NULL;
                continue;
            }
        }
    }
    symbol_count =0;
    symbol_data = malloc(symtab_size *sizeof(symbol_str));
    if(!symbol_data){
        printf("error\n");
    }
    for(int i=0;i<symtab_size;i++){
        Elf32_Sym *sym = &symtab[i];
        unsigned char type = ELF32_ST_TYPE(sym->st_info);
        if (type == STT_FUNC && sym->st_name != 0) {  // st_name=0 表示无名符号
            const char *name = strtab + sym->st_name;
            symbol_data[symbol_count].name = malloc(strlen(name) + 1);
        if (!symbol_data[symbol_count].name) {
            perror("malloc");
            exit(1);
        }
            strcpy(symbol_data[symbol_count].name,name);
            symbol_data[symbol_count].addr = sym->st_value;
            symbol_data[symbol_count].size = sym->st_size;
            symbol_data[symbol_count].info = sym->st_info;
            symbol_count++;
           // printf("0x%08x:  - name %s size :%x\n", symbol_data[i].addr,symbol_data[i].name,symbol_data[i].size);
        }
    }

    free(shstrtab);
    free(shdr);
    free(symtab);
    free(strtab);
    fclose(fp);
}
void call_ftrace_printf(vaddr_t pc,vaddr_t dnpc)
{
    ++depth;
   
    
    for(int i=0;i<sizeof(symbol_data);i++){
       // printf("symbol_data[i] addr :0x%08x\n",symbol_data[i].addr);
        if((dnpc>= symbol_data[i].addr)&&(dnpc <( symbol_data[i].addr + symbol_data[i].size))){
            printf(FMT_PADDR ": %*scall [%s@"FMT_PADDR"]\n",pc,(depth-1)*2,"",symbol_data[i].name,dnpc);
            return;
        }
        
    }
    printf(FMT_PADDR ": %*scall [%s@"FMT_PADDR"]\n",pc,(depth-1)*2,"","???",dnpc);
    return;
    
}
void ret_ftrace_printf(vaddr_t pc){
    --depth;
    for(int i=0;i<symbol_count;i++){
        if((pc>= symbol_data[i].addr)&&(pc <( symbol_data[i].addr + symbol_data[i].size))){
             printf(FMT_PADDR ": %*sret [%s]\n",pc,(depth-1)*2,"",symbol_data[i].name);
             return;
        }
    }
    printf(FMT_PADDR ": %*sret [%s]\n",pc,(depth-1)*2,"","???");
    return;

}