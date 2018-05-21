

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

/* Condiciones de arranque */
%x comentario
%x cadena
%%

" "      {adjust(); continue;}
\n       {adjust(); EM_newline(); continue;}

entero     {adjust(); return ENTERO;}

[0-9]+   {adjust(); yylval.ival=atoi(yytext); return INT;}

"/""/"[^/\n]*          {printf("Comentario tipo C++");}

		/* Inicio de condición de arranque CADENAS ******************************/
\"              {
			adjust(); string_buf_ptr = string_buf; BEGIN(cadena);
		}

<cadena>\"		{		/* Comillas que cierran: Fin de cadena */
					adjust();
					BEGIN(INITIAL);
					/* Devuelve el valor para el analizador sintáctico */
					*string_buf_ptr = '\0';
					yylval.sval=String(string_buf);
					/* Devuelve el token */
					return STRING;
                }

<cadena>\n		{/* Salto de linea */
                   /* error - cadena constante sin finalizar */
                   /* genera un mensaje de error */
				}

<cadena>\\[0-7]{1,3}	{		/* Secuencias de escape en octal */
                   			adjust();
		                   	int resultado;
                   			(void) sscanf( yytext + 1, "%o", &resultado );
                   			/* error: constante fuera de rango */
                   			if (resultado > 0xff) *string_buf_ptr++ = resultado;
                   		}

<cadena>\\[0-9]+	{			/* Secuencias de escape en octal fuera del rango */
						/* genera un error - secuencia de escape errónea;
						* algo como '\48' o '\0777777'
	                    */
                   	}

 			/* Secuencias de escape */
<cadena>\\n		{adjust(); *string_buf_ptr++ = '\n';}
<cadena>\\t 	{adjust(); *string_buf_ptr++ = '\t';}
<cadena>\\r 	{adjust(); *string_buf_ptr++ = '\r';}
<cadena>\\b 	{adjust(); *string_buf_ptr++ = '\b';}
<cadena>\\f		{adjust(); *string_buf_ptr++ = '\f';}

<cadena>\\(.|\n)	{adjust(); EM_newline(); *string_buf_ptr++ = yytext[1];}

<cadena>[^\\\n\"]+	{
						adjust();
						char *yptr = yytext;
						while ( *yptr )
							*string_buf_ptr++ = *yptr++;
                   }
		/* Fin de condición de arranque CADENAS ******************************/


  /*<<EOF>> {printf("\nFin de Archivo encontrado."); exit(0); }*/

.        {adjust(); EM_error(EM_tokPos,"token ilegal");}

{ID}	       {strcpy(u.s,yytext); return ID;}
