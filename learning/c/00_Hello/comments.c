/* ************************************************************************** */
/*                                                                            */
/*   comments.c - the three ways to "comment out" code in C                   */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

/*
** 1. Preprocessor comment-out: `#if 0 ... #endif`
**    Everything inside is removed BEFORE compilation. Unlike a block comment
**    it can safely contain other block comments, so it is the standard way
**    to disable a large chunk of code.
*/
#if 0
int	main(void)
{
	printf("This main() is removed by the preprocessor.\n");
	return (0);
}
#endif /* 0 */

/*
** 2. Delimited (block) comments: they do NOT nest.
**    A second "slash-star" inside a block comment is a bug (-Wcomment).
*/

// 3. One-line comments (C99 and later).

static void	greeting(void)
{
	puts("Welcome");
}

static void	hello_world(void)
{
	printf("Hello, World\n");
}

int	main(void)
{
	greeting();
	hello_world();
	return (0);
}
