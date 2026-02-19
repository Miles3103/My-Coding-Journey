/* ************************************************************************** */
/* */
/* Project: Understanding Booleans (Logic in C)                               */
/* Author:  Miles3103                                                        */
/* */
/* ************************************************************************** */

#include <stdio.h>
#include <stdbool.h> // Essential for using 'bool', 'true', and 'false'

int main(void)
{
    // 1. Modern C Boolean (Requires <stdbool.h>)
    bool is_coding = true;
    bool is_tired = false;

    // 2. The "Old School" C way (using integers)
    int is_learning = 1; // In C, any non-zero number is 'true'
    int is_quitting = 0; // Exactly zero is 'false'

    printf("--- Miles3103's Logic Lab ---\n\n");

    // Booleans are printed as integers (%d)
    printf("Is Miles coding? %d (1 = true)\n", is_coding);
    printf("Is Miles tired?  %d (0 = false)\n\n", is_tired);

    // Using booleans in a condition
    if (is_coding && !is_tired) 
    {
        printf("Status: Peak Productivity!\n");
    }

    return (0);
}
