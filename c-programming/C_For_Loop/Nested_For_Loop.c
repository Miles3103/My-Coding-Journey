/* ************************************************************************** */
/* */
/* Project: Nested Loop Pattern                                               */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    // Outer loop for rows
    for (int i = 1; i <= 3; i++)
    {
        // Inner loop for columns
        for (int j = 1; j <= 3; j++)
        {
            printf("* ");
        }
        printf("\n"); // Move to next line after inner loop finishes
    }

    return (0);
}
