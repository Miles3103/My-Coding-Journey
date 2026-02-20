/* ************************************************************************** */
/* */
/* Project: 2D Array Matrix                                                   */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    // A 2x3 matrix (2 rows, 3 columns)
    int matrix[2][3] = { {1, 2, 3}, {4, 5, 6} };

    // Accessing row 1, column 2 (The number '6')
    printf("Value at matrix[1][2]: %d\n", matrix[1][2]);

    return (0);
}
