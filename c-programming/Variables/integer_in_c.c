/* ************************************************************************** */
/* */
/* Project: Integer Exploration in C                                         */
/* Author:  Miles3103                                                        */
/* */
/* ************************************************************************** */

#include <stdio.h>

/**
 * A simple program to demonstrate how signed integers are stored 
 * and printed in C using the %d format specifier.
 */
int	main(void)
{
	int a = -1;
	int b = 0;
	int c = 1;
	int d = 146858894;
	int e = -146858894;

	printf("Small Negative: %d\n", a);
	printf("Zero:           %d\n", b);
	printf("Small Positive: %d\n", c);
	printf("Large Positive: %d\n", d);
	printf("Large Negative: %d\n", e);

	return (0);
}
