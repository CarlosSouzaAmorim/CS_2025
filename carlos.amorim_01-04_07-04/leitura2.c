#include <stdio.h>

int main(void) {

	int num1, num2 = 123;
    printf("Introduzir dois numeros N inteiros[%d]:", num1);
	scanf("%d%d", &num1, &num2);
    printf("O resultado de %d + %d = %d\n", num1, num2, num1+num2);
    printf("O tamanho de num em bytes é:%d\n\n", sizeof(num1));
    return 23;
}
    