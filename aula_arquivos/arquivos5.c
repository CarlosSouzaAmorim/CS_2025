//test fputc e fgetc
#include <stdio.h>
#include <stdlib.h> 
main(int argc, char *argv[]){
    FILE *fin, *fout;
    int ch; 
    if(argc != 3){
        printf("Sintaxe: \n\n%s Origem Destino\n\n",argv[0]);
        exit(1); 
    }
    /*abrir arquivo de origem */
    fin = fopen(argv[1],"rb");
    if(fin == NULL){
        printf("Impossivel abrir o arquivo %s\n",argv[1]);
        exit(2);
    }
    /*abrir arquivo de destino */
    if((fout = fopen(argv[2],"wb"))==NULL){
        printf("Impossivel criar o arquivo %s\n",argv[2]);
        exit(3);
    }
    while((ch=fgetc(fin)) != EOF)
        fputc(ch, fout);
    fclose(fin);fclose(fout);
}
