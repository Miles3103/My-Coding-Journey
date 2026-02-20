/* ************************************************************************** */
/* */
/* Project: Inspecting Memory Addresses                                       */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    int age = 25;

    // %p is the format specifier for addresses (pointers)
    // It prints the address in Hexadecimal (e.g., 0x7ffeefbff5c8)
    printf("The value is:   %d\n", age);
    printf("The address is: %p\n", (void *)&age);

    return (0);
}
