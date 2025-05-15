#include <stdio.h>
/*
    COMENTÁRIOS PARA EXERCÍCIO:
        3) Implemente a função:
        int memcmp(char *s1, char *s2, int n)
        Que verifica se as n primeiras posições dos vetores s1 e s2 são ou não iguais
    
*/
#define DIMENSAO_1 30

char converte_para_minuscula(char caractere){ 
    if ( caractere >= 'A' && caractere <= 'Z' )
        return caractere + ('a' - 'A');//32
    return caractere;
}

char *I_memset(char *vetor, char caractere, int posicoes){
    for (int i=0; i<posicoes; i++){
        vetor[i]=caractere;
    }

    return vetor;

}

char *I_memcpy(char *vetor_destino, char *vetor_origem, int posicoes){
    for (int i=0; i<posicoes; i++){
        vetor_destino[i]=vetor_origem[i];
    }

    return vetor_destino;

}
int I_memcmp(char *vetor_destino, char *vetor_origem, int posicoes){
    for (int i=0; i<posicoes; i++){
        //testa cada posicao do vetor, se for diferente, sair da funcao e retornar falso
        if (vetor_destino[i]!=vetor_origem[i]){
            return 0;
        };
    
    }

    return 1;

}

int I_memicmp(char *s1, char *s2, int n) {
    for (int i = 0; i < n; i++) {
        char c1 = s1[i];
        char c2 = s2[i];
        
        // Converte para min se mai

        c1=converte_para_minuscula(c1);
        c2=converte_para_minuscula(c1);
        
        if (c1 != c2) {
            return 0; 
        }
    }
    return 1; // 
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
    char letras_2 [DIMENSAO_1] = {'g', 'r', 'e', 'i', 'd', 'o', 'n','a','o'};

    puts("Vetores originais:");
    // mostra(argv[1], DIMENSAO_1); //pegar o vetor do argv com tamanho sizeof(argv[1]) nao funciona
    // mostra(argv[2], DIMENSAO_1);
    mostra(letras_1, DIMENSAO_1);
    mostra(letras_2, DIMENSAO_1);
    putchar('\n');

    I_memcpy(letras_1,letras_2, 2);

    puts("Vetores alterados:");
    mostra(letras_1, DIMENSAO_1);
    mostra(letras_2, DIMENSAO_1);

    putchar('\n');
    puts("Compara os vetores:");
    if (I_memcmp(letras_1,letras_2, DIMENSAO_1)){
        puts("as strings sao iguais");
    }
    else{
        puts("as strings sao diferentes");
    };
    putchar('\n');
    
    I_memcpy(letras_2,letras_1, 2);

    puts("Vetores alterados (copia ):");
    mostra(letras_1, DIMENSAO_1);
    mostra(letras_2, DIMENSAO_1);
    putchar('\n');


    puts("Compara os vetores:");
    if (I_memcmp(letras_1,letras_2, 2)){
        puts("as strings sao iguais");
    }
    else{
        puts("as strings sao diferentes");
    };

    memset(letras_1, 'p', 2);
    memset(letras_2, 'P', 2);

    puts("Vetores alterados (p e P):");
    mostra(letras_1, DIMENSAO_1);
    mostra(letras_2, DIMENSAO_1);
    putchar('\n');


    puts("Compara os vetores case insensitive:");
    if (I_memicmp(letras_1,letras_2, 2)){
        puts("as strings sao iguais");
    }
    else{
        puts("as strings sao diferentes");
    };


    printf ("\n\nFim!\n\n");
    
    return 0;
}