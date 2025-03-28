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

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <assert.h>
#include <string.h>
// this should be enough
static char buf[65536] = {};
static char code_buf[65536 + 128] = {}; // a little larger than `buf`
static char *code_format =
"#include <stdio.h>\n"
"int main() { "
"  unsigned result = %s; "
"  printf(\"%%u\", result); "
"  return 0; "
"}";
#define MAX_cnt 5//设置大小，防止无限递归
void space();
static void gen_num(){
	int num=rand() %100;
	char num_str[50];
	sprintf(num_str,"%d",num);
	strcat(buf,num_str);
	space();
}
static void gen_no_zero_num(void)//保证除法下一个数不为0
{
  char num_str[50];
  int number=rand()%100+1;
  sprintf(num_str, "%d", number);
  strcat(buf, num_str);
  space();
}
static void gen(char const *c){
	strncat(buf,c,1);
}
void space(){
	for(int i=rand() %3;i>=0;i--){
		gen(" ");
	}
}
static void gen_rand_op() {
  char *ops[]={"+","-","*","/"};
  int op_index = rand() % (sizeof(ops) / sizeof(ops[0]));
  gen(ops[op_index]);
  if(strcmp(ops[op_index], "/")==0){
    gen_no_zero_num(); //如果是除法，确保下一个数是非零
  }else{
    gen_num();
}
}
static void gen_rand_expr(int cnt) {
	if(cnt>=MAX_cnt){
		gen_num();
		return;
	}
   switch(rand()%3){
    case 0:
		size_t len_num=strlen(buf);
		if(len_num==0||buf[len_num-1]=='+'||buf[len_num-1]=='-'
			||buf[len_num-1]=='*'||buf[len_num-1]=='*'||buf[len_num-1]=='('){
			gen_num();
		}
      break;
    case 1: 
      {
        size_t len=strlen(buf);
        if(len==0 || buf[len - 1]=='(' ||
            buf[len - 1]=='+' || buf[len - 1]=='-' ||buf[len - 1]=='*' || buf[len - 1]=='/'){
          if(rand()%2){
            gen("(");
            gen_rand_expr(cnt+1);
            gen(")");
          }else{
            gen_rand_expr(cnt+1); 
          }
        }else{//如果表达式出现右括号，则先生成运算符，再继续生成表达式
          gen_rand_op();
          gen_rand_expr(cnt+1);
        }
      }
      break;
    default: 
      gen_rand_expr(cnt+1);
      gen_rand_op();
      gen_rand_expr(cnt+1);
      break;
  }
}

int main(int argc, char *argv[]) {
  int seed = time(0);
  srand(seed);
  int loop = 1;
  if (argc > 1) {
    sscanf(argv[1], "%d", &loop);
  }
  int i;
  for (i = 0; i < loop; i ++) {
	memset(buf,0,sizeof(buf));
	gen_rand_expr(0);    
    sprintf(code_buf, code_format, buf);

    FILE *fp = fopen("/tmp/.code.c", "w");
    assert(fp != NULL);
    fputs(code_buf, fp);
    fclose(fp);

    int ret = system("gcc /tmp/.code.c -Wall -Werror -o /tmp/.expr");
	if (ret != 0) {
		i--;
		continue;
	}

    fp = popen("/tmp/.expr", "r");
    assert(fp != NULL);
    uint32_t result;
    ret = fscanf(fp, "%u", &result);
    pclose(fp);

    printf("%u_%s\n", result, buf);
  }
  return 0;
}
