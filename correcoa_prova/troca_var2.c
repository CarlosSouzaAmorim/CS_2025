#include <stdio.h>

void troca(int *a, int *b);
main(){
    int n,k;
    puts("Introd. dois N inteiros:");
    scanf("%d %d", &n, &k);
    printf("Antes da troca: n=%d k=%d\n", n, k);
    troca(&n, &k);
    printf("Depois da troca: n=%d k=%d\n", n, k);
}

void troca(int *a, int *b){
    int aux;
    aux = *a;
    *a = *b;
    *b = aux;
    printf("Dentro da funcao troca: a=%d b=%d\n", a, b);
}
