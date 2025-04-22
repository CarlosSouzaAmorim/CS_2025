#include <stdio.h>
//laços de repetição 1

int main(){



    int n;
    int i;

    printf("Introduza um número: ");
    scanf("%d", &n);

    i=1;

    while (i<=10)
    {
        printf ("%2d * %2d\n", i, n);
        i = i + 1;
    }
    
    return 23;

}