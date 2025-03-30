/***************************************************************************************
* Copyright (c) 2014-2024 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <isa.h>
#include <cpu/cpu.h>
#include <readline/chardefs.h>
#include <readline/readline.h>
#include <readline/history.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include "sdb.h"
#include <memory/vaddr.h>
#include "watchpoint.h"
static int is_batch_mode = false;

void init_regex();
void init_wp_pool();
/* We use the `readline' library to provide more flexibility to read from stdin. */
static char* rl_gets() {
  static char *line_read = NULL;

  if (line_read) {
    free(line_read);
    line_read = NULL;
  }

  line_read = readline("(nemu) ");

  if (line_read && *line_read) {
    add_history(line_read);
  }

  return line_read;
}

static int cmd_c(char *args) {
  cpu_exec(-1);
  return 0;
}
static int cmd_si(char *args){
	char *arg=strtok(NULL," ");
	int step=0;
	if(arg==NULL)
	{
		cpu_exec(1);
		return 0;
	}
	sscanf(arg,"%d",&step);
	//printf("%d\n",step);
	if(step<-1){
		printf("Error,N shoule be bigger or equal to -1(MAX) ");
		return 0;
	}
	cpu_exec(step);
	return 0;
}
static int cmd_info(char *args){
	char *arg=strtok(NULL," ");
	if(strcmp(arg,"r")==0){
		isa_reg_display();
	}
	if(strcmp(arg,"w")==0){
		printf_wp();
	}
	return 0;
}
static int cmd_x(char *args){
	char *N=strtok(NULL," ");
	char *EXPR=strtok(NULL," ");
	int scan_len;
	vaddr_t address;
	sscanf(N,"%d",&scan_len);
	sscanf(EXPR,"%x",&address);
	for(int i=0;i<scan_len;i++){
		printf("0x%x:%x\n",address,vaddr_read(address,4));
		address+=4;
	}
	return 0;
}
static int cmd_p(char *args){
	//printf("args:%s\n",args);
	char *e=args;
	bool success= true;
	printf("e:%s\n",e);
	printf("answer is:%u\n",expr(e,&success));
	return 0;
}
static int cmd_q(char *args) {
	nemu_state.state=NEMU_QUIT;
	return -1;
}
static int cmd_test(char *args){
	FILE *fp=fopen("/home/yuanxiao/ysyx-workbench/nemu/tools/gen-expr/input","r");
	char line[256];
	uint32_t expr_count=0;
	bool success=true;
	assert(fp!=NULL);
	while(fgets(line,sizeof(line),fp)){//逐行读取数据
		line[strcspn(line,"\n")]='\0';//逐个计算，匹配换行符，strcspn用于计数除了\n的字符数
		char *answer=strtok(line,"_");
		char *expression=strtok(NULL,"_");
		word_t result=expr(expression,&success);
		printf("%s\n answer:%s my_answer:%u\n",expression,answer,result);
		expr_count++;
	}
	if(success) _Log(ANSI_BG_CYAN"Success!" ANSI_NONE "   Total %u expr\n",expr_count);
  else _Log(ANSI_BG_RED "Fail!" ANSI_NONE "   Total %u expr\n",expr_count);
  fclose(fp);
  return 0;
}
static int cmd_w(char *args){
	bool success=true;
	//printf("监视点表达式%s\n",args);
	new_wp(args,expr(args,&success));
	return 0;
}
static int cmd_d(char *args){
	char *d=strtok(args," ");
	int no=atoi(d);
	free_wp(no);
	return 0;
}
static int cmd_help(char *args);

static struct {
  const char *name;
  const char *description;
  int (*handler) (char *);
} cmd_table [] = {
  { "help", "Display information about all supported commands", cmd_help },
  { "c", "Continue the execution of the program", cmd_c },
  { "q", "Exit NEMU", cmd_q },
  { "si","Single step execution",cmd_si},
  { "info","Print register",cmd_info },
  { "x","Scan memory",cmd_x},
  { "p","Expression Evaluation",cmd_p },
  {"test","test expr",cmd_test},
  {"w","create monitoring point",cmd_w},
  {"d","delete monitoring point",cmd_d},

  /* TODO: Add more commands */

};

#define NR_CMD ARRLEN(cmd_table)

static int cmd_help(char *args) {
  /* extract the first argument */
  char *arg = strtok(NULL, " ");
  int i;

  if (arg == NULL) {
    /* no argument given */
    for (i = 0; i < NR_CMD; i ++) {
      printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
    }
  }
  else {
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(arg, cmd_table[i].name) == 0) {
        printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
        return 0;
      }
    }
    printf("Unknown command '%s'\n", arg);
  }
  return 0;
}

void sdb_set_batch_mode() {
  is_batch_mode = true;
}

void sdb_mainloop() {
  if (is_batch_mode) {
    cmd_c(NULL);
    return;
  }

  for (char *str; (str = rl_gets()) != NULL; ) {
    char *str_end = str + strlen(str);

    /* extract the first token as the command */
    char *cmd = strtok(str, " ");
    if (cmd == NULL) { continue; }

    /* treat the remaining string as the arguments,
     * which may need further parsing
     */
    char *args = cmd + strlen(cmd) + 1;
    if (args >= str_end) {
      args = NULL;
    }

#ifdef CONFIG_DEVICE
    extern void sdl_clear_event_queue();
    sdl_clear_event_queue();
#endif

    int i;
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(cmd, cmd_table[i].name) == 0) {
        if (cmd_table[i].handler(args) < 0) { return; }
        break;
      }
    }

    if (i == NR_CMD) { printf("Unknown command '%s'\n", cmd); }
  }
}

void init_sdb() {
  /* Compile the regular expressions. */
  init_regex();
  /* Initialize the watchpoint pool. */
  init_wp_pool();
}
