#include <stdio.h>

#define LEN_DEF 30

// int strcount(char *s)/*string count digit*/
// {
// for (i=conta=)0; s[i] != '\0'; i++)
//     if (s[i] == 'ch')//se for o caracter procurado
//         conta++;
//     // else if (s[i] == '\n')
//     //     conta++;
//     // else if (s[i] == '\t')
//     //     conta++;
//     // else if (s[i] == '\v')
//     //     conta++;
//     // else if (s[i] == '\f')
//     //     conta++;
//     // else if (s[i] == '\r')
//     conta++;
//     return conta;
// }

/* 

*/
int strcount(char *s)/*string count digit*/
{
    int i, conta=0;
    for (i=0; s[i] != '\0'; i++)
        if (s[i] == 'ch')//se for o caracter procurado
            conta++;
        // else if (s[i] == '\n')
        //     conta++;
        // else if (s[i] == '\t')
        //     conta++;
        // else if (s[i] == '\v')
        //     conta++;
        // else if (s[i] == '\f')
        //     conta++;
        // else if (s[i] == '\r')
        conta++;
    return conta;
}

//10 string compare
int strcomp(char *s1, char *s2)
{
    int i;
    for (i=0; s1[i] != '\0' && s2[i] != '\0'; i++)
        if (s1[i] != s2[i])
            return 0;
    if (s1[i] == '\0' && s2[i] == '\0')
        return 1;
    else
        return 0;
}
int strcomp2(char *s1, char *s2)
{
    int i;
    while (s1)
    {
        /* code */
    }
    }

char *strrev(char *s)
{
    int i, j;
    char *t;
    t = (char *)malloc(strlen(s)+1);
    if (t == NULL)
        return NULL;
    for (i=0, j=strlen(s)-1; i<strlen(s); i++, j--)
        t[i] = s[j];
    t[i] = '\0';
    return t;
}


int idfchr(char *s, char c)
{
    int i;
    for (i=0; s[i] != '\0'; i++)
        if (s[i] == c)
            return i;
    return -1;
}

int indchr2(char *s, char c)
{
    int i;
    while (s)
    {
        /* code */
    }
}

int strpalindrome(char *s)
{
    int i, j;
    for (i=0, j=strlen(s)-1; i<j; i++, j--)
        if (s[i] != s[j])//se os char nao sao iguais
            return 0;//nao é palindromo
    return 1;
}




int main(int argc, char* argv[])
{
    char stringizinha[LEN_DEF] = {'o', 'i'};    
    printf("O tamanho da string é: %d", strcount(stringizinha));
    return 23;
}