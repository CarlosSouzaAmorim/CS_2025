#include <stdio.h>
#include "strings_ativ_1.h"

#define LEN_DEF 30
//strings_ativ_1_test.c
int main(int argc, char* argv[]){
    char stringizinha[LEN_DEF] = {'o', 'i'};    
    printf("O tamanho da string é: %d", strlen(stringizinha));
    
    // Testes
    printf("\n\nTestes:\n");
    printf("strlen(\"oi\") = %d\n", strlen("oi"));
    printf("strlen(\"\") = %d\n", strlen(""));
    printf("isnull(\"oi\") = %d\n", isnull("oi"));
    printf("isnull(\"\") = %d\n", isnull(""));
    printf("strcpy(stringizinha, \"oi\") = %s\n", strcpy(stringizinha, "oi"));
    printf("strcat(stringizinha, \" mundo!\") = %s\n", strcat(stringizinha, " mundo!"));
    
    return 0;
}