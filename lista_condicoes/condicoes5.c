//condicoes5.c
//5- Escreva um programa, de quatro formas distintas, que leia um inteiro e indique se esse inteiro é ou não igual a zero.

#include <stdio.h>
int main() {
	int numero;

	puts("Insira um número inteiro: ");
	scanf("%d", &numero);

    if (numero == 0) printf("O numero %d é igual a zero\n",numero);
    else printf("O numero %d é diferente de zero\n",numero);
    
    if (numero < 0 || numero > 0) printf("O numero %d é diferente de zero\n",numero);
    else printf("O numero %d é igual a zero\n",numero);
    
    if (numero != 0) printf("O numero %d é diferente de zero\n",numero);
    else printf("O numero %d é igual a zero\n",numero);
    
    if (numero) printf("O numero %d é diferente de zero\n",numero);
    else printf("O numero %d é igual a zero\n",numero);

    if (!numero) printf("O numero %d é igual a zero\n",numero);
    else printf("O numero %d é diferente de zero\n",numero);
    
    printf("\nFim\n");		
    return 0;
}


