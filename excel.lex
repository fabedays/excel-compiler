%{
    #include<stdio.h>
	#include<stdlib.h>
    #include<string.h>
    #include"y.tab.h"
    void yyerror(char *);
%}

%%

[0-9]+   {
    fprintf(yyout, "numero %s", yytext);
    return INT;
}
\"[A-Za-z]+\" {
    fprintf(yyout, "string %s", yytext);
}

, {
    fprintf(yyout, "%s", yytext);
}

.   {
    fprintf(yyout, "%s", yytext);
}

\n  {
    fprintf(yyout, "%s", yytext);
}

%%

int yywrap() {
 return 1;
} 