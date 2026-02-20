/* ************************************************************************** */
/* */
/* Project: Array Initialization                                              */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    // Declaring and initializing an array of 4 integers
    int    my_numbers[4] = {25, 50, 75, 100};

    // Accessing elements (Indices start at 0!)
    printf("First element:  %d\n", my_numbers[0]);
    printf("Second element: %d\n", my_numbers[1]);

    // Changing an element
    my_numbers[0] = 33;
    printf("Updated first element: %d\n", my_numbers[0]);

    return (0);
}
