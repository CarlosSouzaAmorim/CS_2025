#include <stdio.h>
/*
Implemente a função 
float Pot(float x, int n) 
Devolve o valor de xn
x0 =1.0 
xn = x*x* ... *x (n vezes)


*/
float func_potencia(float x, int n){
    float x1=x;
    if (n == 0) {
            x1=1;
    }
    else {
        for (int i=0; i>n; n++){
            x1=x1*x;
        }
    }


    return ( x1 );
} 

int main (int argc, char *argv[])
{
    char char1;
    printf("POTENCIA INTEIRA DE UM NÚMERO REAL\n\n");
    printf("insira um numero real");

    scanf("%c",&char1);

    printf("A FUNCAO PASSA PARA MAIUSCULA RETORNOU: %c \n\n", func_to_upper(char1));


    
    return 0;
}