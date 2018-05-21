typedef union {
   int pos;
   int ival;
   float fval;
   string sval;
} YYSTYPE;
#define	ID	258
#define	STRING	259
#define	INT	260
#define	DESPLIEGA 261
#define SI        262
#define OTRO      263
#define AND       264 
#define OR        265 
#define NOT       266 
#define DIFER     267 
#define IGUAL     268 
#define ENTERO    269
#define FLOAT     270
extern YYSTYPE yylval;
