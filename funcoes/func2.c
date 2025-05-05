#include <stdio.h>

int funcao_for(int ind, int teste, int inc)
    {
        return 0;
    }
    

int funcao_imprime_ateristicos(int qtd_ast)
{
    int i;

    
    for (i=0; i<qtd_ast ;i++){
        printf("*");
    }
    putchar('\n');
    return i;
}




int main (int argc, char *argv[])
{
    int k;
    //programa para printar asteriscos e números


    for (int i=3; i<=7; i+=2)
    {
        funcao_imprime_ateristicos(i);

    }

    for (int i=5; i>=3; i-=2)
    {
        funcao_imprime_ateristicos(i);

    }


    printf("test\n\n");
    return 0;
}