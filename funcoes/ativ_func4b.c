#include <stdio.h>


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

float funcao_exponente_n(float x, int exp_n){

    return 0;
}

int main (int argc, char *argv[])
{
    int iteracoes;
    float valor_inicial;
    float valor_atual;

    printf("Insira o numero de iteracoes:");
    scanf("%d",&iteracoes);
    printf("Insira o valor inicial:");
    scanf("%f",&valor_inicial);

    for (int i=0; i >= iteracoes; i++){
        valor_atual = func_potencia(valor_inicial, );
    }
    
    return 0;
}