#include <stdio.h>
//laços de repetição 1
/* Faça um programa que leia números reais maiores que zero.
 Quando for entrado o número zero, o programa deverá apresentar quantos números foram inseridos e a média destes.*/
 
int main(){


    float media;
    float i_soma;
    int n;
    int i, i_qtd;
    int j;

/*    printf("Introduza um número: ");
    scanf("%d", &n);*/

    j=1;
    i_soma = 0;
    i_qtd = 0;

    printf("Calcula media de numeros ate que zero seja inserido.\n\n");

    printf("Introduza um número: ");
    scanf("%d", &i);

    if (i == 0) { printf("Pelo menos um numero maior que zero!"); return 21;}

    while (i>0)
    {
        //scanf("%d", &i);
        if (i>0) {
            i_soma = i_soma + i;
            i_qtd++;
        }
        else
        {
            //return 21;
        }

        printf("Introduza um número: ");
        scanf(" %d", &i);
        
        printf("\n");
    }

    media = i_soma / i_qtd;
    printf("Media: %f de %d numeros", media, i_qtd);
    printf("\n\n");
    return 23;

}