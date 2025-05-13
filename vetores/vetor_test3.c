#include <stdio.h>
/*
    COMENTÁRIOS PARA EXERCÍCIO:
    fazer o jogo da velha:
    [X] [ ] [O]
    [ ] [X] [ ]
    [ ] [ ] [O]
    
*/
#define colunas 3
#define linhas  3

int inicializa_vetor(char *vetor_2, char vetor_3[][3]){

    //eu nao queria mesmo
    //vetor_1 = {'X', 'e', 'l', 'h', 'a', '-', 'e','h','s'};
    //printf("%s", vetor_2);]
    
    for (int i=0; i<colunas; i++){
        for (int i2=0; i2<linhas; i2++){
            vetor_3[i][i2] = vetor_2[(3*i)+i2];
            //printf(" %c ", vetor_2[i*i2]);

        }
        //putchar('\n');


    }
    // for (int i=1; i<=colunas; i++){
    //     for (int i2=1; i2<=linhas; i2++){
    //         vetor_3[i-1][i2-1] = vetor_2[(i*i2)-1];
    //         //printf(" %c ", vetor_2[i*i2]);

    //     }
    //     //putchar('\n');


    // }

    
    return 0;
}
int mostra_vetor(char vetor_1[][colunas]){
    for (int i=0; i<colunas; i++){
        for (int i2=0; i2<linhas; i2++){
            printf(" %c ", vetor_1[i][i2]);
        }
        putchar('\n');


    }
    
    return 0;
}
int main (int argc, char *argv[])
{

    char velha [colunas][linhas] = {'v', 'e', 'l', 'h', 'a', '-', 'e','h','s'};

    mostra_vetor(velha);

    char velha2[9] = {'X', ' ', ' ', ' ', 'X', ' ', ' ',' ','O'};

    printf ("\n\n");

    inicializa_vetor(velha2, velha);

    mostra_vetor(velha);

    printf ("\n\nFim!\n\n");
    
    return 0;
}