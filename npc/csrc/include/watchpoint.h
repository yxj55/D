#ifndef __WATCHPOINT_H__
#define __WATCHPOINT_H__

#include <common.h>
typedef struct watchpoint {
  int NO;
  struct watchpoint *next;
  char *expr;
  uint32_t answer;
  /* TODO: Add more members if necessary */

} WP;

void init_wp_pool();
WP *new_wp(char *expr_str,uint32_t answer);
void free_wp(int no);
void printf_wp();

#endif
