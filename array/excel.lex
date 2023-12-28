%{
    #include<stdio.h>
	#include<stdlib.h>
    #include<string.h>
    #include"y.tab.h"
    void yyerror(char *);
%}

%%

[0-9]+   {
    yylval.i = atoi(yytext);
    return INT;
}
[-+*/]  {
    return *yytext;
}
\"[a-zA-Z]+\"    {
    yylval.s = yytext;
    printf("stuff");
    return STRING;             //Rene: codigo yylval.s = yytext suprimido
}                               

, { 
    return COMMA;              // Rene: comma as token
}

\n { 
    return NEWLINE;            // Rene: newline as token
}

\r  {                          // Rene: newline foi retirado de cá
    yylval.s = yytext;
    return STRING;
}
[ \t]   {
    ;
}
.   {
    fprintf(yyout, "(%s string invalida) ", yytext);
}

%%

int yywrap() {
 return 1;
} 
