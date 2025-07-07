#include <stdio.h>
#include <stdlib.h>

// Função fornecida
float Quake_Raiz_Quadrada_Inversa(float numero)
{
    long i;
    float x2, y;
    const float tres_meios = 1.5F;

    x2 = numero * 0.5F;
    y  = numero;
    i  = * ( long * ) &y;                           // coisa do capeta
    i  = 0x5f3759df - ( i >> 1 );                   // mistério
    y  = * ( float * ) &i;
    y  = y * ( tres_meios - ( x2 * y * y ) );       // primeira iteração
    // y  = y * ( tres_meios - ( x2 * y * y ) );    // segunda iteração opcional

    return y;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Uso: %s <numero_real_positivo>\n", argv[0]);
        return 1;
    }

    float numero = atof(argv[1]);
    if (numero <= 0) {
        printf("Por favor, forneça um número real positivo.\n");
        return 1;
    }

    float inv_sqrt = Quake_Raiz_Quadrada_Inversa(numero);
    float raiz = 1.0f / inv_sqrt;

    printf("Raiz quadrada aproximada de %.6f: %.6f\n", numero, raiz);

    return 0;
}