/* ************************************************************************** */
/* */
/* Project: String Handling                                                   */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    // The compiler automatically adds \0 at the end
    char    name[] = "Miles3103";

    // %s is the format specifier for strings
    printf("Hello, %s!\n", name);

    return (0);
}
