#include <stdio.h>
#include <stdlib.h>

#define MAX_LIN 1000
#define SINAL '-'

void Erro_Fatal(int num_erro, char *string){
    switch(num_erro){
    case 1: /* Mostrar a Sintaxe */
                fprintf(stderr,"Sintaxe:\n\nhead [-n] [Arq]\n\n");
                break;
    case 2: /* Erro de Abertura no arquivo */
       fprintf(stderr,"Imp. Abrir o arquivo '%s'\n", string);
    break;
    }
    exit(num_erro);
}


int main (int argc, char *argv[]){
    FILE *fp = stdin;  /* stdin: Por Padrão */
    char s[MAX_LIN+1]; /* String */
    int i=0; /* Nenhuma linha foi processada ainda */
    int n_lins = 10; /* 10 linhas: Por Padrão */
    switch(argc){
        case 1: break;
        case 2: if (argv[1][0] == SINAL)
                    n_lins = atoi(argv[1]+1);
                else
                if ((fp=fopen(argv[1],"r"))==NULL)
                    Erro_Fatal(2,argv[1]) ;
                break;

        case 3: if (argv[1][0] != SINAL)
                    Erro_Fatal(1,"");
                else {
                    n_lins = atoi(argv[1]+1);
                    if ((fp=fopen(argv[2],"r"))==NULL)
                    Erro_Fatal(2,argv[2]);
                    }
                break;

        default: Erro_Fatal (1,"");
    }
    while (fgets(s,MAX_LIN+1,fp)!=NULL && i++<n_lins)
        printf("%s", s);
    fclose(fp);

}
