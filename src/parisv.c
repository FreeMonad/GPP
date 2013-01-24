/**
 *-----------------------------------------------
 * parisv.c - wrapper around libpari.
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

#include "parisv.h"

/** number of bytes to initialize pari stack with */
size_t parisv_stack_size = 4000000;

/** maximum value for the prime table */
ulong parisv_maxprime = 500509;

/** Error handling */
jmp_buf env;

void gp_err_recover(long numerr) { longjmp(env, numerr); }

static char *svStr;

static pari_stack s_svStr;

static void
svOutC(char c) 
{ 
  long n = pari_stack_new(&s_svStr); 
  svStr[n] = c;
}

static void
svOutS(const char *s) 
{
  while(*s) 
    svOutC(*s++); 
}

static void
svOutF(void) { /* EMPTY */ }

static PariOUT svOut = {svOutC, svOutS, svOutF};

void 
quit(long exitcode) 
{
  pari_printf("Bye!");
  pari_close();
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
version(void)
{
  const char *version = GENtostr(pari_version());
  pari_printf("%s",version);
}

void 
parisv_init(void)
{
  
  static const entree functions_gp[]={
    {"quit",0,(void*)quit,11,"vD0,L,","quit({status = 0}): quit, return to the system with exit status 'status'."},
    {"help",0,(void*)help,11,"vr","help(fun): display help for function fun"},
    {"version",0,(void*)version,11,"v","version(): display the version information for Pari/GP"},
    {NULL,0,NULL,0,NULL,NULL}};
  
  pari_init(parisv_stack_size, parisv_maxprime);
  pari_add_module(functions_gp);
  cb_pari_err_recover = gp_err_recover;
  pari_stack_init(&s_svStr,sizeof(*svStr),(void**)&svStr);
  
  pariOut=&svOut;
  pariErr=&svOut;
}

char 
*evaluate(const char *in) 
{

  if(setjmp(env) != 0) {
    printf("Error");
    return "";
  }

  s_svStr.n=0;
  avma=top;

  volatile GEN z = gnil;
  pari_CATCH(CATCH_ALL)
  {
    svOutS(pari_err2str(__iferr_data));
  } pari_TRY {
    z = gp_read_str(in);
  } pari_ENDCATCH;
  
  if (z != gnil) 
  {
      char *out;
      pari_add_hist(z);
      if (in[strlen(in)-1]!=';') 
	{
	  out = GENtostr(z);
	  svOutS(out);
	}
  }
  svOutC(0);
  return svStr;
}

void 
gpp_escape(char *c)
{
  process_esc(c);
}

char
*parisv_type(const char *in)
{
  volatile GEN z = gnil;
  const char *type_str;

  pari_CATCH(CATCH_ALL)
  {
    svOutS(pari_err2str(__iferr_data));
  } pari_TRY {
    z = gp_read_str(in);
  } pari_ENDCATCH;

  if (z != gnil) {
    long pari_type = typ(z);
    type_str = type_name(pari_type);
    return type_str;
  } else { 
    return "t_UNDEF";
  }
}

int
parisv_nb_hist() { return pari_nb_hist(); }

/* EOF */
