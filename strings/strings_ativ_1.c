#include <stdio.h>
#include "strings_ativ_1.h"

#define LEN_DEF 30
//strings_ativ_1_test.c


int strlen(char *s); /* String Length */

int isnull(char *s); /* Not included */
int isnull2(char *s);

char *strcpy(char *dest, char *orig);
char *strcpy2(char *dest, char *orig);

char *strcat(char *dest, char *orig); /* String Concat */
char *strcat2(char *dest, char *orig);
char *strcat3(char *dest, char *orig);



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


// 1) Devolve o número de caracteres existentes na string (sem '\0')

//strlen("")			→ 0
//strlen("strlen")		→ 6

int strlen(char *s){
	int i=0;
	while (s[i] != '\0')
		i++;
	return i;
}

// 2) 
// Verifica se uma string contém ou não algum caractere
// isnull("")			→ <TRUE>
// isnull("strlen")		→ <FALSE>
int isnull(char *s){
	return s[0] == '\0';
}

int isnull2(char *s){
	return (strlen(s) == 0);
}

// 3) char *strcpy(char *dest, char *orig) /*String Copy*/
// Essa função copia a string orig para a string dest

char *strcpy(char *dest, char *orig){
int i; 
for (i=0 ; orig[i]!='\0' ; i++) 
dest[i] = orig[i]; 
dest[i] = '\0'; 
return dest;
}

//3) Ainda outra forma de implementação:

char *strcpy2(char *dest, char *orig) { 
	int i=0; 
while (dest[i] = orig[i])
i++; 
return dest;
}
/*
Primeiro atribui (como em x=y=z=0), depois testa. Se a condição testada devolve um valor diferente de Zero é porque a condição é verdadeira, então incrementa. Quando chegar ao caractere delimitador ('\0') este é atribuído à string destino, e só depois é que o resultado da atribuição é testado. Sendo 0, o laço também termina
*/

//4) char *strcat(char *dest, char *orig) /*String Concat*/
//Coloca a string orig imediatamente após o final da string dest
//Não coloca qualquer caractere para separar as duas strings

char *strcat(char *dest, char *orig){
int i, len; 
for (i=0,len=strlen(dest);orig[i]!='\0';i++,len++) 
dest[len] = orig[i]; 
dest[len] = '\0'; 
return dest;
}

//4) Outra forma de implementação:

char *strcat2(char *dest, char *orig) { 
	int i=0,len=strlen(dest); 
while (dest[i+len] = orig[i])
i++; 
return dest;
}

//4) Ainda outra forma de implementação:

char *strcat3(char *dest, char *orig) { 
	int i=0,len=strlen(dest); 
while (dest[len++] = orig[i++])
; 
return dest;
}

/*
Escreva um programa que leia nomes e sobrenomes de pessoas e os mostre na tela no formato Sobrenome, Nome. O programa deve terminar quando um nome vazio for introduzido.

Nome: Antônio
Sobrenome: Nunes
Nunes, Antônio
Nome:

Process returned 0 (0x0)   execution time : 11.207 s
Press any key to continue.


*/

