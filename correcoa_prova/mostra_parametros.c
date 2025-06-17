#include <stdio.h>

void main(int argc, char *argv[]) {
    int i;
    printf("Mostrando os parametros passados:\n");
    for (i = 0; i < argc; i++) {
        printf("Parametro %d: %s\n", i, argv[i]);
    }
    
    // Exemplo de uso de um parametro
    if (argc > 1) {
        printf("Primeiro parametro: %s\n", argv[1]);
    } else {
        printf("Nenhum parametro foi passado.\n");
    }
}
