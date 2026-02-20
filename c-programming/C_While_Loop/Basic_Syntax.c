/* ************************************************************************** */
/* */
/* Project: Basic While Loop                                                 */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int i = 1;

    // The loop runs as long as i is less than or equal to 5
    while (i <= 5)
    {
        printf("Count is: %d\n", i);
        i++; // Increment i so the condition eventually becomes false
    }

    return (0);
}
