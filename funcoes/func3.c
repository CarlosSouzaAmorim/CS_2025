#include <stdio.h>


int funcao_imprime_coisinhas(int qtd_ast, char char1)
{
    int i;



    
    for (i=0; i<qtd_ast ;i++){
        printf("%c",char1);
        putchar(char1);
    }
    //func_testa_imprimivel_char
    putchar('\n');
    return i;
}




int main (int argc, char *argv[])
{
    int char_imp;

    //programa para printar asteriscos e números

    for (char_imp=65; char_imp<90; char_imp+=5){
        for (int i=3; i<=7; i+=2)
        {
            funcao_imprime_coisinhas(i,char_imp);

        }
    }

    printf("test\n\n");
    return 0;
}