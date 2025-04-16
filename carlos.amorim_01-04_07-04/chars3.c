#include <stdio.h>

int main(void){

    char char1,char2;
    printf("Introduza um caractere: ");
    scanf("%c", &char1);
    printf("Introduza outro caractere: ");
    scanf(" %c", &char2);//esse espaço é de propósito!


    printf("Os caracteres introduzidos foram '%c' e '%c'\n\n", char1, char2);

    return 23;
}