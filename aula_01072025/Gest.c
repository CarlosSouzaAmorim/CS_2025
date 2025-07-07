#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define MAX 60

//STRUCTS
// Define a estrutura Registro para armazenar o nome e o número
// Define a estrutura List para armazenar os registros e o índice atual
// Define as funções para manipular a lista de registros

// Define o tamanho máximo da lista
#define MAX 60

struct Registro{
  char Nome[40];
  unsigned int num;
};


struct List{
  struct Registro data[MAX];
  char i;
};



char Atualiza(struct List *list){
  unsigned int i=-1;

  do{
    printf("Digite a posição para alterar: ");
    scanf("%u", &i);
    if(0 < --i || i >= list->i){
      puts("Posição inválida!");
    }
  }while(0>i && i<list->i);

  printf("Entre o número ");
  scanf("%u", &list->data[i].num);
  getchar();

  printf("Entre o nome ");
  fgets(list->data[i].Nome, sizeof(list->data[i].Nome), stdin);
  list->data[i].Nome[strcspn(list->data[i].Nome, "\n")] = 0;

  return 1;
}




void mover_Para_Esquerda(void *arr, unsigned int n, unsigned int size) {
  char *_arr = (char *)arr;
  unsigned int total = (n - 1) * size;

  for (unsigned int i = 0; i < total; i++) {
    _arr[i] = _arr[i + size];
  }
}

void Inicializar(struct List *list){
  for(int i=0; i < MAX; i++)
    list->i = 0;
}

char Inserir(struct List *list){
  if (list->i == MAX){
    puts("Lista cheia!");
    return -1;
  }

  struct Registro r;

  printf("Entre o número ");
  scanf("%u", &r.num);
  getchar();

  printf("Entre o nome ");
  fgets(r.Nome, sizeof(r.Nome), stdin);
  r.Nome[strcspn(r.Nome, "\n")] = 0;

  list->data[list->i]= r;

  return list->i++;
}

char Excluir(struct List *list) {
  unsigned int pos;

  do {
    printf("Digite uma posição (1 até %d): ", list->i);
    scanf("%d", &pos);
    pos--;

    if (pos < 0 || pos >= list->i) {
        puts("Posição inválida!");
    }
  } while (pos < 0 || pos >= list->i);

  mover_Para_Esquerda(&list->data[pos], list->i - pos, sizeof(struct Registro));
  list->i--;
  return 1;
}


void Listar(struct List *list){
  if (list->i == 0) {
    puts("List vazia.");
    return;
  }

  for (int i = 0; i < list->i; i++) {
    printf("Posicao %d: Numero: %d | Nome: %s\n",
      i+1, list->data[i].num, list->data[i].Nome);
  }

}




char Load(struct List *list, char *Nome){
  FILE *file = fopen(Nome, "rb");
  if(!file)
    return 0;

  fread(list, sizeof(struct List), MAX, file);

  fclose(file);
  return 1;
}

char Save(struct List *list, char *Nome){
  FILE *file = fopen(Nome, "wb");
  if(!file)
    return 0;

  fwrite(list, sizeof(struct List), MAX, file);

  fclose(file);
  return 1;
}







unsigned char Mostra_Menu(){
  unsigned char Opcao;
  do
  {
    puts(" -- Menu --");
    puts(" 1 - Inserir Registro");
    puts(" 2 - Alterar Registro");
    puts(" 3 - Apagar Registro");
    puts(" 4 - Listar Registros");
    puts(" 5 - Pesquisar");
    puts(" 6 - Limpar");
    puts(" 0 - Sair");

    scanf(" %c", &Opcao);
    
    switch (Opcao){
    case '0':
    case '1':
    case '2':
    case '3':
    case '4':
      return Opcao - '0';
    case '5':
      do{
        puts(" 1 - Pesquisar por Intervalo de Idades");
        puts(" 2 - Pesquisar por Nome");
        puts(" 0 - Voltar");

        scanf(" %c", &Opcao);
        
        switch (Opcao){
          case '1':
            return 5;
          case '2':
            return 6;
          case '0':
            break;
          default:
            puts("Opcao invalida!");
            break;
        }
      }while(Opcao != '0');
      break;
    case '6':
      return 7;
    default:
      puts("Opcao invalida!");
      break;
    }
  } while(1);
}

void Procurar(struct List *list, char target){

  char buff[20];
  unsigned int i=0;
  unsigned int val=-1;
  
  switch(target){
  case 0:
    printf("Digite um número: ");
    scanf("%d", &val);

    for(i=0;i<list->i;i++){
      if(list->data[i].num == val){
        printf(
          "Posicao %d: Número: %d | nome: %s\n",
          i+1, list->data[i].num, list->data[i].Nome
        );
      }
    }
    break;
  case 1:
    printf("Digite um nome: ");
    scanf("%s", &buff);

    for(i=0;i<list->i;i++){
      if(strcmp(list->data[i].Nome, buff)){
        printf("Posicao %d: Numero: %d | nome: %s\n", i+1, list->data[i].num, list->data[i].Nome);
      }
    }
    break;
  }
}


int main(){

  struct List list;

  Inicializar(&list);
  
  unsigned char Escolha=1;

  while(Escolha){
    Escolha = Mostra_Menu();
    if(!Escolha)break;
    switch (Escolha){
    case 1:
      Inserir(&list);
      break;
    case 2:
      Atualiza(&list);
      break;
    case 3:
      Excluir(&list);
      break;
    case 4:
      Listar(&list);
      break;
    case 5:
      Procurar(&list, 0);
      break;
    case 6:
      Procurar(&list, 1);
      break;

    case 7:
      system(
        #ifdef __WIN32
          "cls"
        #else
          "clear"
        #endif
      );
    default:
      break;
    }
  }


  return 0;


}