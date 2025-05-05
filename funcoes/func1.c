#include <stdio.h>

int funcao_imprime_numeros(int num1)
{
    for (int i=1; i<num1 ;i++){
        printf("%d", num1);

    }
    return 0;

}

int funcao_imprime_ateristicos(int qtd_ast)
{
    for (int i=1; i<qtd_ast ;i++){
        printf("*");

    }
    return 0;

}




int main (int argc, char *argv[])
{
    int i;
    int j;
    //programa para printar asteriscos e números
    i = funcao_imprime_ateristicos(6);

    j = funcao_imprime_numeros(4);

    printf("test\n\n");
    return 0;
}