/* ************************************************************************** */
/* */
/* Project: Basic Switch Statement                                            */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int day = 3;

    switch (day) 
    {
        case 1:
            printf("Monday\n");
            break;
        case 2:
            printf("Tuesday\n");
            break;
        case 3:
            printf("Wednesday\n");
            break;
        default:
            printf("Looking forward to the weekend!\n");
    }

    return (0);
}
