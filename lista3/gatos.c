#include <stdio.h>

int main() {
    float pesoSacoKg, pesoSacoGramas, racaoPorGato, racaoTotalConsumida, racaoRestante;

    // Entrada: peso do saco de ração em quilos
    printf("Digite o peso do saco de ração (em kg): ");
    scanf("%f", &pesoSacoKg);

    // Entrada: quantidade de ração fornecida para cada gato por dia (em gramas)
    printf("Digite a quantidade de ração fornecida para cada gato por dia (em gramas): ");
    scanf("%f", &racaoPorGato);

    // Convertendo o peso do saco de ração para gramas
    pesoSacoGramas = pesoSacoKg * 1000;

    // Calculando a quantidade total de ração consumida pelos dois gatos em 5 dias
    racaoTotalConsumida = 2 * racaoPorGato * 5;

    // Calculando a quantidade de ração restante no saco
    racaoRestante = pesoSacoGramas - racaoTotalConsumida;

    // Saída: quantidade de ração restante no saco
    printf("Após 5 dias, restará %.2f gramas de ração no saco.\n", racaoRestante);

    return 0;
}