#include <stdio.h>

// Function prototypes
int add(int a, int b);
int multiply(int a, int b);
void funcao_1(void);

int main(int argc, char *argv[]) {
    // Print the program arguments
    if (argc < 2) {
        printf("No arguments provided.\n");
    }
    else{
            printf("Program arguments:\n");
    for (int i = 0; i < argc; i++) {
        printf("argv[%d]: %s\n", i, argv[i]);
    }
    }

    // Example usage of the functions
    int num1 = 5, num2 = 10;
    printf("Addition of %d and %d is: %d\n", num1, num2, add(num1, num2));
    printf("Multiplication of %d and %d is: %d\n\n", num1, num2, multiply(num1, num2));
    funcao_1;


    return 0;
}

// Function to add two integers
int add(int a, int b) {
    return a + b;
}

// Function to multiply two integers
int multiply(int a, int b) {
    return a * b;
}
void funcao_1(void) {
    printf ("Function 1!\n\n");
}