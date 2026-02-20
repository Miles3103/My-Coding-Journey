/* ************************************************************************** */
/* */
/* Project: Modifying Strings                                                 */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    char word[] = "Hello";
    
    // Change 'H' to 'J'
    word[0] = 'J';

    printf("Updated word: %s\n", word); // Prints "Jello"

    return (0);
}
