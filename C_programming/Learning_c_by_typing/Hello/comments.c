#include <stdio.h>

#if 0 /* Statrs thwe "comment" , anything from here on is removed by the preprocessor */

int	main(void)
{
	printf ("#HELLO\n#\n");
	return 0;
}

#endif /* 0 */

/* Code from here on is "uncommented" */
void	greeting()
{
	puts ("Welcome\n");
}

/* delimited comments
 * **************
 * **************
 * *************
 * ************
 */


// One line comment
// 888888
// njndfjndw
// knkvkkevk
void	greeting()
{
	printf ("Hello, World\n");
}

