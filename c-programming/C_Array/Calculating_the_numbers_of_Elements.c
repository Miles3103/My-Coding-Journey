/* ************************************************************************** */
/* */
/* Project: Array Length Calculation                                          */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    double measurements[] = {1.2, 3.5, 8.9, 4.2, 10.1, 7.7};

    // Calculate length
    int length = sizeof(measurements) / sizeof(measurements[0]);

    printf("The array has %d elements.\n", length);

    // Now you can use 'length' safely in a loop
    for (int i = 0; i < length; i++) {
        printf("Value %d: %.1f\n", i, measurements[i]);
    }

    return (0);
}
