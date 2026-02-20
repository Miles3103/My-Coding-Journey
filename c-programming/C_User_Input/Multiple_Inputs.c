/* ************************************************************************** */
/* */
/* Project: Multiple Inputs                                                   */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int day, month, year;

    printf("Enter date (dd mm yyyy): ");
    scanf("%d %d %d", &day, &month, &year);

    printf("Date saved: %02d/%02d/%d\n", day, month, year);

    return (0);
}
