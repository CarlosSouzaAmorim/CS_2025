#include <stdio.h>


int funcao_soma(int num1, int num2)
{
    return num1+num2;
}
int funcao_produto(int num1, int num2)
{
    return num1*num2;
}


int main (int argc, char *argv[])
{
    int num1; int num2;
    //programa para printar asteriscos e números
    printf("PROGRAMA IMPRIME O RESULTADO DA SOMA E PRODUTO DE DOIS NÚMEROS:\n\n");

    printf("insira dois números:");

    scanf("%d %d", &num1, &num2);

    printf("A SOMA É : %d\n", funcao_soma(num1, num2));
    printf("O PRODUTO É : %d\n", funcao_produto(num1, num2));

    printf("\nfim\n\n");
    return 0;
}