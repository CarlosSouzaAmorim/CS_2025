#include <stdio.h>

int main(void) {
    char    caractere;
    int     numero;
    float   flutuante;
    double  duplo;

    printf("O tamanho em bytes do char = [%d]:%c\n", sizeof(caractere),caractere);
    printf("O tamanho em bytes do char = [%d]:%d\n", sizeof(numero),numero);
    printf("O tamanho em bytes do char = [%d]:%f\n", sizeof(flutuante),flutuante);
    printf("O tamanho em bytes do char = [%d]:%f\n", sizeof(duplo),duplo);

    long int long_int;
    short int short_int;
    printf("O tamanho em bytes do char = [%d]:%ld\n", sizeof(long_int),long_int);
    printf("O tamanho em bytes do char = [%d]:%hd\n", sizeof(short_int),short_int);


    

    printf("\n\n");

    return 23;
}
    