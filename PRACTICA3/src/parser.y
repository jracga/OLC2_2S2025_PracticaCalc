%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>


typedef struct {
    char* id;
    char* tipo;
} Declaracion;

Declaracion** lista_final = NULL;
int total_declaraciones = 0;

Declaracion* crear_declaracion(char* id, char* tipo) {
    Declaracion* d = malloc(sizeof(Declaracion));
    d->id = strdup(id);
    d->tipo = strdup(tipo);
    return d;
}

void agregar_declaracion(Declaracion* d) {
    lista_final = realloc(lista_final, sizeof(Declaracion*) * (total_declaraciones + 1));
    lista_final[total_declaraciones++] = d;
}

void imprimir_lista(Declaracion** lista, int n) {
    printf("[");
    for (int i = 0; i < n; ++i) {
        printf("(%s,%s)", lista[i]->id, lista[i]->tipo);
        if (i < n - 1) printf(", ");
    }
    printf("]\n");
}

/*
void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}
*/
%}

%union {
    char* str;
    char** lista_ids;
    int count_ids;
}

%token <str> ID
%token <str> INT CHAR
%token ',' ';'

%type <str> T
%type <lista_ids> IdList

%%

S : DList { imprimir_lista(lista_final, total_declaraciones); }
  ;

DList : DList D
      | D
      ;

D : T IdList ';' {
        for (int i = 0; i < $2[0]; i++) {
            agregar_declaracion(crear_declaracion($2[i+1], $1));
        }
    }
  ;

T : INT   { $$ = strdup("int"); }
  | CHAR  { $$ = strdup("char"); }
  ;

IdList : ID {
            $$ = malloc(sizeof(char*) * 2);
            $$[0] = (char*)1;  // contador = 1
            $$[1] = strdup($1);
        }
       | IdList ',' ID {
            int count = (int)(intptr_t)$$[0];
            $$ = realloc($1, sizeof(char*) * (count + 2));
            $$[0] = (char*)(intptr_t)(count + 1);
            $$[count + 1] = strdup($3);
        }
       ;

%%
/*
int main() {
    yyparse();
    return 0;
}
*/