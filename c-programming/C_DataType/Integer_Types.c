/* ************************************************************************** */
/* */
/* Project: Integer Types                                                     */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int      count = -1024;       // Standard signed integer (%d)
    unsigned int steps = 5000U;   // Positive only (%u)
    long     gold = 8000000L;     // Larger range (%ld)

    printf("Count: %d | Steps: %u | Gold: %ld\n", count, steps, gold);

    return (0);
}
