#include <stdio.h>

int main(){

    int CARLOS = 1;
    float AMORIM = .99999999999999;
    int *ptr_CARLOSito = NULL;
    float *ptr_AMORito = NULL;

    int x = 5;
    float pio = 3.1415;

    int *ptr_x = NULL;

    printf("carlos é: %d\n", CARLOS);
    printf("endereço de carlos é: %ld \n", &CARLOS);
    puts("\n");
    printf("o ponteiro de carlosito é: %d\n", ptr_CARLOSito);
    printf("o ponteiro de carlos é: %d \n", ptr_AMORito);

    printf("%d");

    //modificando os valores referenciados pelo ponteiro
    ptr_CARLOSito = &CARLOS;
    ptr_AMORito = &AMORIM;

    printf("o ponteiro de carlosito é: %d\n", ptr_CARLOSito);
    printf("o ponteiro de carlos é: %d \n", ptr_AMORito);


    puts("\n\n");
    return 0;    
}
