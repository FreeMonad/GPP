/**
 *-----------------------------------------------
 * parisrv.c - wrapper around libpari.
 *-----------------------------------------------
 * Copyright (C) 2012, Charles Boyd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "parisrv.h"

/** number of bytes to initialize pari stack with */
size_t parisrv_stack_size = 4000000;

/** maximum value for the prime table */
ulong parisrv_maxprime = 500509;

/** Error handling */
jmp_buf env;

void gp_err_recover(long numerr) { longjmp(env, numerr); }

static char *srvStr;

static pari_stack s_srvStr;

static void
srvOutC(char c) 
{ 
  long n = pari_stack_new(&s_srvStr); 
  srvStr[n] = c;
}

static void
srvOutS(const char *s) 
{
  while(*s) 
    srvOutC(*s++); 
}

static void
srvOutF(void) { }

static PariOUT srvOut = {srvOutC, srvOutS, srvOutF};

void 
parisrv_quit(long exitcode) 
{
  parisrv_close();
}

void
help(const char *s)
{
  entree *ep = is_entry(s);
  if (ep && ep->help)
    pari_printf("%s\n",ep->help);
  else
    pari_printf("Function %s not found\n",s);
}

void 
parisrv_init(void)
{
  
  static const entree functions_gp[]={
    {"quit",0,(void*)parisrv_quit,11,"vD0,L,","quit({status = 0}): quit, return to the system with exit status 'status'."},
    {"help",0,(void*)help,11,"vr","help(fun): display help for function fun"},
    {NULL,0,NULL,0,NULL,NULL}};
  
  pari_init(parisrv_stack_size, parisrv_maxprime);
  pari_add_module(functions_gp);
  cb_pari_err_recover = gp_err_recover;
  pari_stack_init(&s_srvStr,sizeof(*srvStr),(void**)&srvStr);
  
  pariOut=&srvOut;
  pariErr=&srvOut;

}

char 
*parisrv_eval(const char *in) 
{

  if(setjmp(env) != 0) {
    printf("Error");
    return "";
  }

  s_srvStr.n=0;
  avma=top;

  volatile GEN z = gnil;
  CATCH(CATCH_ALL)
  {
    srvOutS(pari_err2str(global_err_data));
  } TRY {
    z = gp_read_str(in);
  } ENDCATCH;
 
  if (z != gnil) 
  {
      char *out;
      pari_add_hist(z);
      if (in[strlen(in)-1]!=';') 
	{
	  out = GENtostr(z);
	  srvOutS(out);
	}
  }
  srvOutC(0);
  return srvStr;
}

int
parisrv_nb_hist() { return pari_nb_hist(); }

void
parisrv_close() { pari_close(); }
