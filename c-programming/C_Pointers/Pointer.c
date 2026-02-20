/* ************************************************************************** */
/* */
/* Project: Intro to Pointers                                                 */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int   age = 25;      // A regular variable
    int  *ptr = &age;    // A pointer variable that stores the address of age

    printf("Value of age:          %d\n", age);
    printf("Address of age:        %p\n", (void *)&age);
    printf("Value stored in ptr:   %p\n", (void *)ptr);

    return (0);
}
