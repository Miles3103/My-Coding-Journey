/* ************************************************************************** */
/* */
/* Project: String Declarations                                               */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    // Method 1: String Literal (Automatically adds \0)
    char name[] = "Miles3103";

    // Method 2: Character Array (Manual \0 required)
    char manual[] = {'H', 'i', '\0'};

    // %s is the format specifier for strings
    printf("Greeting: %s %s\n", manual, name);

    return (0);
}
