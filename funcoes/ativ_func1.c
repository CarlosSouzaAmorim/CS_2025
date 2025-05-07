#include <stdio.h>
/*
Escreva a função x_isdigit, que verifica se um determinado caractere é dígito ou não. Escreva um programa de teste da função.

*/
int func_testa_digito(char char1){
    //esta função retorna verdadeiro se o caractere for um dígito
    //teste na tabela ASCII python3

/*
>>> ord("0")
48
>>> ord("9")
57
>>> ord("8")
56
>>> 
*/
    //testa se o caractere esta entre 48 e 57:
    return ( char1 >= '0' && char1 <= '9');
}

int main (int argc, char *argv[])
{
    char char1;
    printf("TESTA SE CARACTERE É DÍGITO\n\n");
    printf("Digite um caractere apra testar:");

    scanf("%c",&char1);

    printf("A FUNCÃO TESTA DIGITO RETORNOU: %d \n\n", func_testa_digito(char1));

    if (func_testa_digito(char1)){
        printf("O CARACTERE %c É UM DÍGITO\n", char1);
    }
    else{
        printf("O CARACTERE %c NÃO É UM DÍGITO\n", char1);
    }

    printf ("\n\nFim!\n\n");
    
    return 0;
}