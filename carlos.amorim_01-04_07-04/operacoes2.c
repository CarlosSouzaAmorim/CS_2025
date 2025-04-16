#include <stdio.h>

/**2 - Escreva um programa em C que solicite um determinado número de segundos e, em seguida, indique quantas horas, minutos e segundos esse valor representa

**/

int main(void){

    int segundos;
    printf("Introduza o númeor de segundos: ");

//    scanf("%d", &num1);
//    scanf("%d", &num2);

//    scanf("%d%d", &num1, &num2);
    scanf("%d", &segundos);

    printf("O número de segundos \t'%d'\n", segundos);
    printf("Horas: \t'%d'/3600 = %d\n", segundos, segundos/3600);
    printf("Minutos: \t'%d'/60 = %d\n", segundos, segundos/60);
    printf("A divisão: \t'%d' / '%d' = %d\n", num1,num2, num1/num2);
    printf("O resto: \t'%d' %% '%d' = %d\n", num1,num2, num1%num2);


    return 23;
}