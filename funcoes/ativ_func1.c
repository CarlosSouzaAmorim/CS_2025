#include <stdio.h>
/*
Escreva a função x_isdigit, que verifica se um determinado caractere é dígito ou não. Escreva um programa de teste da função.

*/
int func_testa_digito(char char1){
    //teste na tabela ASCII

/*
>>> ord("0")
48
>>> ord("9")
57
>>> ord("8")
56
>>> 
*/
    return ( char1 >= '0' && char1 <= '9');
}

int main (int argc, char *argv[])
{
    char char1;
    printf("TESTA SE CARACTERE É DÍGITO\n\n");

    scanf("%c",&char1);

    printf("A FUNCAO TESTA DIGITO RETORNOU: %d \n\n", func_testa_digito(char1));


    
    return 0;
}