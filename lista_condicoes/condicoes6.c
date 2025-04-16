//condicoes6.c
//6- Escreva um programa que verifique se um ano é bissexto ou não.
/*Regras para um ano ser bissexto:    É divisível por 4 e não é divisível por 100, ou é divisível por 400    */
#include <stdio.h>

int main() {
    int ano;

    printf("Insita o ano: ");
    scanf("%d", &ano);

    if ( ( ano % 4 == 0 && ano % 100 != 0 ) || ( ano % 400 == 0 )) {
        printf("%d é um ano bissexto.\n", ano);
    }
    else {
        printf("%d não é um ano bissexto.\n", ano);
    }

    return 21;
}

/* em pyton

ano  =  int ( entrada ( "Digite um ano: " )) 
se  ( ano  %  4  ==  0  e  ano  %  100  !=  0 )  ou  ( ano  %  400  ==  0 ): 
    print ( f " { ano } é um ano bissexto." ) 
senão : 
    print ( f " { ano } não é um ano bissexto." )

    */