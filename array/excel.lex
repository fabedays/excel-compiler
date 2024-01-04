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
(SOMA|SUM)\({cells}\) {                         // Rene: Combine SOMA and SUM
    if(secondfile){
    int length = strlen(yytext);
    char *texto = yytext+6;
    char celas[length];
    strncpy(celas, texto, length - 1);         // Rene: Adjust lenght
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
(AVG|MEDIA|AVERAGE)\({cells}\) {                 //Rene: Group of Average
    if(secondfile){
    int func_name_length = (yytext[0] == 'A') ? strlen("AVERAGE(") : strlen("AVG("); //Rene: based on function name
    int length = strlen(yytext);
    char *texto = yytext + func_name_length;   //Rene: count average text 
    char celas[length];
    strncpy(celas, texto, length - 1);         //Rene: adjust to parenthesis
    celas[strlen(celas)-1] = '\0';
    yylval.s = malloc(length);
    memcpy(yylval.s, celas, strlen(yytext));
    yylval.s[strlen(yylval.s)] = '\0';
    return AVERAGE;
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