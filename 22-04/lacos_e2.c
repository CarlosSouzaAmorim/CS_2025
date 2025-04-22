#include <stdio.h>
//laços de repetição 2
/* Faça um programa que receba uma senha formada de quatro números inteiros, verifique se a senha está correta e, caso não esteja, solicite novamente a senha. 
Se a senha entrada for a correta, deverá ser apresentada a mensagem “Senha Correta”, caso contrário, “Senha Incorreta”.*/
 
int main(){


    int senha_correta = 1234;
    int senha_entrada;

    int i = 0; //senha nao confere

    printf("Confere senha do usuario.\n\n");

    printf("Introduza a senha de quatro digitos numericos: ");
    scanf("%d", &senha_entrada);

    while (senha_correta != senha_entrada)
    {
        printf("A senha informada esta incorreta!");
        printf("tente novamente: ");
        scanf(" %d", &senha_entrada);
        
        printf("\n");
    }

    printf("A senha informada esta CORRETA!");

    printf("\n\n");
    return 23;

}