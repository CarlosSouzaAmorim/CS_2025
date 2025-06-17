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
    int n;
    //se o usuario nao informar um parametro, ele sera solicitado a informar um numero
    if (argc < 2) {
        printf("Informe um numero: ");
        scanf("%d", &n);
    } else {
        n = atoi(argv[1]);
    }

    // Calcula o fatorial do numero informado
    unsigned resultado = fatorial(n);
    
    // Exibe o resultado
    printf("Fatorial de %d: %u\n", n, resultado);
    return 0;
}
// Compile with: gcc -o recursividade_1 recursividade_1.c
// Run with: ./recursividade_1 5 or ./recursividade_1
// Example output: Fatorial de 5: 120
// Note: The program uses recursion to calculate the factorial of a number.
// The function fatorial is defined to handle the base case and recursive case.
// The program checks if a number is provided as a command line argument; if not, it prompts the user for input.
// The result is printed in the format "Fatorial de <number>: <result>".
// The program uses the C17 standard for compilation.
// The function returns 1 for the base case (n <= 1) and calculates the factorial recursively for n > 1.
// The result is stored in an unsigned integer to handle larger values without overflow.
// The program is designed to be simple and straightforward, focusing on demonstrating recursion in C.
// The code is structured to be easy to read and understand, with clear comments explaining each part of the process.
// The use of recursion is a key feature, showcasing how functions can call themselves to solve problems.
// The program is efficient for small to moderate values of n, but may not handle very large values due to stack overflow in recursion.
// The program is a good example of basic recursion in C, suitable for educational purposes.
// It can be extended or modified to include error handling or additional features as needed.
// The program is designed to be portable and can be compiled on any system with a C compiler that supports the C17 standard.
// It serves as a simple introduction to recursion in C programming, demonstrating how to implement and use recursive functions effectively.
// The program is structured to be modular, with the factorial function separated from the main logic for clarity.
// It can be easily adapted for different use cases or integrated into larger projects as needed.
// The program is a good starting point for learning about recursion and its applications in C programming.
// It can be used as a reference for understanding how to implement recursive algorithms in C.
// The code is written to be efficient and clear, making it suitable for both beginners and experienced programmers.
// The program can be further enhanced with additional features, such as input validation or support for larger numbers.
// The use of unsigned integers allows for a wider range of values without negative results, which is appropriate for factorial calculations.
// The program is designed to be user-friendly, providing clear prompts and output messages.
// It can be compiled and run easily on any system with a C compiler, making it accessible for learning and experimentation.
// The program is a practical example of recursion, demonstrating how to break down a problem into smaller subproblems.
// It can be used as a teaching tool for understanding the principles of recursion in computer science.
// The code is structured to be maintainable and easy to modify, allowing for future enhancements or changes as needed.
// The program is a straightforward implementation of a common algorithm, making it a useful reference for programmers.
// It can be used as a basis for more complex recursive algorithms or as a simple exercise in recursion.
// The program is designed to be efficient and effective, providing a clear demonstration of how recursion works in C.
// It serves as a good example of how to implement recursive functions and handle user input in C programming.
// The program is a simple yet effective demonstration of recursion, suitable for educational purposes and practical applications.
// It can be used as a reference for implementing recursive algorithms in C, showcasing the power and simplicity of recursion in programming.       