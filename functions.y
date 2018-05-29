

    /* Reverse polish notation calculator.  */

%{
       #define YYSTYPE double
       #include <math.h>
       #include <stdio.h>
       int yylex (void);
       void yyerror (char const *);
%}

%token INT ID

/* Tipos de datos aceptados */
tipo:   ENTERO
;

/* Estructura de una funcion <tipo> <nombre>(<argumentos>){<cuerpo>}  */
function: treturn name '(' args ')' '{' body '}'
;

/* Tipo de dato que retornara la funcion <tipo> */
treturn: tipo
;

/* Nombre de una funcion <nombre>*/
name: ID
;

/* Declaracion de una variable <tipo><nombre>, servira para los argumentos de la funcion
   
*/
declaracion: tipo name
;

/* Asignacion del valor a una variable, servira para el cuerpo de la funcion, en la
   seccion de declaraciones y asignaciones. 
*/
asignacion:   name '=' INT
            | name '=' exp
;

/* Asignacion y declaracion en un solo paso. */
asignacion_declaracion:   declaracion '=' INT
                        | declaracion '=' exp
; 

/* Argumentos de la funcion, utilizamos la estructura de declaracion anterior. */
args: 
      | declaracion 
      | argsList
;

/* Lista de argumentos en caso de que la fucion tenga mas de un argumento. */
argsList:   declaracion ',' argsList
          | declaracion 
;

/* Cuerpo de la funcion. <declaraciones_asignaciones><estructuras_control><return> */
body: declaraciones eControl retorno
;

/* Puede no haber declaraciones y/o asignaciones o puede haber una lista de 
   declaraciones y/o asignaciones. */
declaraciones: 
              | decYAsigList 
              | decYAsigList decYAsigList
;

/* Si hay declaraciones y/o asignaciones, puede solo haber una declaracion o asignacion.
   Puede haber declaraciones y/o asignaciones en una sola linea.
*/
decYAsigList:   decOdecAsig ';'
              | decOdecAsig ',' nameOAsigList ';'
;

/* La seccion de declaraciones y asignaciones puede comenzar con una declaracion o
   con una declaracion y asignacion.
*/
decOdecAsig:   declaracion
             | asignacion_declaracion
;

/* La lista de declaraciones y/o asignaciones puede contener una o mas declaraciones y/o
   asignaciones.
*/
nameOAsigList:   arq
               | arq ',' nameOAsigList
;

arq:    name
      | asignacion
;

/* Las estructura de control puede ser bifurcacion y ciclos.
   Puede haber cero o una o mas estructuras de control en el cuerpo de la
   funcion.
*/
eControl: bifOCiclo bifOCiclo
;

bifOCiclo: 
            | BIFURCACION
            | CICLO
            | eControl
;

/* Tiene que haber una sentencia de return en la funcion.
   Se puede retornar un numero, el nombre de una variable o solo la sentencia return.
*/   
retorno:   RETURN INT
         | RETURN name
         | RETURN;

%% /* Grammar rules and actions follow.  */


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
