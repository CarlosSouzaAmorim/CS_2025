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

char *strchr(char *string_test, char caractere){

    while (*string_test){
        if (*string_test == caractere){ return string_test;}
    }
    return NULL;
}


int main(){

    char string_para_testar[STR_LEN];
    char caractere_para_testar;
    char *char_resultado;

    printf("Escreva uma string até %d",STR_LEN);

    return 0;
}