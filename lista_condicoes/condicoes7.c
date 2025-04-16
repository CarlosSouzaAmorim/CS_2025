//condicoes7.c
//7- Escreva um programa que leia uma data e verifique se esta é válida ou não.
/*Regras para um ano ser bissexto:    É divisível por 4 e não é divisível por 100, ou é divisível por 400    */
#include <stdio.h>
int main() {
    int dia, mes, ano;
    int diasdomes;

    printf("Digite uma data no formato dd-mm-aaaa: ");
    scanf("%d-%d-%d", &dia, &mes, &ano);

    if (ano < 1 || mes < 1 || mes > 12 || dia < 1)
        printf("%02d/%02d/%04d é uma data inválida.\n", dia, mes, ano);

    switch (mes) {
        // Meses com 31 dias : Janeiro, Março, Maio, Julho, Agosto, Outubro e Dezembro
        // Meses com 30 dias : Abril, Junho, Setembro e Novembro
        // Fevereiro : 28 dias ou 29 se for bissexto

        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
        diasdomes = 31;
            break;
        case 4: case 6: case 9: case 11:
        diasdomes = 30;
            break;
        case 2:
            {
                if ( ( ano % 4 == 0 && ano % 100 != 0 ) || ( ano % 400 == 0 ))
                    diasdomes = 29;
                else
                    diasdomes = 28;
            }
            break;
        default:
            printf("%02d/%02d/%04d é uma data inválida.\n", dia, mes, ano);
    }

    if (dia <= diasdomes) {
        printf("%02d/%02d/%04d é uma data válida.\n", dia, mes, ano);
    } else {
        printf("%02d/%02d/%04d é uma data inválida.\n", dia, mes, ano);
    }

    return 21;
}
