//to upper
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h> 
int main(int argc, char *argv[]){
	FILE *fp;
	int ch; 
	switch(argc){
	case 1:	fp = stdin; break;
	case 2:	if((fp=fopen(argv[1],"r"))==NULL){
		fprintf(stderr,"Imp. abrir o arq %s\n",argv[1]);
		exit(1);
		}break;
	default:fprintf(stderr,"Sintaxe:\n\n%s [Arquivo]\n",argv[0]);
				 exit(2);
	}

	while((ch = fgetc(fp)) != EOF)
		putchar(toupper(ch));
	fclose(fp);
}


