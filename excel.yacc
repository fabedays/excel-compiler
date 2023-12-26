%{
 void yyerror(char *);
 int yyparse(void);
 int sym[26];
    #include <stdio.h>
    #include <stdlib.h>
    extern FILE *yyin, *yyout;

%}
%union {
    int i;
    char* s;
}
%token <i> INT
%token <s> STRING
%left '+' '-' '*' '/' '%' ',' '\n'
%type <i> program statement expr
%%
program:
    program statement '\n'
    | program statement ','
    | program statement
    | {}
    ;
statement:
    expr{fprintf(yyout, "%d", $1);}
    |STRING {fprintf(yyout, "%s", $1);}
    ;
expr:
    INT {$$ = $1;}
    | expr '+' expr { $$ = $1 + $3;}
    | expr '-' expr { $$ = $1 - $3;}
    | expr '*' expr { $$ = $1 * $3;}
    | expr '/' expr { $$ = $1 / $3;}
    | expr '%' expr { $$ = $1 % $3;}
    ;
%%
void yyerror(char *s) {
 fprintf(stderr, "%s\n", s);
}

int main(int argc, char *argv[]) {
    if(argc != 3){
        printf("uso: ./a.out origem.csv destino.csv\n");
        return 0;
    }
    yyout = fopen(argv[2], "w");
    yyin = fopen(argv[1], "r");
    yyparse();
    fclose(yyin);
    fclose(yyout);
}  
