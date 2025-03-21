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

/* We use the POSIX regex functions to process regular expressions.
 * Type 'man regex' for more information about POSIX regex functions.
 */
#include <math.h>
#include <regex.h>
long eval(int p,int q);
void hex(char *con);
enum {
  TK_NOTYPE = 256, TK_EQ,TK_NUM=1,TK_AND,TK_OR,TK_NOT,TK_ACRG,TK_H=0,

  /* TODO: Add more token types */

};

static struct rule {
  const char *regex;
  int token_type;
} rules[] = {

  /* TODO: Add more rules.
   * Pay attention to the precedence level of different rules.
   */

  {" +", TK_NOTYPE},    // spaces
  {"\\+", '+'},         // plus
  {"==", TK_EQ},		// equal
  {"\\-", '-'},
  {"\\*", '*'},
  {"\\/", '/'},
  {"\\(", '('},
  {"\\)", ')'},
  {"\\&", TK_AND},
  {"\\|", TK_OR},
  {"\\~", TK_NOT},
  {"\\$[0-9raspgptp]+",TK_ACRG},
  {"0[xX][0-9a-fA-F]+",TK_H},
  {"[0-9]+",TK_NUM},
 };

#define NR_REGEX ARRLEN(rules)

static regex_t re[NR_REGEX] = {};

/* Rules are used for many times.
 * Therefore we compile them only once before any usage.
 */
void init_regex() {
  int i;
  char error_msg[128];
  int ret;

  for (i = 0; i < NR_REGEX; i ++) {
    ret = regcomp(&re[i], rules[i].regex, REG_EXTENDED);
    if (ret != 0) {
      regerror(ret, &re[i], error_msg, 128);
      panic("regex compilation failed: %s\n%s", error_msg, rules[i].regex);
    }
  }
}

typedef struct token {
  int type;
  char str[32];
} Token;

static Token tokens[32] __attribute__((used)) = {};
static int nr_token __attribute__((used))  = 0;

void w_tokens(char *type,int len,int single){
		if(single==TK_NUM){
			tokens[nr_token].type=TK_NUM;
			strncpy(tokens[nr_token].str,"aa",32);
			//printf("now str %s\n",tokens[nr_token].str);
			for(int j=0;j<len;j++){	
			tokens[nr_token].str[j]=*(type+j);
			}
			nr_token++;
		}
		else if(single==TK_H){
			//printf("检测成功\n");
			tokens[nr_token].type=single;
			nr_token++;
			hex(type);
		}
		else {
		tokens[nr_token].type=single;
		nr_token++;
	}
}
static bool make_token(char *e) {
  int position = 0;
  int i;
  regmatch_t pmatch;

  nr_token = 0;

  while (e[position] != '\0') {
    /* Try all rules one by one. */
    for (i = 0; i < NR_REGEX; i ++) {
      if (regexec(&re[i], e + position, 1, &pmatch, 0) == 0 && pmatch.rm_so == 0) {
        char *substr_start = e + position;
        int substr_len = pmatch.rm_eo;

        Log("match rules[%d] = \"%s\" at position %d with len %d: %.*s",
            i, rules[i].regex, position, substr_len, substr_len, substr_start);

        position += substr_len;

        /* TODO: Now a new token is recognized with rules[i]. Add codes
         * to record the token in the array `tokens'. For certain types
         * of tokens, some extra actions should be performed.
         */
		printf("len : %d\n",substr_len);
        switch (rules[i].token_type) {
		case TK_NOTYPE: 
          default:w_tokens(substr_start,substr_len,rules[i].token_type);
        }

        break;
      }
    }

    if (i == NR_REGEX) {
      printf("no match at position %d\n%s\n%*.s^\n", position, e, position, "");
      return false;
    }
  }

  return true;
}
int negative_indication(){//负号预处理
	int cnt=0;
	  //通过循环将负号放入str
	  for(int i=0;i<nr_token;i++){
		  //判断负号
		  //情况1负号在首位
		  if(i==0&&tokens[i].type=='-'){
			  cnt++;
			  if(tokens[i+1].type==TK_NUM){
			  	for(int j=strlen(tokens[i+1].str)-1;j>=0;j--){
				  	tokens[i+1].str[j+1]=tokens[i+1].str[j];
			  	}
			  	tokens[i+1].str[0]='-';
			  }
			  //首位双负号
			  if(tokens[i].type=='-'&&tokens[i+1].type=='-'){
				  cnt++;
			  }
		  }
		  //情况2符合不在首位
		  else if(i>cnt&&tokens[i].type=='-'&&(tokens[i-1].type!=TK_NUM&&tokens[i-1].type!='-')){
			cnt++;
			//printf("判断负号成功,位于%d\n",i);
			//printf("输出负号数字长度%ld\n",strlen(tokens[i+1].str));
			  for(int j=strlen(tokens[i+1].str)-1;j>=0;j--){//将负号写入数字数组
					tokens[i+1].str[j+1]=tokens[i+1].str[j];
			  }
				tokens[i+1].str[0]='-';
				for(int k=i-1;k>=0;k--){
					tokens[k+1].type=tokens[k].type;
					if(tokens[k].type==TK_NUM){
						strncpy(tokens[k+1].str,tokens[k].str,32);
					}
				}
		  }
		  //情况3非首位的双符号
		  else if(i>cnt&&tokens[i].type=='-'&&tokens[i-1].type=='-'){
			  for(int k=i-2;k>=0;k--){
				  tokens[k+1].type=tokens[k].type;
				  if(tokens[k].type==TK_NUM){
					  strncpy(tokens[k+1].str,tokens[k].str,32);
				  }
			  }
			tokens[i].type='+';
			cnt++;
		  }
	  }
	  printf("cnt:%d\n",cnt);
	  return cnt;
}
int Deconstruction(){//解引用预处理
	int cnt=0;
	return cnt;
}
void hex(char *con){//十六进制转十进制预处理
	//printf("成功进入\n");
	//printf("hex的nr_token=%d\n",nr_token);
	long int sum=0;
	char *endptr;
	for(int i=0;i<nr_token;i++){
		//printf("未找到\n");
		//printf("此时的字符%d\n",tokens[i].type);
		if(tokens[i].type==TK_H){
			sum=strtol(con,&endptr,0);
			tokens[i].type=TK_NUM;
			//printf("成功调用，十六进制转化为十进制%ld\n",sum);
			snprintf(tokens[i].str,32,"%ld",sum);
			break;
		}
	}
}
word_t expr(char *e, bool *success) {
  if (!make_token(e)) {
    *success = false;
    return 0;
  }
  else {
	 int position_start=negative_indication();
	return eval(position_start,nr_token-1);
  }
  return 0;
}
int check_parentheses(int p,int q)
{
	int cnt=0;
//对表达式进行遍历
	for(int i=p;i<=q;i++){
		if(tokens[i].type=='(') cnt++;
		else if(tokens[i].type==')')cnt--;
		if(cnt==0 &&i<q) return -1; // 防止"(4 + 3)) * ((2 - 1)"(4 + 3) * (2 - 1)的情况
	}
	if(cnt!=0) return -1;//括号数不匹配
	if(tokens[p].type!='('||tokens[q].type!=')') return -1;//只要首或尾没有括号，那么表达式就不需要进行去括号操作
	return 1;
	
}
int main_operator(int p,int q){
	int i;
	int cnt=0;
	int cnt_scan=0;
	int ret=0;
	for(int j=p;j<=q;j++){
		if(tokens[j].type=='(') cnt_scan++;
		while (cnt_scan!=0){
			j++;
			if(tokens[j].type=='(') cnt_scan++;
			else if(tokens[j].type==')') cnt_scan--;
		}
		if(tokens[j].type=='+'||tokens[j].type=='-'){
			ret=1;
		}
		else if(tokens[j].type=='*'||tokens[j].type=='/'){
			ret=2;
		}
}
	for(i=p;i<=q;i++){
		if(tokens[i].type=='(') cnt++;
		while (cnt!=0) {
			i++;
			if(tokens[i].type=='(') {
				cnt++;
			}
			else if(tokens[i].type==')') {
				cnt--;
			}
		}
		if(tokens[i].type=='+'||tokens[i].type=='-'){
			return i;
		}
		else if((ret==2)&(tokens[i].type=='*'||tokens[i].type=='/')){
			return i;
		}
	}
	return 0;
}

long eval(int p,int q){
	if (p > q) {
    /* Bad expression */
		//printf("%d\n",nr_token);
		//printf("now p=%d,q=%d\n",p,q);
		assert(0);
  }
  else if (p == q) {
    /* Single token.
     * For now this token should be a number.
     * Return the value of the number.
     */
	  //printf("当前数字%d\n",atoi(tokens[p].str));
	 return atoi(tokens[p].str);
  }
  else if (check_parentheses(p, q) == 1) {
    return eval(p + 1, q - 1);//进行去括号操作
  }
  else {
	  //printf("op 's p=%d,q=%d\n",p,q);
    int op = main_operator(p,q);
    uint32_t val1 = eval(p, op - 1);
    uint32_t val2 = eval(op + 1, q);


    switch (tokens[op].type) {
      case '+': 
		  printf("'+' now val1=%d,val2=%d\n",val1,val2);
		  return val1 + val2;
      case '-':
		  printf("'-' now val1=%d,val2=%d\n",val1,val2);
		  return val1 - val2;
      case '*':
		  printf("'*' now val1=%d,val2=%d\n",val1,val2);
		  return val1 * val2;
	  case '/':	if(val2==0){
					printf("val1 =%d p=%d q=%d\n",val1,p,q);
					printf("error,除数为0，不存在\n");
					assert(0);
					return 0;
				}
				return val1 / val2;break;
      default: assert(0);
    }  
  }
}
