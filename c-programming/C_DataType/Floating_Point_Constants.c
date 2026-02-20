/* ************************************************************************** */
/* */
/* Project: Floating Point Constants                                          */
/* Author:  Miles3103                                                         */
/* */
/* ************************************************************************** */

#include <stdio.h>

int main(void)
{
    float    pi = 3.14159f;       // 4 bytes, precision ~7 digits (%f)
    double   e = 2.718281828;     // 8 bytes, precision ~15 digits (%lf)

    printf("Pi (float):   %.5f\n", pi);
    printf("E (double):   %.9lf\n", e);

    return (0);
}
