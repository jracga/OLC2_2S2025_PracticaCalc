%{
#include "parser.tab.h"  // Importa los tokens definidos por Bison
#include <string.h>
%}

%%

int             { yylval.str = strdup(yytext); return INT; }
char            { yylval.str = strdup(yytext); return CHAR; }
[a-zA-Z_][a-zA-Z0-9_]*   { yylval.str = strdup(yytext); return ID; }

","             { return ','; }
";"             { return ';'; }

[ \t\r\n]+      { /* Ignorar espacios, tabulaciones y saltos de línea */ }

.               {
                    fprintf(stderr, "Caracter no reconocido: %s\n", yytext);
                    return 1;
                }

%%

int yywrap(void) {
    return 1;
}
