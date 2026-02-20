/* ************************************************************************** */
/* */
/* Project: Pointer Basics                                                    */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int     val = 42;
    int     *ptr = &val;  // 'ptr' holds the address of 'val'

    printf("Value of variable:   %d\n", val);
    printf("Address of variable: %p\n", (void *)&val);
    printf("Pointer is pointing to: %d\n", *ptr); // Dereferencing

    return (0);
}
