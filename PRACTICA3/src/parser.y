%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char* id;
    char* tipo;
} Declaracion;

Declaracion* crear_declaracion(char* id, char* tipo);
void agregar_declaraciones(Declaracion*** lista, int* n, Declaracion* nueva);
void imprimir_lista(Declaracion** lista, int n);
%}

%union {
    char* str;
    char** lista_ids;
    int count_ids;
    Declaracion* decl;
    Declaracion** decl_list;
    int count_decls;
}

%token <str> ID
%token <str> INT CHAR
%token ',' ';'

%type <str> T
%type <lista_ids> IdList
%type <count_ids> IdList_count
%type <decl> D
%type <decl_list> DList
%type <count_decls> DList_count
%type <decl_list> S
%type <count_decls> S_count

%%

S : DList  { imprimir_lista($1, $2); }
  ;

DList : DList D {
                int total = $2 != NULL ? $4 + $2->count_decls : $4;
                $$ = realloc($1, total * sizeof(Declaracion*));
                if ($2 != NULL)
                    memcpy(&($$[$4]), $2, $2->count_decls * sizeof(Declaracion*));
                S_count = total;
            }
      | D   { $$ = malloc(sizeof(Declaracion*) * $1->count_decls);
            memcpy($$, $1, $1->count_decls * sizeof(Declaracion*));
            S_count = $1->count_decls;
        }
      ;

D : T IdList ';'                     {
                                        $$ = malloc(sizeof(Declaracion*) * $3_count);
                                        for (int i = 0; i < $3_count; ++i)
                                            $$[i] = crear_declaracion($2[i], $1);
                                        D.count_decls = $3_count;
                                    }
  ;

T : INT                              { $$ = strdup("int"); }
  | CHAR                             { $$ = strdup("char"); }
  ;

IdList : IdList ',' ID    {
                    $$ = realloc($1, sizeof(char*) * ($3_count + 1));
                    $$[$3_count] = strdup($3);
                    IdList_count = $3_count + 1;
                }
       | ID                          {
                                        $$ = malloc(sizeof(char*));
                                        $$[0] = strdup($1);
                                        IdList_count = 1;
                                    }
       ;
%%

Declaracion* crear_declaracion(char* id, char* tipo) {
    Declaracion* d = malloc(sizeof(Declaracion));
    d->id = strdup(id);
    d->tipo = strdup(tipo);
    return d;
}

void imprimir_lista(Declaracion** lista, int n) {
    printf("[");
    for (int i = 0; i < n; ++i) {
        printf("(%s,%s)", lista[i]->id, lista[i]->tipo);
        if (i != n - 1) printf(", ");
    }
    printf("]\n");
}
