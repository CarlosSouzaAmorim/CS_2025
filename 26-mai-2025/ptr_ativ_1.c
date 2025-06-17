#include <stdio.h>
/* 6. Implemente a função:
char *strchr(char *s, char ch)
Que retoma o endereço da primeira ocorrência de ch em s caso não exista retoma NULL. (Note que é o endereço, e não o índice.)

Escreva ainda um programa que solicite uma string e um caractere e mostre na tela os caracteres da string original que se encontram a partir do caractere lido (inclusive).

Introd. uma string: camaro
Introd. um char: a
amaro
 */
#define STR_LEN 50

char *strchr1(char *string_test, char caractere){

    while (*string_test){
        if (*string_test == caractere){ return string_test;}
    }
    return NULL;
}


int main(){

    char string_para_testar[STR_LEN];
    char caractere_para_testar;
    char *char_resultado;

    printf("Escreva uma string de até %d",STR_LEN);
    fgets(string_para_testar, STR_LEN, stdin);
    printf("Escreva um caractere: ");
    scanf(" %c", &caractere_para_testar);   

    char_resultado = strchr1(string_para_testar, caractere_para_testar);
    if (char_resultado != NULL) {
        printf("A partir do caractere '%c': %s", caractere_para_testar, char_resultado);
    } else {
        printf("Caractere '%c' não encontrado na string.\n", caractere_para_testar);
    }

    return 0;
}