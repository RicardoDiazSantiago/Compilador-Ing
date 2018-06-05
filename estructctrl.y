

    /* Reverse polish notation calculator.  */

%{
       #define YYSTYPE double;
       #include <math.h>
       #include <stdio.h>
       #include "tokens.h"
       #include "errormsg.h"
       #include "util.h"
       int yylex (void);
       void yyerror (char const *);
%}

%token NUM
%token IF
%token WHILE
%token FOR
%left 'o''r''a''n''d'
%left '>' '<'
%left '='
%left '+' '-'
%left '*' '/' '%'
%right '^'
%% /* Grammar rules and actions follow.  */
sentcontrol: if
            |while
            |for
;
if: IF '('exp')' '{'op'}'
;
while: WHILE '('exp')' '{'op'}'
;
for: FOR '('exp')' '{'op'}'
;
op: NUM
             | op '+' op   { $$ = $1 + $3;      }
             | op '-' op   { $$ = $1 - $3;      }
             | op '*' op   { $$ = $1 * $3;      }            
             | op '/' op   { $$ = $1 / $3;      }
             | op '%' op   
             | op '^' op   { $$ = pow ($1, $3); }
;
exp:      NUM           

             | exp '>' exp  
             | exp '<' exp
             | exp '<''=' exp
             | exp '>''=' exp
             | exp 'o''r' exp
             | exp 'a''n''d' exp
;

%%
     #include <ctype.h>
     #include <stdio.h>
     #include <math.h>

     int
     yylex (void)
     {
       int c;

       /* Skip white space.  */
       while ((c = getchar ()) == ' ' || c == '\t')
         ;
       /* Process numbers.  */
       if (c == '.' || isdigit (c))
         {
           ungetc (c, stdin);
           scanf ("%lf", &yylval);
           return NUM;
         }
       /* Return end-of-input.  */
       if (c == EOF)
         return 0;
       /* Return a single char.  */
       return c;
     }

     /* Called by yyparse on error.  */
     void
     yyerror (char const *s)
     {
       fprintf (stderr, "%s\n", s);
     }

     int main (void)
     {
       return yyparse ();
     }
