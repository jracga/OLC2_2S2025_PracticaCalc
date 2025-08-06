#include <stdio.h>

// Declaración externa de yyparse generada por Bison
int yyparse(void);

// Declaración externa de yyerror para manejar errores
void yyerror(const char *s);

int main() {
    printf("Introduce las declaraciones de variables:\n");
    int resultado = yyparse();  // Ejecuta el parser

    if (resultado == 0) {
        printf("Análisis completado correctamente.\n");
    } else {
        printf("Error durante el análisis.\n");
    }
    return resultado;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error de sintaxis: %s\n", s);
}
