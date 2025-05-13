#include <stdio.h>
/*
    COMENTÁRIOS PARA EXERCÍCIO:
        Implemente a função:
        char *memcpy(char *dest, char *orig, int n)
        Que copia n caracteres do vetor origem (orig) para o vetor destino (dest) e devolve o vetor dest
    
*/
#define DIMENSAO_1 30

char *I_memset(char *vetor, char caractere, int posicoes){
    for (int i=0; i<posicoes; i++){
        vetor[i]=caractere;
    }

    return 0;

}

char *I_memcpy(char *vetor_destino, char *vetor_origem, int posicoes){
    for (int i=0; i<posicoes; i++){
        vetor_destino[i]=vetor_origem[i];
    }

    return 0;

}

void mostra(char s[], int tamanho_vetor){
    for (int i=0; i<tamanho_vetor; i++){
            printf(" %c", s[i]);
    }
    putchar('\n');
}

int main (int argc, char *argv[])
{

    char letras_1 [DIMENSAO_1] = {'v', 'e', 'l', 'h', 'a', '-', 'e','h','s'};
    char letras_2 [DIMENSAO_1] = {'g', 'e', 'l', 'a', 'd', 'o', 'n','a','o'};

    puts("Vetores originais:");
    mostra(letras_1, DIMENSAO_1);
    mostra(letras_2, DIMENSAO_1);
    putchar('\n');

    I_memcpy(letras_2,letras_1, 2);

    puts("Vetores alterados:");
    mostra(letras_1, DIMENSAO_1);
    mostra(letras_2, DIMENSAO_1);
    putchar('\n');

    printf ("\n\nFim!\n\n");
    
    return 0;
}