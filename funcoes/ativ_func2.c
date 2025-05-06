#include <stdio.h>
/*
Escreva a função x_toupper, que transforma qualquer caractere na maiúscula correspondente. Escreva um programa de teste da função

*/
int func_to_upper(char char1){
    //teste na tabela ASCII

/*
for i in range(65, 65+32):
>>> ord("0")
48
>>> ord("9")
57
>>> ord("8")
56
>>> 
*/
    return ( char1 + ('Z' - 'z') );
} 

int main (int argc, char *argv[])
{
    char char1;
    printf("PASSA CARACTERE PARA MAIUSCULA\n\n");

    scanf("%c",&char1);

    printf("A FUNCAO PASSA PARA MAIUSCULA RETORNOU: %c \n\n", func_to_upper(char1));


    
    return 0;
}