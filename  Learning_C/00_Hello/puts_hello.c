/* ************************************************************************** */
/*                                                                            */
/*   Project : Hello World                                                    */
/*   Author  : Miles3103                                                      */
/*   Topic   : C Intro — puts() function                                      */
/*                                                                            */
/* ************************************************************************** */

/*
** WHY puts() AND NOT printf?
**
**   printf() is the general-purpose output function — it handles format
**   strings, which adds overhead when you just want to print plain text.
**   puts() is a simpler C library function specifically for printing strings.
**
**   puts() is preferred for plain string output because:
**     - Automatically appends a newline '\n' at the end
**     - No format string parsing — faster and safer for static strings
**     - Cleaner and more readable for simple messages
**
** PROTOTYPE:
**   int puts(const char *s)
**
**   s     : pointer to the null-terminated string to print
**   return: non-negative number on success, EOF on error
**
** NOTE:
**   puts() always writes to stdout and always adds '\n'.
**   If you need stderr or no newline, use write() or fputs() instead.
*/

#include <stdio.h>

int	main(void)
{
	/* puts() prints the string and automatically adds a newline */
	puts("Hello, World");

	return (0);
}
