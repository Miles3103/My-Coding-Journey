/* ************************************************************************** */
/* */
/* Project: Logical AND Operation                                             */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int age = 25;
    int has_license = 1; // 1 represents true

    // Both conditions must be true
    if (age >= 18 && has_license)
    {
        printf("You are allowed to drive, Miles3103.\n");
    }
    else
    {
        printf("You cannot drive.\n");
    }

    return (0);
}
