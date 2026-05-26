/* ************************************************************************** */
/*                                                                            */
/*   Project : Hello World                                                    */
/*   Author  : Miles3103                                                      */
/*   Topic   : C Intro — printf() function                                    */
/*                                                                            */
/* ************************************************************************** */

/*
** WHY printf() AND NOT write()?
**
**   write() is a raw Unix syscall — it sends bytes directly to a file
**   descriptor. printf() sits on top of the C standard library and offers
**   much more flexibility through format strings.
**
**   printf() is preferred when you need formatted output because:
**     - Supports format specifiers: %d, %s, %f, %c, %x, etc.
**     - Handles type conversion automatically
**     - Far more readable for complex or dynamic output
**
** PROTOTYPE:
**   int printf(const char *format, ...)
**
**   format : format string — plain text mixed with % conversion specifiers
**   ...    : variadic arguments matching each specifier in order
**   return : number of characters printed on success, negative on error
**
** NOTE:
**   printf() uses internal buffering (via stdout).
**   Output may not appear immediately — call fflush(stdout) if needed.
**   For unbuffered output, use write() directly.
*/

#include <stdio.h>

int	main(void)
{
	/* %s would accept a variable — \n is the explicit newline */
	printf("Hello, World!\n");

	return (0);
}
