#include <stdio.h>

int main(void){

    char char1;
    printf("Introduza um caractere: ");
    scanf("%c", &char1);

    printf("O caractere '%c' introduzido tem o ASCII %d\n\n", char1,char1);
    printf("O caractere '%c' introduzido tem o ASCII %d\n\n", char1,(char) char1);
    printf("O caractere seguinte '%c' introduzido tem o ASCII %d\n\n", (char) (char1 + 1), char1 + 1);

    return 23;
}