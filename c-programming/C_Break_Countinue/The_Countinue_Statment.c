/* ************************************************************************** */
/* */
/* Project: Continue Statement Example                                        */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    for (int i = 1; i <= 5; i++)
    {
        // If i is 3, skip the print and go to the next iteration
        if (i == 3)
        {
            printf("(Skipping 3) ");
            continue;
        }
        printf("%d ", i);
    }

    return (0);
}
