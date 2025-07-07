#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct sPessoa{
    int Idade;
    char Nome[20+1];
    struct sPessoa *Prox;
} PESSOA;

typedef PESSOA* FILA;

/* Iniciar uma Fila */
void Inic(FILA* Fila) {
    *Fila = NULL;

/* Insere um novo registro no fim da fila */
void Inserir(FILA* Fila, int Idade, char * Nome) {
    if (*Fila ==NULL){
        *Fila = (FILA) malloc(sizeof(PESSOA));
        if (*Fila == NULL) return;
        strcpy((*Fila)->Nome, Nome);
        (**Fila).Prox=NULL;
    }
    else
        Inserir(&(**Fila).Prox, Idade, Nome);
}

void Apagar(FILA* Fila){
    PESSOA *Tmp = * Fila;
    if (*Fila==NULL) return; /* Não existem elementos */
    *Fila = (*Fila)->Prox;
    free(Tmp);
}

/* Listar todos os elementos da fila recursivamente */
void Listar(FILA Fila){
    if (Fila == NULL) return; /* Não existem elementos */
    printf("%d %s\n",Fila->Idade, Fila->Nome);
    Listar(Fila->Prox); /* Lista os outros */
}
int main () {
     FILA F;
     Inic(&F);
     puts("Iniciar:");Listar(F);
     puts("Inserir:");
     Inserir(&F,10,"Tiago");
     Inserir(&F,20,"Luisa");
     Inserir(&F,30,"Ana");
     puts("Listar 3");Listar(F);Apagar(&F);
     puts("Listar 2");Listar(F);Apagar(&F);
     puts("Listar 1");Listar(F);Apagar(&F);
     puts("Listar Nada");Listar(F);Apagar(&F);
     puts("Listar Nada");Listar(F);

	return 0;
 }
