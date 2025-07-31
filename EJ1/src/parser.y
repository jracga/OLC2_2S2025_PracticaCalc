%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Prototipo del scanner */
extern int yylex(void);
/* yyerror con firma estándar */
void yyerror(const char *s);

float binario_a_decimal(const char* binstr);
%}

/* Seguimiento de ubicaciones */
%locations
/* Mensajes de error más detallados */
//%define parse.error verbose

/* Unión de tipos semánticos */
%union {
   int num;
    float fnum;
    char* str;
}

/* Tokens tipados */
%token <num> NUMBER
%token <str> BINARIO
//%token NUMBER BINARIO ERROR 
/* Tipo de los no-terminales que llevan valor */
%type <fnum> expr


/* Precedencias */
%left '+' '-'
%left '*' '/'

%%

input:
    /* vacío */
  | input line
  ;

line:
    '\n'
  //| expr '\n'   { printf("= %d\n", $1); }
  | expr '\n'   { printf("= %.6f\n", $1); } // Cambiado a float
  | error '\n'  { yyerrok; }
  ;

expr:
    expr '+' expr   { $$ = $1 + $3; }
  | expr '-' expr   { $$ = $1 - $3; }
  | '-' expr %prec '-' { $$ = -$2; }
  | expr '/' expr   {
    if ($3 == 0) {
        yyerror("Error: División por cero \n");
        YYABORT;
    } else {
        $$ = $1 / $3;
    }
    }
  | expr '*' expr   { $$ = $1 * $3; }
  | '(' expr ')'    { $$ = $2; }
  | NUMBER          { $$ = $1; }
  | BINARIO           { $$ = binario_a_decimal($1); free($1); }
  ;
%%

// Función para convertir un número binario en decimal
float binario_a_decimal(const char* binstr) {
    float resultado = 0.0;
    int parte_entera = 0;
    float parte_fraccionaria = 0.0;

    const char* punto = strchr(binstr, '.');

    if (punto) {
        // Parte entera
        for (const char* p = binstr; p < punto; ++p) {
            parte_entera = parte_entera * 2 + (*p - '0');
        }

        // Parte fraccionaria
        float peso = 0.5;
        for (const char* p = punto + 1; *p; ++p) {
            if (*p == '1') {
                parte_fraccionaria += peso;
            }
            peso /= 2;
        }
    } else {
        // Sólo parte entera
        for (const char* p = binstr; *p; ++p) {
            parte_entera = parte_entera * 2 + (*p - '0');
        }
    }

    resultado = parte_entera + parte_fraccionaria;
    return resultado;
}

/* definición de yyerror, usa el yylloc global para ubicación */
void yyerror(const char *s) {
    fprintf(stderr,
            "%s en %d:%d\n",
            s,
            yylloc.first_line,
            yylloc.first_column);
}

