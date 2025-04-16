//condicoes1.c
//Escreva um programa que indique quantos segundos tem um determinado número de horas.

#include <stdio.h>
int main() {
	int numeroHoras;
	puts("Insira o número de horas: ");
	scanf("%d", &numeroHoras);


    printf("Em %d horas há %d segundos.", numeroHoras, numeroHoras*3600);
    printf("\n");		
    return 0;
}
