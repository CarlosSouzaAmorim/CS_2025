//condicoes3.c
//Altere o programa anterior de tal forma que permita indicar, a partir de um determinado número de horas,
// quais os minutos, os segundos ou mesmo os décimos de segundo que esse número de horas contém.
//3- Resolva o mesmo enunciado utilizando um switch.

#include <stdio.h>
int main() {
	int numeroHoras;
    char mostraHoras;

	puts("Insira qual exibição (M minutos, S segundos, D décimos de segundos):");
	mostraHoras = getchar();

	puts("Insira o número de horas: ");
	scanf("%d", &numeroHoras);

/*
    if (mostraHoras == 'M') {
        printf("Em %d horas há %d minutos.\n", numeroHoras, numeroHoras*60);
    }
    else if (mostraHoras == 'S') {
        printf("Em %d horas há %d segundos.\n", numeroHoras, numeroHoras*3600);
    }
    else if (mostraHoras == 'D') {
        printf("Em %d horas há %d décimos de segundos.\n", numeroHoras, numeroHoras*3600*10);
    }
    else printf("Opção inválida!"); */

	switch (mostraHoras)
	{
		case 'm': 
		case 'M':
                printf("Em %d horas há %d minutos.\n", numeroHoras, numeroHoras*60);
                break;
		case 's': 
		case 'S':
                printf("Em %d horas há %d segundos.\n", numeroHoras, numeroHoras*3600);        
                break;
		case 'd':
		case 'D':
                printf("Em %d horas há %d décimos de segundos.\n", numeroHoras, numeroHoras*3600*10);
                break;
		default : printf("Opção inválida!");
	}		


    printf("\nFim\n");		
    return 0;
}


