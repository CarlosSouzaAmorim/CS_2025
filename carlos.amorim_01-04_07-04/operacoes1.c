#include <stdio.h>

/**1- escreva um programa em C que peça ao usuário dois inteiros e apresente o resultado das operações aritméticas tradicionais **/

int main(void){

    int num1, num2;
    printf("Introduza dois numeros inteiros: ");

//    scanf("%d", &num1);
//    scanf("%d", &num2);

//    scanf("%d%d", &num1, &num2);
    scanf("%d-%d", &num1, &num2);

    printf("A soma: \t'%d' + '%d' = %d\n", num1,num2, num1+num2);
    printf("A diferença: \t'%d' - '%d' = %d\n", num1,num2, num1-num2);
    printf("O produto: \t'%d' * '%d' = %d\n", num1,num2, num1*num2);
    printf("A divisão: \t'%d' / '%d' = %d\n", num1,num2, num1/num2);
    printf("O resto: \t'%d' %% '%d' = %d\n", num1,num2, num1%num2);


    return 23;
}