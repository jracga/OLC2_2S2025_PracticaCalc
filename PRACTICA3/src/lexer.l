%{
#include "y.tab.h"
%}

%%
int     { return INT; }

char    { return CHAR; }


[a-zA-Z_][a-zA-Z0-9_]*   { yylval.str = strdup(yytext); return ID; }

,       { return ','; }

;       { return ';'; }

[ \t\n\r]+     { /* ignorar */ }

.       { printf("Caracter no reconocido: %s\n", yytext); exit(1); }
%%
