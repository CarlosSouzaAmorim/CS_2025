#include <stdio.h>
//mostrar soma e dobro "aninhadas"

int funcao_soma(int num1, int num2)
{
    return num1+num2;
}
int funcao_produto(int num1, int num2)
{
    return num1*num2;
}
int funcao_dorbro_pp(int num1, int exp2)
{
    //return num1+num1;
    //return 2*num1;
    return num1 << exp2;
}


int main (int argc, char *argv[])
{
    int num1; int num2;
    //programa para printar asteriscos e números
    printf("PROGRAMA IMPRIME O RESULTADO DA SOMA E DOBRO DE DOIS NÚMEROS:\n\n");

    printf("insira dois números:");

    scanf("%d %d", &num1, &num2);

    printf("A SOMA É : %d\n", funcao_soma(num1, num2));
    printf("O PRODUTO É : %d\n", funcao_produto(num1, num2));

    printf("\nfim\n\n");
    return 0;
}