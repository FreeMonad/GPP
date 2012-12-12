/* parisrv.i */

%module parisv
%{
#include <stdio.h>
#include <stdlib.h>
#include <setjmp.h>
#include <pari/pari.h>

#undef warner

  void parisv_init(void);
  char *evaluate(const char *in);
  void quit(void);
  int parisv_nb_hist(void);
  %}

#undef warner

void parisv_init(void);
char *evaluate(const char *in);
void quit(void);
int parisv_nb_hist(void);
