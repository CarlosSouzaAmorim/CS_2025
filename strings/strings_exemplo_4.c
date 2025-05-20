#include <stdio.h>

//slide 20
void imprimeString(char texto[]) {
	printf("Texto: %s\n", texto);
}

main() {
	char nome[] = "Maria";
	imprimeString(nome);
}
