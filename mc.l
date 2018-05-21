

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


%x comentario
%%

" "      {adjust(); continue;}
\n       {adjust(); EM_newline(); continue;}

entero     {adjust(); return ENTERO;}

[0-9]+   {adjust(); yylval.ival=atoi(yytext); return INT;}

/***********************************************************************************
  Comentarios en C tipo '/* Comentario */'
************************************************************************************/
/* Detecta '/*' en la cadena de entrada como accion invoca a la funcion 'adjust', 
la cual asigna la posicion del token para el manejo de errores e incrementa la cuenta de la posicion en
la lectura de la cadena de entrada de acuerdo a la longitud del token leido.
Posteriormente inicializa la condicion de arranque 'comentarioc'. */

"/*"                       {adjust();BEGIN(comentarioc);} 

/* Al estar 'dentro' de la condicion de arranque 'comentarioc': Cumple la funcion de 'comerse' todos los caracteres
que no sean asteriscos (*) y nuevas lineas (\n). Invoca a la funcion 'adjust' para ajustar los conteos. */

<comentarioc>[^*\n]*       {adjust();/* come todo lo que no sea '*' */}

/* Al estar 'dentro' de la condicion de arranque 'comentarioc': Cumple la funcion de 'comerse' todos los asteriscos (*)
que no esten seguidos por '/' o por una nueva linea (\n). Invoca a la funcion 'adjust' para ajustar los conteos. */

<comentarioc>"*"+[^*/\n]*  {adjust();/* come '*'s no seguidos por '/' */}

/* Al estar 'dentro' de la condicion de arranque 'comentarioc': Si encuentra una nueva linea (\n) invoca a la funcion 
'adjust' para ajustar los conteos y a la funcion 'EM_newline' para ajustar el conteo de lineas para el manejo de
errores*/

<comentarioc>\n            {adjust();EM_newline();}

/* Al estar 'dentro' de la condicion de arranque 'comentarioc': Si encuentra una aterisco (*) o mas, seguidos 
de '/' invoca a la funcion 'adjust' para ajustar los conteos. Invoca a la condicion de arranque 'INITIAL'.
Aqui el analizador sale del reconocimiento de de comentarios*/

<comentarioc>"*"+"/"       {adjust(); BEGIN(INITIAL);}

/**********************************************************************************/

  /*<<EOF>> {printf("\nFin de Archivo encontrado."); exit(0); }*/

.        {adjust(); EM_error(EM_tokPos,"token ilegal");}
