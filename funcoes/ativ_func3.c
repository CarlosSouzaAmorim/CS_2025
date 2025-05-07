#include <stdio.h>
/*
Implemente a função 
float Pot(float x, int n) 
Devolve o valor de xn
x0 =1.0 
xn = x*x* ... *x (n vezes)


*/
float func_potencia(float x, int n){
    //esta função retorna o valor de x elevado a n natural
    float x1=x;
    if (n == 0) {
            x1=1;
    }
    else {
        for (int i=1; i<n; i++){
            x1=x1*x;
        }
    }


    return ( x1 );
} 

int main (int argc, char *argv[])
{
    char char1;
    float num_real;
    int num_inteiro;

    printf("POTÊNCIA INTEIRA DE UM NÚMERO REAL\n\n");
    printf("insira um numero real");
    scanf("%f",&num_real);

    printf("insira um número natural");

    scanf("%d",&num_inteiro);

    printf("A FUNCAO POTENCIA RETORNOU: %f \n\n", func_potencia(num_real,num_inteiro));

    printf ("\n\nFim!\n\n");    
    return 0;
}