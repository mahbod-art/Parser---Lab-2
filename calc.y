%{
#include <stdio.h>
#include <stdlib.h>
void yyerror( const char* msg );
extern int currLine;
extern int currPos;
FILE *yyin;

%}

%union{
        double dval;
        int ival;
}

%start input
%token MINS PLUS MULT DIV L_PAREN R_PAREN EQUAL END
/* sets the datatype for the token */
%token <dval> NUMBER
%type <dval> exp

/* set pemdas */
%left PLUS MINUS
%left MULT DIV

%%
input:
        | input line
        ;
line:   exp EQUAL END   { printf("\t%f\n", $1 ); }
        ;
exp:    NUMBER 		{$$ = $1; }
        | exp PLUS exp  { $$ = $1 + $3; }
        | exp MINUS exp { $$ = $1 - $3; }
        | exp MULT exp  { $$ = $1 * $3; }
        | exp DIV exp   { if( $3 == 0 ) yyerror( "divide by zero error" ); else $$ = $1 / $3; }
        | MINUS exp     { $$ = -$2; }
        | L_PAREN exp R_PAREN { $$ = $2; }
	;
%%

int main(int argc, char **argv) 
{
   if (argc > 1) 
   {
      yyin = fopen(argv[1], "r");
      if (yyin == NULL)
	   {
        printf("This is not a valid file name: %s filename\n", argv[0]);
		  exit(0);
      }
   }
   yyparse();

   return 0;
}

void yyerror(const char *msg) 
{
   printf("Error at Line %d and position %d: %s\n", currLine, currPos, msg);
   exit(0);
}

