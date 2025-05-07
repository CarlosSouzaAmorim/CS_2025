#include <stdio.h>
/*
Implemente a função int Abs(int x)
Devolve o valor absoluto de x
Abs(-5) → 5
Abs(5)	→ 5
*/


int Abs(int x) {
    //esta função retorna o valor absoluto de x
    //somente inverte o sinal se x for negativo
    if (x < 0) {
        return -x;
    } else {
        return x;
    }
}

int main (int argc, char *argv[])
{
    int inteiro;

    printf("VALOR ABSOLUTO DE UM NÚMERO INTEIRO\n\n");
    printf("Insira um númeto inteiro:");
    scanf("%d",&inteiro);
    printf("O valor absoluto de %d é %d\n", inteiro, Abs(inteiro));    

    printf ("\n\nFim!\n\n");    
    return 0;
}