/* parisrv.h */

#include <stdio.h>
#include <stdlib.h>
#include <setjmp.h>
#include <errno.h>
#include <string.h>
#include <strings.h>
#include <pari/pari.h>
#include <sys/types.h>

void gp_err_recover(long numerr);

static void srvOutC(char c);

static void srvOutS(const char *s);

static void srvOutF(void);

void parisrv_quit(long exitcode);

void help(const char *s);

void parisrv_init(void);

char *parisrv_eval(const char *in);

int parisrv_nb_hist(void);

void parisrv_close(void);
