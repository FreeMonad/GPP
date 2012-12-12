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

static void svOutC(char c);

static void svOutS(const char *s);

static void svOutF(void);

void quit(long exitcode);

void help(const char *s);

void parisv_init(void);

char *evaluate(const char *in);

int parisv_nb_hist(void);
