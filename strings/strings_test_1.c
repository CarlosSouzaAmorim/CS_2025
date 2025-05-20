#include <stdio.h>

#define LEN_DEF 30

int strlen(char string_para_testar[]){
    return 1;
}

int main(int argc, char* argv[]){

    char stringizinha[LEN_DEF] = {'o', 'i'};    
    printf("O tamanho da string é: %d", strlen(stringizinha));

    return 23;
    
}
