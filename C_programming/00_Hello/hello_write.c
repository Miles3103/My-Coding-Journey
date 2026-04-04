/* ************************************************************************** */
/*                                                                            */
/*   Project : Hello World                                                    */
/*   Author  : Miles3103                                                      */
/*   Topic   : C Intro — write() syscall                                      */
/*                                                                            */
/* ************************************************************************** */

/*
** WHY write() AND NOT printf?
**
**   printf() is a C library function with internal buffering.
**   write() is a direct Unix system call — goes straight to the kernel.
**
**   In low-level C (42 style), write() is preferred because:
**     - No hidden buffering
**     - No dependency on the C standard library
**     - Teaches you what's REALLY happening under the hood
**
** PROTOTYPE:
**   ssize_t write(int fd, const void *buf, size_t count)
**
**   fd    : file descriptor  →  0=stdin  1=stdout  2=stderr
**   buf   : pointer to the bytes you want to send
**   count : how many bytes to send
**   return: bytes written on success, -1 on error
*/

#include <unistd.h>

int	main(void)
{
	/* Writing to stdout (fd = 1) */
	write(1, "Hello, World!\n", 14);

	/* Writing to stderr (fd = 2) — for errors and debug info */
	write(2, "[stderr] This is an error channel\n", 34);

	return (0);
}
