#include <stdio.h>

int main(void) {
    short int   idade;
    int         montante;
    long int    conta;

    printf("O tamanho em bytes do idade = [%d]:%hd\n", sizeof(idade),idade);
    printf("O tamanho em bytes do montante = [%d]:%d\n", sizeof(montante),montante);
    printf("O tamanho em bytes do conta = [%d]:%ld\n\n", sizeof(conta),conta);


    printf("Informe a idade (numero N inteiro): ");
	scanf("%hd", &idade);

    printf("Informe o montante (numero N inteiro): ");
	scanf("%d", &montante);

    printf("Informe o numero da conta: (numero N inteiro): ");
	scanf("%ld", &conta);

  

    printf("\nFoi depositado R$ %d na conta %ld do usuário de %hd anos de idade.\n\n", montante, conta, idade);

    return 23;
}
    