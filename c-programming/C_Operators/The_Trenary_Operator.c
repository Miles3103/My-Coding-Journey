/* ************************************************************************** */
/* */
/* Project: Ternary Operator                                                  */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int age = 20;
    
    // If age >= 18, assign "Adult", otherwise "Minor"
    const char *status = (age >= 18) ? "Adult" : "Minor";

    printf("Status: %s\n", status);

    return (0);
}
