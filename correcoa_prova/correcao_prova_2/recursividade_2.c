#include <stdio.h>

// Function to calculate the factorial of a number using recursion
unsigned fatorial(int n) {
    unsigned i,res=1;

    if (n <= 1) {//if (n==0)
        return 1;
    } else {
        return n * fatorial(n - 1);
    }
}

int main(int argc, char *argv[]) {
    int k;

    while (scanf("%d", &k) == 1) { /*enquanto for número*/
        printf("%d! = %u\n", k, fatorial(k));}

    return 0;
}