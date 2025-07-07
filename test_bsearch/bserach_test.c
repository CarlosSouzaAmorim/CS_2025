#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

//bserach_test.c
// Este programa lê nomes de um arquivo, realiza uma busca binária para encontrar um nome específico
//bsearch esta em stdlib.h

#define MAX_NAME_LEN 100
#define MAX_NAMES 1000

void trim_newline(char *str) {
    size_t len = strlen(str);
    if (len > 0 && str[len-1] == '\n')
        str[len-1] = '\0';
}

int busca_binaria(char nomes[][MAX_NAME_LEN], int n, const char *alvo) {
    int esquerda = 0, direita = n - 1;
    while (esquerda <= direita) {
        int meio = esquerda + (direita - esquerda) / 2;
        int cmp = strcmp(nomes[meio], alvo);
        if (cmp == 0)
            return meio;
        else if (cmp < 0)
            esquerda = meio + 1;
        else
            direita = meio - 1;
    }
    return -1;
}

int main(int argc, char *argv[]) {
    char nomes[MAX_NAMES][MAX_NAME_LEN];
    int n = 0;
    char nome_procurado[MAX_NAME_LEN];

    if (argc < 2) {
        printf("Uso: %s <arquivo_de_nomes.txt>\n", argv[0]);
        return 1;
    }

    FILE *f = fopen(argv[1], "r");
    if (!f) {
        perror("Erro ao abrir o arquivo");
        return 1;
    }

    while (fgets(nomes[n], MAX_NAME_LEN, f) && n < MAX_NAMES) {
        trim_newline(nomes[n]);
        n++;
    }
    fclose(f);


    // .busca com while
    int max_passos = 0;
    int temp = n;
    while (temp > 0) {
        max_passos++;
        temp /= 2;
    }
    printf("Busca binária: no máximo %d passos serão necessários para encontrar um nome em %d nomes.\n", max_passos, n);

    // .busca com log2
    int max_passos = (int)ceil(log2(n > 0 ? n : 1));
    printf("Busca binária: no máximo %d passos serão necessários para encontrar um nome em %d nomes.\n", max_passos, n);
    
    printf("Digite o nome a procurar: ");
    if (!fgets(nome_procurado, MAX_NAME_LEN, stdin)) {
        printf("Erro na leitura do nome.\n");
        return 1;
    }
    trim_newline(nome_procurado);

    int pos = busca_binaria(nomes, n, nome_procurado);
    if (pos != -1)
        printf("Nome '%s' encontrado na posição %d.\n", nome_procurado, pos);
    else
        printf("Nome '%s' não encontrado.\n", nome_procurado);

    return 0;
}