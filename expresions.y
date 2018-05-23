

    /* Reverse polish notation calculator.  */

%{
       #define YYSTYPE double
       #include <math.h>
       #include <stdio.h>
       int yylex (void);
       void yyerror (char const *);
%}

%token NUM
%left 'o''r''a''n''d'
%left '>' '<'
%left '='
%left '+' '-'
%left '*' '/' '%'
%right '^'
%% /* Grammar rules and actions follow.  */

input:    /* empty */
             | input line
;

line:     '\n'
        | exp '\n'      { printf ("Sintacticamente correcto\n"); }
        ;

exp:      NUM           
             | exp '+' exp   
             | exp '-' exp   
             | exp '*' exp               
             | exp '/' exp
             | exp '%' exp
             | exp '^' exp
             | exp '>' exp  
             | exp '<' exp
             | exp '<''=' exp
             | exp '>''=' exp
             | exp 'o''r' exp
             | exp 'a''n''d' exp
             | '(' exp ')'
             | '[' exp ']'
             | '{' exp '}'
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