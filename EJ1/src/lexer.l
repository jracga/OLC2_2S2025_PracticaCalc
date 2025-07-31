%{
#include "parser.tab.h"  /* trae YYSTYPE, YYLTYPE, yylval, yylloc */
#include <stdlib.h>

/* Contadores de línea y columna */
//int yylineno = 1;
int yycolumn = 1;

/* antes de cada token actualiza yylloc y columna */
#define YY_USER_ACTION                                   \
    yylloc.first_line   = yylineno;                      \
    yylloc.first_column = yycolumn;                      \
    yylloc.last_line    = yylineno;                      \
    yylloc.last_column  = yycolumn + yyleng - 1;         \
    yycolumn           += yyleng;
%}

/* Opciones de Flex */
%option noyywrap yylineno

/* Definiciones */
DIGIT [0-9]
NUMBER {DIGIT}+
BIN_DIGIT [01]
BIN_NUMBER {BIN_DIGIT}+(\.{BIN_DIGIT}+)?
BIN_FRAC_PART [01]+
BIN_INT_PART  [01]+


%% // %% significa el inicio de las reglas de análisis léxico en Flex

"\n" {
    ++yylineno;
    yycolumn = 1;
    /* Ubicación al inicio de la nueva línea */
    yylloc.first_line   = yylineno;
    yylloc.first_column = 1;
    yylloc.last_line    = yylineno;
    yylloc.last_column  = 1;
    return '\n';
}

{NUMBER} {
    yylval.num = atoi(yytext);
    return NUMBER;
}

[+\-*/] {
    return yytext[0];
}

[ \t\r]+ {
    /* avanzamos columna en YY_USER_ACTION */
}


{BIN_NUMBER} {
    yylval.str = strdup(yytext);  // Copia el literal binario como string
    return BINARIO;
}



. {
    /* Error léxico: usamos yylloc.first_column */
    fprintf(stderr,
            "Error léxico: carácter inválido '%c' en %d:%d\n",
            yytext[0],
            yylloc.first_line,
            yylloc.first_column);
    return yytext[0];
}

%%
/*
{BIN_DIGIT}*\.[^01\n\t\r ]+ {
    fprintf(stderr, "Error: dígitos no binarios después del punto en '%s' (línea %d, col %d)\n",
            yytext, yylloc.first_line, yylloc.first_column);
    return ERROR;
}

{BIN_DIGIT}*\.[01]*\.[01]* {
    fprintf(stderr, "Error: número binario con múltiples puntos en '%s' (línea %d, col %d)\n",
            yytext, yylloc.first_line, yylloc.first_column);
    return ERROR;
}

\.{BIN_FRAC_PART} {
    fprintf(stderr, "Error: número binario sin parte entera en '%s' (línea %d, col %d)\n",
            yytext, yylloc.first_line, yylloc.first_column);
    return ERROR;
}

{BIN_INT_PART}\. {
    fprintf(stderr, "Error: número binario sin parte fraccionaria en '%s' (línea %d, col %d)\n",
            yytext, yylloc.first_line, yylloc.first_column);
    return ERROR;
}*/