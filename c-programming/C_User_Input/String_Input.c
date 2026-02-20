/* ************************************************************************** */
/* */
/* Project: String Input Comparison                                           */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    char fullName[30];

    printf("Enter your full name: ");
    // fgets(variable, size, stream)
    fgets(fullName, sizeof(fullName), stdin);

    printf("Hello, %s", fullName);

    return (0);
}
