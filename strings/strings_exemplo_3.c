#include <stdio.h>
//slide 19
main(){
    char Nome[100];
    while (1) { /* Laço Infinito */
        puts ("Nome: "); 
        gets(Nome); 
        if (Nome[0]=='\0')	/*Se a string estiver  */
        break;				/*vazia terminar o laço*/
        else 
        printf("Nome Introduzido: %s\n",Nome); 
    } /* Fim do Laço Infinito */
}
