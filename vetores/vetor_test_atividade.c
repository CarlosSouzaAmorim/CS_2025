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

void inic(char s[][DIM]) {/* Omitir uma dimensão */
	int i,j;
	for(i=0;i<DIM;i++)
		for(j=0;j<DIM;j++)
			s[i][j]=ESPACO;
}

void mostra(char s[DIM][DIM]){ /* Ambas as Dimensões */
	int i, j;
for (i=0; i<DIM; i++){
	for (j=0; j<DIM; j++)
		printf("%c %c", s[i][j], j==DIM-1?' ':'|');
	if(i!=DIM-1)
		printf("\n--------\n");
}
}


int main (int argc, char *argv[]){
    char Velha[DIM][DIM];
    int posx, posy;
    char ch = 'O'; /*Caractere para jogar */
    int n_jogadas = 0;

    inic(Velha);

while(1) {/*Laço infinito */
	mostra(Velha);
	printf("\nIntroduza a Posição de Jogo Linha Coluna: ");
	scanf ("%d %d",&posx,&posy);
	posx--;posy--; /* Pois os índices do vetor começam em 0 */
	if(Velha[posx][posy] == ESPACO){ /*Casa Livre */
		Velha[posx][posy] = ch = (ch == 'O') ? 'X' : 'O';
		n_jogadas++;
} else
	printf("Posição já ocupada\nJogue Novamente!!!\n");
}

if(n_jogadas == DIM*DIM)
	break; /*Encerra o programa*/
}
mostra(Velha);



}


	char Velha[DIM][DIM]= 	{	{' ',' ',' '},
                           		{' ',' ',' '},
    	                        {' ',' ',' '}
                            };
	int i, j;
	
	Velha [0][0] = 'X';
    Velha [1][1] = 'X';
    Velha [0][2] = 'O';
    Velha [2][2] = 'O';

    for (i=0; i<DIM; i++){
        for (j=0; j<DIM; j++)
            printf("%c %c", Velha [i][j], j==DIM-1?' ':'|');
        if(i!=DIM-1)
            printf("\n--------\n");

    }




    printf ("\n\nFim!\n\n");

}




    
