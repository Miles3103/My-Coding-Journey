/* ************************************************************************** */
/* */
/* Project: Infinite Loop Example                                             */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

/**
 * WARNING: This program will not stop on its own.
 * To stop an infinite loop in the terminal, press: Ctrl + C
 */
int    main(void)
{
    // 1 is always True in C, so this condition never fails
    while (1) 
    {
        printf("This will run forever!\n");
    }

    return (0);
}
