/* ************************************************************************** */
/* */
/* Project: The Secret Life of Chars                                         */
/* Author:  Miles3103                                                        */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    // A char is stored using 1 byte (8 bits)
    char letter = 'A';
    char symbol = '@';
    
    // You can even define a char using its ASCII number!
    char mystery = 33; 

    printf("--- Miles3103's Character Lab ---\n\n");

    // 1. Printing as a character vs. a number
    printf("The variable 'letter' is: %c\n", letter);
    printf("The ASCII value of '%c' is: %d\n\n", letter, letter);

    // 2. Character Math (The "Pro" Trick)
    // Adding 1 to 'A' makes it 'B' because 65 + 1 = 66
    printf("Character Math: %c + 1 = %c\n", letter, letter + 1);
    
    // 3. Printing the mystery char
    printf("The mystery character (ASCII 33) is: %c\n", mystery);

    return (0);
}
