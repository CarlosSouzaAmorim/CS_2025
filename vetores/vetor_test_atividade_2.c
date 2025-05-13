#include <stdio.h>
/*
    COMENTÁRIOS PARA EXERCÍCIO:
    fazer o jogo da velha:
    [X] [ ] [O]
    [ ] [X] [ ]
    [ ] [ ] [O]
    
*/

#define DIM 3
#define ESPACO ' '

void inic(char s[][DIM]) {
    int i;
    int j;
    
    for(i=0;i<DIM;i++)
        for(j=0;j<DIM;j++)
            s[i][j]=ESPACO;
}

void mostra(char s[DIM][DIM]){
    int i;
    int j;

    for (i=0; i<DIM; i++){
        for (j=0; j<DIM; j++)
            printf("%c %c", s[i][j], j==DIM-1?' ':'|');
        if(i!=DIM-1)
            printf("\n--------\n");
    }
}

int verifica_jogo(char s[DIM][DIM], char jogador) {

    int i;
    int j;

    for (i = 0; i < DIM; i++) {
        int venceu = 1;
        for (j = 0; j < DIM; j++) {

            if (s[i][j] != jogador)
            {

                venceu = 0;
                break;
            }
        }
        if (venceu)
            return 1;
    }

    //colunas
    for (j = 0; j < DIM; j++) {
        int venceu = 1;

        for (i = 0; i < DIM; i++) {
            if (s[i][j] != jogador) 
            {
                venceu = 0;
                break;
            }
        }
        if (venceu)
            return 1;
    }

    //DIAGONAIS:
        int venceu = 1;
        for (i = 0; i < DIM; i++) {
            if (s[i][i] != jogador) 
            {
                venceu = 0;
                break;
            }
        }
        if (venceu)
            return 1;

        venceu = 1;
        for (i = 0; i < DIM; i++) {
            if (s[i][DIM - i - 1] != jogador) 
            {
                venceu = 0;
                break;
            }
        }
        if (venceu)
            return 1;

    return 0;
}

int main (int argc, char *argv[]){

    char Velha[DIM][DIM]= 	{	{' ',' ',' '},
                                {' ',' ',' '},
                                {' ',' ',' '}
                            };

    int posx, posy;
    char ch = 'O'; 
    int n_jogadas = 0;

    inic(Velha);

    while(1) {
        mostra(Velha);
        printf("\nIntroduza a Posição de Jogo Linha Coluna: ");
        scanf ("%d %d",&posx,&posy);
        posx--;posy--; /* Pois os índices do vetor começam em 0 */
        if(Velha[posx][posy] == ESPACO){ /*Casa Livre */
            Velha[posx][posy] = ch = (ch == 'O') ? 'X' : 'O';
            n_jogadas++;

            if ( verifica_jogo(Velha, Velha[posx][posy]) ) {
                mostra(Velha);
                
                printf("\nJogador '%c' venceu!\n", Velha[posx][posy]);
                break;
            }

        } else
            printf("Posição já ocupada\nJogue Novamente!!!\n");

        if(n_jogadas == DIM*DIM) {
            printf("\nEMPATOU! Sem posições restantes.\n");
            break; 
        }
    }

    mostra(Velha);

    printf ("\n\nFim!\n\n");

}