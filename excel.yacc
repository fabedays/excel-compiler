%{
    void yyerror(char *);
    int yyparse(void);
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdbool.h>
    #include <string.h>
    #include <math.h>
    extern FILE *yyin, *yyout;
    bool secondfile = false;

    #define MAX_ROWS 10                      // Rene: Max rows
    #define MAX_COLS 10                       // Rene: Max columns
    int csv_data[MAX_ROWS][MAX_COLS];       // Rene: set csv sctructure 
    int current_row = 0, current_col = 0;     // Rene: start csv
    int* lettertranslator(char* lin);
%}
%union {
    int i;
    char* s;
    int op;
}
%token <i> INT
%token <s> STRING
%token <s> SOMA
%token <s> COMMA
%token <s> NEWLINE
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
    |SOMA {
        if(secondfile){
            printf("%s\n", $1);
            fflush(stdout);
            int length = strlen($1);
            char *copy = (char *)malloc(length + 1);
            if (copy == NULL) {
                fprintf(stderr, "Memory allocation failed\n");
                return 1;
            }
            strcpy(copy, $1);
            char *token = strtok(copy, ";");
            int *pos = lettertranslator(token);
            int total = csv_data[pos[0]][pos[1]];
            printf("csv:%d\n", csv_data[0][0]);
            printf("total: %d\n", total);
            while (token != NULL) {
                printf("token:%s\n", token);
                token = strtok(NULL, ";");
                pos = lettertranslator(token);
                total += csv_data[pos[0]][pos[1]];
            }

        fprintf(yyout, "%d", total);
        }

    
    }
    |COMMA {fprintf(yyout, "%s", $1); current_col++;}
    |NEWLINE {fprintf(yyout, "%s", $1); current_row++; current_col = 0;}

    ;
expr:
    INT {$$ = $1; csv_data[current_row][current_col] = $$;}
    | expr '+' expr { $$ = $1 + $3; csv_data[current_row][current_col] = $$;}
    | expr '-' expr { $$ = $1 - $3; csv_data[current_row][current_col] = $$;}
    | expr '*' expr { $$ = $1 * $3; csv_data[current_row][current_col] = $$;}
    | expr '/' expr { $$ = $1 / $3; csv_data[current_row][current_col] = $$;}
    | expr '%' expr { $$ = $1 % $3; csv_data[current_row][current_col] = $$;}
    ;
%%
void yyerror(char *s) {
 fprintf(stderr, "%s\n", s);
}

int* lettertranslator(char* lin){
    int linha = 0;
    int sep;
    for(int i = 0; i<strlen(lin);i++){
        if(lin[i]-64 < 0){
            sep = i;
            break;
        }
    }
    for(int i = 0; i<strlen(lin);i++){
        if(lin[i]-64 >= 0)
            linha += (lin[i] - 64) * pow(26, (sep - i)-1);
    }
    
    char num[strlen(lin)];
    strncpy(num, lin + sep, strlen(lin));
    int *pos = malloc(2 * sizeof(int));
    if (pos == NULL) {
        return NULL;
    }
    pos[0] = --linha;
    pos[1] = atoi(num)-1;
    printf("%d, %d\n", pos[0], pos[1]);
    return pos;
}

int main(int argc, char *argv[]) {

    if(argc != 3){
        printf("uso: ./a.out origem.csv destino.csv\n");
        return 0;
    }
    yyin = fopen(argv[1], "r");
    yyout = fopen("middle.csv", "w");
    yyparse();
    fclose(yyin);
    fclose(yyout);

    secondfile = true;
    current_col = 0;
    current_row = 0;
    yyin = fopen("middle.csv", "r");
    yyout = fopen(argv[2], "w");
    yyparse();
    fclose(yyin);
    fclose(yyout);
    //remove("middle.csv");
    printf("\n");
    for(int i = 0; i< MAX_ROWS; i++){
        for(int j = 0; j<MAX_COLS; j++)
            printf("%d\t", csv_data[i][j]);
        printf("\n");
    }
}  
