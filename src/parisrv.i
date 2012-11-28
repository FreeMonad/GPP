/* parisrv.i */

%module parisrv
%{
#include <stdio.h>
#include <stdlib.h>
#include <setjmp.h>
#include <pari/pari.h>
  void parisrv_init(void);
  char *parisrv_eval(const char *in);
  void parisrv_close(void);
  int parisrv_nb_hist(void);
  %}

void parisrv_init(void);
char *parisrv_eval(const char *in);
void parisrv_close(void);
int parisrv_nb_hist(void);
