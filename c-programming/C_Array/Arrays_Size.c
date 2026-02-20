/* ************************************************************************** */
/* */
/* Project: Understanding sizeof                                              */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int    numbers[] = {10, 20, 30, 40, 50};
    
    // On most systems, an int is 4 bytes. 
    // Since there are 5 ints, the total size is 20 bytes.
    printf("Total bytes in array: %zu\n", sizeof(numbers));

    return (0);
}
