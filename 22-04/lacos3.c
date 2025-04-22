#include <stdio.h>
//laços de repetição 1

int main(){



//    int n;
    char opcao;
    int i, i_init, i_final;
    int j, j_init, j_final;

    printf("Calcula TABUADA\n");
    printf("Indique o valor inicial e final para coluna (nn nn):");
    scanf("%d %d", &i_init, &i_final);

    printf("Indique o valor inicial e final para linha:");
    scanf("%d %d", &j_init, &j_final);

    printf("i_init %d i_final %d j_init %d j_final %d ", i_init, i_final, j_init, j_final);
    scanf("%c", &opcao);
    scanf("%c", &opcao);

    j=j_init;

    while (j<=j_final)
    {
        i=i_init;
        while (i<=i_final)
        {
            printf ("%2d * %2d = %2d   ", j, i, j*i);
            i = i + 1;
        }
        j++;
        //printf("\n");
        puts("\n");
    }
    
    return 23;

}