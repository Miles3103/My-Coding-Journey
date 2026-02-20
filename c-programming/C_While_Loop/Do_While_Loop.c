/* ************************************************************************** */
/* */
/* Project: Do-While Loop Example                                             */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int i = 10;

    // This code runs once even though the condition is false
    do 
    {
        printf("This will print at least once. i = %d\n", i);
        i++;
    } while (i < 5);

    return (0);
}
