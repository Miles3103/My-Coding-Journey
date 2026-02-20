/* ************************************************************************** */
/* */
/* Project: Boolean Logic (Modern C99+)                                       */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>
#include <stdbool.h> // Required for 'bool' type

int main(void)
{
    bool is_coding_fun = true;
    bool is_finished = false;

    if (is_coding_fun)
    {
        printf("Keep going, Miles3103!\n");
    }

    // Booleans are still integers under the hood (1 or 0)
    printf("True is: %d\n", is_coding_fun);
    printf("False is: %d\n", is_finished);

    return (0);
}
