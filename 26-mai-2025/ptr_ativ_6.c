int main() {
    char str[100], ch;
    char *result;

    // Prompt the user for input
    printf("Introd. uma string: ");
    scanf("%99s", str); // Read a string (up to 99 characters)

    printf("Introd. um char: ");
    scanf(" %c", &ch); // Read a character

    // Find the character in the string
    result = strchr(str, ch);

    if (result) {
        // If found, print the substring starting from the character
        printf("%s\n", result);
    } else {
        // If not found, print a message
        printf("Caractere '%c' não encontrado na string.\n", ch);
    }

    return 0;
}