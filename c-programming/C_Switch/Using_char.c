/* ************************************************************************** */
/* */
/* Project: Grade Checker                                                     */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    char grade = 'B';

    switch (grade)
    {
        case 'A':
            printf("Excellent!\n");
            break;
        case 'B':
        case 'C':
            printf("Well done!\n"); // Both B and C will trigger this
            break;
        case 'D':
            printf("You passed.\n");
            break;
        case 'F':
            printf("Better try again.\n");
            break;
        default:
            printf("Invalid grade.\n");
    }

    return (0);
}
