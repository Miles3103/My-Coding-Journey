/* ************************************************************************** */
/* */
/* Project: Floating Point Basics                                            */
/* Author:  Miles3103                                                        */
/* */
/* ************************************************************************** */

#include <stdio.h>

/**
 * A simple demonstration of using the 'double' data type to store 
 * and format measurements in C.
 */
int	main(void)
{
	// 'double' provides 64-bit precision for decimal values
	double height = 173.0;

	// %.f tells printf to display the float with 0 decimal places
	printf("Your height is: %.fcm\n", height);

	return (0);
}
