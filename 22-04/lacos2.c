#include <stdio.h>
//laços de repetição 1

int main(){



    int n;
    int i;
    int j;

/*    printf("Introduza um número: ");
    scanf("%d", &n);*/

    j=1;

    while (j<=10)
    {
        i=1;
        while (i<=10)
        {
            printf ("%2d * %2d = %2d   ", j, i, j*i);
            i = i + 1;
        }
        j++;
        printf("\n");
    }
    
    return 23;

}