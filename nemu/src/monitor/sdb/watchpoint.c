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

#include "sdb.h"
#include <stdio.h>
#include <string.h>
#include <assert.h>
#define NR_WP 32

typedef struct watchpoint {
  int NO;
  struct watchpoint *next;
  char *expr;
  uint32_t answer;
  /* TODO: Add more members if necessary */

} WP;

static WP wp_pool[NR_WP] = {};
static WP *head = NULL, *free_ = NULL;
void init_wp_pool() {
  int i;
  for (i = 0; i < NR_WP; i ++) {
    wp_pool[i].NO = i;
    wp_pool[i].next = (i == NR_WP - 1 ? NULL : &wp_pool[i + 1]);
  }

  head = NULL;
  free_ = wp_pool;
}
WP *new_wp(char *expr_str,uint32_t answer){
	if(free_==NULL) {
		printf("无空闲节点\n");
		assert(0);}//无空闲节点
	WP *new=free_;
	free_=free_->next;
	//printf("此时free_no%d\n",free_->NO);
	new->answer=answer;
	//printf("answer:%d\n",answer);
	//printf("new->answer:%d\n",new->answer);
	new->expr=strdup(expr_str);
	//printf("expr_str:%s\n",expr_str);
	//printf("new->expr:%s\n",new->expr);
	new->next=NULL;
	if(head==NULL) head=new;//新节点为头
	else{
	new->next=head;//不以带头节点的头插
	head=new;
	}
	//printf("head->expr%s\n",head->expr);
	return new;
}
void free_wp(int no){
	if(head==NULL){
		printf("监视点目前为空\n");
		return;
	}
	WP *p=head;//获取头（已使用）的链表
	if(p->NO==no)//判断第一个节点是否为所需
	{
		head=head->next;
		p->next=free_;//不以带头结点的头插
		free_=p;
		printf("已删除节点%d\n",no);
		return;
	}
	else {//第一个未匹配，开始遍历head
		WP *q=head;
		p=p->next;//使q能链接上
		while(p!=NULL){
			if(p->NO==no){
					q->next=p->next;
					p->next=free_;
					free_=p;
					printf("已删除监视点%d\n",no);
					return;
			}
			else{
				q=q->next;
				p=p->next;
			}
		}
	}
		printf("不存在该监视点%d\n",no);
		return;
}
void printf_wp(){
	//printf("head-expr%s\n",head->expr);
	WP *p=head;
	if(p==NULL){
		printf("监视点目前为空\n");
		return;
	}
	else {
		while(p!=NULL){
		printf("expr:%s\n",p->expr);
		printf("NO:%d \texpr:%s \tanswer:%u \t0x%08x\n",p->NO,p->expr,p->answer,p->answer);
		p=p->next;
		}
		return;
	}
	return;
}
int update_watchpoint(){
	int single=0;
	if(head==NULL){
		return 0;
	}
	char *str_EQ="==";
	char *str_pc="$pc";
	WP *p=head;
	bool success=true;
	//uint32_t new_answer=expr(p->expr,&success);
	if(success==false){
		printf("wrong expression:%s\n",p->expr);
		assert(0);
	}
	while(p!=NULL){
		uint32_t new_answer=expr(p->expr,&success);
		//printf("p->expr:%s\n",p->expr);
		//printf("new_answer:%d\n",new_answer);
		if(strstr(p->expr,str_EQ)!=NULL){
			//printf("进入成功\n");
			if(strstr(p->expr,str_pc)!=NULL){
				//printf("进入成功2.0\n");
				if(new_answer==1){
				//	printf("返回成功\n");
					printf(ANSI_FG_YELLOW"Stop!\n");

					printf(ANSI_NONE"No:%d  expr:%s\n",p->NO,p->expr);
					p->answer=new_answer;
					single=1;
				}
			}
		}
		
		else if(p->answer!=new_answer){
			printf(ANSI_FG_YELLOW"Change!\n");

			printf(ANSI_NONE"NO:%d  expr:%s  now answer:0x%08x\n",p->NO,p->expr,new_answer);
			printf("old answer:%u\n",p->answer);
			printf("new answer:%u\n",new_answer);
			p->answer=new_answer;
			single=1;
		}
		p=p->next;
	}
	return single;
}
/* TODO: Implement the functionality of watchpoint */

