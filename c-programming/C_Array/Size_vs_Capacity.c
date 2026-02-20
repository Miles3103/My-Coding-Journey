/* ************************************************************************** */
/* */
/* Project: Capacity vs Usage                                                 */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    // This array has a capacity of 100, even if we only care about 2 numbers
    int    buffer[100] = {1, 2}; 

    printf("Total memory allocated: %zu bytes\n", sizeof(buffer)); 
    // Result will be 400 (if int is 4 bytes), NOT 8.

    return (0);
}
