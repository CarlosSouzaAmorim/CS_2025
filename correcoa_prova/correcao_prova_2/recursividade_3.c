#include <stdio.h>
//funcao para imprimir numeros em ordem decrescente usando reursao
void imprime_decrescente(int n) {
    if (n < 1) {
        return; // caso base: se n for menor que 1, retorna
    }
    printf("%d ", n);       // imprime o numero atual
    imprime_decrescente(n - 1); // chama a funcao recursivamente com n-1
}

void Down(int n) {
    if (n < 1) {
        return; // caso base: se n for menor que 1, retorna
    }
    printf("%d\n ", n);
}

void Down2(int n) {
    if (n < 1) {
        return; // caso base: se n for menor que 1, retorna
    }
    printf("%d\n ", n); // imprime o numero atual apos a chamada recursiva
    Down2(n - 1); // chama a funcao recursivamente com n-1
}


int main(int argc, char *argv[]) {
    int n;
    // se o usuario nao informar um parametro, ele sera solicitado a informar um numero
    if (argc < 2) {
        printf("Informe um numero: ");
        scanf("%d", &n);
    } else {
        n = atoi(argv[1]);
    }

    // Chama a funcao para imprimir os numeros em ordem decrescente
    imprime_decrescente(n);
    printf("\n"); // Nova linha apos a impressao

    return 0;
}   