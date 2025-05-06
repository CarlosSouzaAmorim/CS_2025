#include <stdio.h>

int main (int argc, char *argv[])
{
    int vet1[0]={10, 2};
    int vet2[0];
    int vet3[]={0,1,2,3};
    int vet4[3]={5,6,7,89,9};

    int vetor[] = {10,20};

    printf("%d\n", vet1[0]);
    printf("%d\n", NULL);
    printf("%d\n", vet2[0]);

    printf("vet4[2]: %d\n", vet4[2]);
    printf("vet4[3]: %d\n", vet4[3]);
    printf("vet4[4]: %d\n", vet4[4]);

    for (int i=0; i<sizeof(vet3)/sizeof(int)*10; i++) printf("vet [%d] %d\n", i, vet3[i]);


    //for (int i=0; i<sizeof(vet3)/sizeof(int)*10; i++) vet3[i]=3;

    for (int i=0; i<sizeof(vet3)/sizeof(int)*10; i++) printf("vet [%d] %d\n", i, vet3[i]);

    printf("\n\n");
    
    /* 
    int i;	
        for (i=0 ; i<=255 ; i++) printf("%3d -> %c\n",i, (char) i);

    return 0;
    */

}