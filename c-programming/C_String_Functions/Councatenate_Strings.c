/* ************************************************************************** */
/* */
/* Project: String Concatenation                                              */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>
#include <string.h>

int main(void)
{
    char str1[20] = "Hello ";
    char str2[] = "Miles!";

    strcat(str1, str2);
    printf("%s\n", str1); // Output: Hello Miles!

    return (0);
}
