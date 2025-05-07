#include <stdio.h>

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

float VAL(float x, int n, float t) {
    // Função VAL para calcular o Valor Atual Líquido
    //return x / func_potencia( (1 + t) , n );

    float val = 0.0;
    for (int i = 1; i <= n; i++) {
        val += x / func_potencia(1 + t, i);
    }
    return val;
}

int main(int argc, char *argv[]) {

    float x, t;
    int n;

    printf("PARA CÁLCULO DO VALOR ATUAL LÍQUIDO (VAL)\n\n");
    printf("Insira o valor inicial (x) real: ");
    scanf("%f", &x);

    printf("Insira o número de anos (n) inteiro: ");
    scanf("%d", &n);

    printf("Insira a taxa (t) real: ");
    scanf("%f", &t);

    printf("O Valor Atual Líquido (VAL) calculado é: %f\n", VAL(x, n, t));


    printf ("\n\nFim!\n\n");
    
    return 0;
}