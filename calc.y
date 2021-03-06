%{
 #include <stdio.h>
 #include <stdlib.h>
 void yyerror(const char *msg);
 extern int currLine;
 extern int currPos;
 extern int numNumbers, numOperators, numParens, numEquals;
 FILE *yyin;
%}

%union{
  double dval;
  int ival;
}
%error-verbose
%start input
%token MULT DIV PLUS MINUS EQUAL L_PAREN R_PAREN END
%token <dval> NUMBER
%type <dval> exp
%left PLUS MINUS 
%left MULT DIV


%% 
input:
        | input line
        ;

line:		exp EQUAL END         { printf("\t%f\n", $1);}
			;

exp:		NUMBER                { $$ = $1; }
			| exp PLUS exp        { $$ = $1 + $3; }
			| exp MINUS exp       { $$ = $1 - $3; }
			| exp MULT exp        { $$ = $1 * $3; }
			| exp DIV exp         { if ($3==0) yyerror("divide by zero"); else $$ = $1 / $3; }
			| MINUS exp { $$ = -$2; }
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
        printf("This is not a valid file name: %s filename\n", argv[1]);
		  exit(0);
      }
   }
   yyparse();

   printf("# Numbers: %d\n", numNumbers);
   printf("# Operators: %d\n", numOperators);
   printf("# Parentheses: %d\n", numParens);
   printf("# Equal Signs: %d\n", numEquals);

   return 0;
}

void yyerror(const char *msg) 
{
   printf("Error at Line %d and position %d: %s\n", currLine, currPos, msg);
   exit(0);
}

