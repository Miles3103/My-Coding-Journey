/* ************************************************************************** */
/* */
/* Project: Logical OR Operation                                              */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int is_weekend = 1;
    int is_holiday = 0;

    // If either is true, the block runs
    if (is_weekend || is_holiday)
    {
        printf("Time to relax and code!\n");
    }

    return (0);
}
