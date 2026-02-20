/* ************************************************************************** */
/* */
/* Project: Comparison and Logic                                              */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int x = 5, y = 10;

    // Relational: ==, !=, >, <, >=, <=
    printf("Is x equal to y?    %d\n", x == y); 

    // Logical: && (AND), || (OR), ! (NOT)
    if (x < y && y > 0)
    {
        printf("Both conditions are true!\n");
    }

    return (0);
}
