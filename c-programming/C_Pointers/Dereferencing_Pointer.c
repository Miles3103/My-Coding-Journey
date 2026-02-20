/* ************************************************************************** */
/* */
/* Project: Dereferencing Pointers                                            */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int   number = 10;
    int  *p = &number;

    // Change the value of 'number' using the pointer 'p'
    *p = 50;

    printf("The value of number is now: %d\n", number); // Prints 50

    return (0);
}
