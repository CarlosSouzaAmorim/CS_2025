#include <stdio.h>
/*
    COMENTÁRIOS PARA EXERCÍCIO:
    fazer o jogo da velha:
    [X] [ ] [O]
    [ ] [X] [ ]
    [ ] [ ] [O]
    
*/
#define DIM 3

main(){
[...]
Velha [2][2] = 'O';

for (i=0; i<DIM; i++){
	for (j=0; j<DIM; j++)
		printf("%c %c", Velha [i][j], j==DIM-1?' ':'|');
	if(i!=DIM-1)
		printf("\n--------\n");
}
}



#include <stdio.h>
/*
    COMENTÁRIOS PARA EXERCÍCIO:
*/
int main (int argc, char *argv[])
{


    printf ("\n\nFim!\n\n");
    
    return 0;
}