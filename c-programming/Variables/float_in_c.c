/* ************************************************************************** */
/* */
/* Project: Floating Point Constants                                         */
/* Author:  Miles3103                                                        */
/* */
/* ************************************************************************** */

#include <stdio.h>

/**
 * Demonstrates the use of 'float' for scientific constants.
 * Shows default vs. formatted precision in output.
 */
int	main(void)
{
	// The 'f' suffix tells the compiler this is a float, not a double.
	float	pi = 3.14159f;
	float	gravity = 9.8f;

	// %f defaults to 6 decimal places
	printf("The value of pi is:  %f\n", pi);

	// %.2f rounds the output to 2 decimal places
	printf("Gravity (rounded):   %.2f m/s^2\n", gravity);

	return (0);
}
