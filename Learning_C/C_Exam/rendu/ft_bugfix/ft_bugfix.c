/* ft_bugfix.c
** Author: Miles3103
** Date: 2024
** Description: Demonstrates commented-out buggy code with a fix active.
*/

#include <stdio.h>

int main(void)
{
    int a = 6;
    int b = 4;

    // int result = a * b;  /* BUG: should be addition, not multiplication */
    int result = a + b;     /* FIX: correct operation — adds a and b */

    printf("Sum: %d\n", result);
    return (0);
}
