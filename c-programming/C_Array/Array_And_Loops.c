/* ************************************************************************** */
/* */
/* Project: Looping Through Arrays                                            */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int    data[] = {10, 20, 30, 40, 50}; // Compiler counts size automatically
    int    length = sizeof(data) / sizeof(data[0]); // Formula to get array size

    for (int i = 0; i < length; i++)
    {
        printf("Element at index %d is %d\n", i, data[i]);
    }

    return (0);
}
