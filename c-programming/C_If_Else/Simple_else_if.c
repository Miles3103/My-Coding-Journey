/* ************************************************************************** */
/* */
/* Project: Multi-Condition Grading                                           */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int age = 16;

    if (age >= 18)
    {
        printf("You are an adult.\n");
    }
    else if (age >= 13)
    {
        printf("You are a teenager.\n");
    }
    else
    {
        printf("You are a child.\n");
    }

    return (0);
}
