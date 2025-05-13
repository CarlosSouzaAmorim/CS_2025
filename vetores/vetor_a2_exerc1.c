#include <stdio.h>
/*
    COMENTÁRIOS PARA EXERCÍCIO:
        Implemente a função:
        char *memset(char *v, char ch, int n)
        Que coloca nas n primeiras posições do vetor v o caractere ch, devolvendo o próprio vetor v.
    
*/
#define DIMENSAO_1 30

char *memset(char *vetor, char caractere, int posicoes){
    for (int i=0; i<posicoes; i++){
        vetor[i]=caractere;
    }
}

void mostra(char s[], int tamanho_vetor){
    for (int i=0; i<tamanho_vetor; i++){
            printf(" %c", s[i]);
    }
    putchar('\n');
}

int main (int argc, char *argv[])
{

    char letras [DIMENSAO_1] = {'v', 'e', 'l', 'h', 'a', '-', 'e','h','s'};

    mostra(letras, DIMENSAO_1);

    memset(letras, 'p', 2);

    mostra(letras, DIMENSAO_1);

    printf ("\n\nFim!\n\n");
    
    return 0;
}