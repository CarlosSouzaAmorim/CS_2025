#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int main() {
	char s[200], *ptr;
	printf("Qual a sua String? ");
							fgets(s, 1, stdin);
	/* Alocar memória necessária */
	ptr = (char *) malloc(strlen(s)+1); /* '\0' também conta */
	if (ptr==NULL)
		puts("Problemas na Alocação da Memória");
	else {
		/*Colocar na string outra uma cópia da string s */
		strcpy(ptr,s);
		/* Mostrar as duas strings */
		printf("String Original: %s\nCópia: %s\n",s,ptr);
		/* Liberar a memória existente em ptr */
		free(ptr);
	}
return 0; }



