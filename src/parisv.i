/* parisrv.i */

%module parisv
%{
#include <stdio.h>
#include <stdlib.h>
#include <setjmp.h>
#undef warner
#include <pari/pari.h>

  void parisv_init(void);
  char *evaluate(const char *in);
  void quit(void);
  int parisv_nb_hist(void);
  char *parisv_type(const char *in);
  %}

#undef warner

void parisv_init(void);
char *evaluate(const char *in);
void quit(void);
int parisv_nb_hist(void);
char *parisv_type(const char *in);
