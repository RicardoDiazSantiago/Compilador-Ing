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

%x cade
%x comentario
%x comentarioCmasmas
%x listaflotantes
%x flotantes /*Agregué flotantes y enteros.*/
%x enteros
digitos [0-9] 
%%
	 int num_linea = 1;

int" " BEGIN(enteros);

<enteros>[0-9]+   {adjust(); yylval.ival=atoi(yytext); return INT;}

<enteros>","" "\t {adjust(); continue;}

<enteros>(";")|(";"\n)|(";"\t)  BEGIN(INITIAL);

float" "	BEGIN(flotantes);

<flotantes>("."{digitos}+(E|e)(\+|-){digitos}+)|({digitos}+"."(E|e)(\+|-){digitos}+)|({digitos}+"."(E|e){digitos}+)|({digitos}+"."(E|e){digitos}+)|({digitos}+"."(E|e){digitos}+)|({digitos}+"."{digitos}+(E|e)(\+|-){digitos}+)|({digitos}+"."{digitos}+(E|e){digitos}+)|({digitos}+".")|("."{digitos}+)|({digitos}+"."{digitos}+) {adjust();yylval.fval=atof(yytext);return FLOAT;} 

<flotantes>","" "\t  {adjust(); continue;}/*Una coma seguida de un espacio o muchos espacios.*/
 
<flotantes>(";")|(";"\n)|(";"\t)	BEGIN(INITIAL);

	/*Hasta aquí modifiqué.*/

" "      {adjust(); continue;}
\n       {adjust(); EM_newline(); continue;}
","      {adjust(); return ',';}
";"      {adjust(); return ';';}
"="      {adjust(); return '=';}
"("      {adjust(); return '(';}
")"      {adjust(); return ')';}
"+"      {adjust(); return '+';}
"-"      {adjust(); return '-';}
"*"      {adjust(); return '*';}
"%"      {adjust(); return '%';}
">"      {adjust(); return '>';}
":"      {adjust(); return ':';}
"<"      {adjust(); return '<';}

int     {adjust(); return INT;}
float 	   {adjust(); return FLOAT;}
despliega  {adjust(); return DESPLIEGA;}
si         {adjust(); return SI;}
otro       {adjust(); return OTRO;}

[a-zA-Z_][a-zA-Z0-9_]* {adjust(); yylval.sval=String(yytext); return ID;}

"/*"         BEGIN(comentario);

<comentario>[^*\n]*       /* come todo lo que no sea '*' */
<comentario>"*"+[^*/\n]*  /* come '*'s no seguidos por '/' */
<comentario>\n            ++num_linea;
<comentario>"*"+"/"       BEGIN(INITIAL);

"//"	BEGIN(comentarioCmasmas);
	
<comentarioCmasmas>[^/\n]* /* come todo lo que no sea \n*/
<comentarioCmasmas>"/"+[^/\n]* // come '/' seguidos por '/'
<comentarioCmasmas>\n		BEGIN(INITIAL);

\"              {adjust(); string_buf_ptr = string_buf; 
                 BEGIN(cade); }

<cade>\"        { /* se vio la comilla que cierra - todo está hecho */
                   adjust();
                   BEGIN(INITIAL);
                   *string_buf_ptr = '\0';
                   yylval.sval=String(string_buf);
                   return STRING;
                   /* devuelve un tipo de token de cadena constante y
                    * el valor para el analizador sintáctico
                    */
                   }

<cade>\n        {
                   /* error - cadena constante sin finalizar */
                   /* genera un mensaje de error */
                   }

<cade>\\[0-7]{1,3} {
                   /* secuencia de escape en octal */
                   adjust();
                   int resultado;

                   (void) sscanf( yytext + 1, "%o", &resultado );

                   if ( resultado > 0xff )
                           /* error, constante fuera de rango */

                   *string_buf_ptr++ = resultado;
                   }

<cade>\\[0-9]+ {
                   /* genera un error - secuencia de escape errónea;
                    * algo como '\48' o '\0777777'
                    */
                   }

<cade>\\n    {adjust(); *string_buf_ptr++ = '\n';}
<cade>\\t    {adjust(); *string_buf_ptr++ = '\t';}
<cade>\\r    {adjust(); *string_buf_ptr++ = '\r';}
<cade>\\b    {adjust(); *string_buf_ptr++ = '\b';}
<cade>\\f    {adjust(); *string_buf_ptr++ = '\f';}

<cade>\\(.|\n)  {adjust(); EM_newline(); *string_buf_ptr++ = yytext[1];}

<cade>[^\\\n\"]+  {
                    adjust();
                    char *yptr = yytext;
                    while ( *yptr )
                           *string_buf_ptr++ = *yptr++;
                   }


          /*<<EOF>> {printf("\nFin de Archivo encontrado."); exit(0); }*/

.        {adjust(); EM_error(EM_tokPos,"token ilegal");}

