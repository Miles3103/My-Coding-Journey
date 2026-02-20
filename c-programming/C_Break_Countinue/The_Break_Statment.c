/* ************************************************************************** */
/* */
/* Project: Break Statement Example                                           */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    for (int i = 1; i <= 10; i++)
    {
        // If i is 5, stop the loop entirely
        if (i == 5)
        {
            printf("Breaking at %d...\n", i);
            break;
        }
        printf("%d ", i);
    }
    printf("\nLoop terminated.\n");

    return (0);
}
