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
    return STRING;
}

, {
    yylval.s = yytext;
    return STRING;
}
\r\n  {
    yylval.s = yytext;
    return STRING;
}
[ \t]   {
    ;
}
.+   {
    fprintf(yyout, "(%s string invalida) ", yytext);
}

%%

int yywrap() {
 return 1;
} 
