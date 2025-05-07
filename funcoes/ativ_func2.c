#include <stdio.h>
/*
Escreva a função x_toupper, que transforma qualquer caractere na maiúscula correspondente. Escreva um programa de teste da função

*/
int func_to_upper(char char1){
    //esta função retorna o valor do caractere deslocado para maiúscula
    //testes na tabela ASCII python3
/*
for i in range(65, 65+32):
>>> ord("a")
97
>>> ord("A")
65
>>> 
*/
    //desloca o caractere para maiúscula: calcula o deslocamento = 32

    return ( char1 + ('Z' - 'z') );
} 

int main (int argc, char *argv[])
{
    char char1;
    printf("PASSA CARACTERE PARA MAIUSCULA\n\n");
    printf("Digite um caractere apra converter:");

    scanf("%c",&char1);

    printf("A FUNCAO PASSA PARA MAIUSCULA RETORNOU: %c \n\n", func_to_upper(char1));


    

    printf ("\n\nFim!\n\n");
    
    return 0;
}