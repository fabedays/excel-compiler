%{
    #include<stdio.h>
	#include<stdlib.h>
    #include<string.h>
    #include <stdbool.h>
    #include"y.tab.h"
    void yyerror(char *);
    extern bool secondfile;
    //regex cell: uma única célula, consiste num conjunto de uma ou mais letras seguido de um ou mais números
    //regex cells: conjunto de células, pode conter várias células separadas por '.' ou células consecutivas delimitadas por :
%}
operacoes (SOMA|SUM|MEDIA|AVERAGE|AVG)
cell [A-Z]+[0-9]+
cells ({cell}|{cell}:{cell})(;({cell}|{cell}:{cell}))*
%%

[-]?[0-9]+   {
    yylval.i = atoi(yytext);
    return INT;
}
[-+*%/]  {
    return *yytext;
}
\".+\"    {
    yylval.s = yytext;
    return STRING;
}
=SOMA\({cells}\)    {
    if(secondfile){
    int length = strlen(yytext);
    char *texto = yytext+6;
    char celas[length];
    strncpy(celas, texto, length);
    celas[strlen(celas)-1] = '\0';
    yylval.s = malloc(length);
    memcpy(yylval.s, celas, strlen(yytext));
    yylval.s[strlen(yylval.s)] = '\0';
    return SOMA;
    }
    else{
        yylval.s = yytext;
        return STRING;
    }
}
, {
    yylval.s = yytext;
    return COMMA;
}
\r\n  {
    yylval.s = yytext;
    return NEWLINE;
}
[ \t]   {
    ;
}
.   {
    //printf("i");
    yylval.s = yytext;
    return STRING;
}

%%

int yywrap() {
 return 1;
} 