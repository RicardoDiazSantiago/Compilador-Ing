

%{
#include <string.h>
#include "util.h"
#include "y.tab.h"
#include "errormsg.h"

int charPos=1;

extern YYSTYPE yylval;

int yywrap(void)
{
 charPos=1;
 return 1;
}


void adjust(void)
{
 EM_tokPos=charPos;
 charPos+=yyleng;
}

//char bufer[256];char *apbufer;

#define MAX_STR_CONST   256
char string_buf[MAX_STR_CONST];
char *string_buf_ptr;

%}

ID [A-Z|_|@][A-Z|0-9|_@]*
%x comentario
%%

" "      {adjust(); continue;}
\n       {adjust(); EM_newline(); continue;}

entero     {adjust(); return ENTERO;}

[0-9]+   {adjust(); yylval.ival=atoi(yytext); return INT;}

"/""/"[^/\n]*          {printf("Comentario tipo C++");}

  /*<<EOF>> {printf("\nFin de Archivo encontrado."); exit(0); }*/

.        {adjust(); EM_error(EM_tokPos,"token ilegal");}

{ID}	       {strcpy(u.s,yytext); return ID;}
