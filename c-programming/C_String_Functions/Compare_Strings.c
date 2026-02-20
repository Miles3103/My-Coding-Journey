/* ************************************************************************** */
/* */
/* Project: String Comparison                                                 */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>
#include <string.h>

int main(void)
{
    char s1[] = "Apple";
    char s2[] = "Apple";
    char s3[] = "Banana";

    // Returns 0 if equal
    if (strcmp(s1, s2) == 0) {
        printf("s1 and s2 are equal.\n");
    }

    if (strcmp(s1, s3) != 0) {
        printf("s1 and s3 are different.\n");
    }

    return (0);
}
