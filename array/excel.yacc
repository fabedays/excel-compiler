%{
 void yyerror(char *);
 int yyparse(void);
 int sym[26];
    #include <stdio.h>
    #include <stdlib.h>
    extern FILE *yyin, *yyout;

    #define MAX_ROWS 100                      // Rene: Max rows
    #define MAX_COLS 50                       // Rene: Max columns
    char* csv_data[MAX_ROWS][MAX_COLS];       // Rene: set csv sctructure 
    int current_row = 0, current_col = 0;     // Rene: start csv

%}
%union {
    int i;
    char* s;
}
%token <i> INT
%token <s> STRING
%token COMMA NEWLINE
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

%%
// Rene: Start of new part of array for the array

csv_file:
    line
    | csv_file line
    ;

line:
    value
    | line COMMA value
    | line NEWLINE { 
        csv_data[current_row][current_col] = NULL; // End of row
        current_row++;
        current_col = 0;
    }
    ;

value:
    INT {
        char buffer[20];
        sprintf(buffer, "%d", $1);
        csv_data[current_row][current_col++] = strdup(buffer);
    }
    | STRING {
        csv_data[current_row][current_col++] = $1;
    }
    ;

%%
// Rene: End of new part of array for the array


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
