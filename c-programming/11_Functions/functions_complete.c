/* ************************************************************************** */
/*                                                                            */
/*   Project : Functions — The Core of C                                      */
/*   Author  : Miles3103                                                      */
/*   Topic   : Functions — prototypes, scope, recursion, pointers             */
/*                                                                            */
/* ************************************************************************** */

/*
** FUNCTIONS — WHY THEY MATTER
**
** A function is a named block of code that:
**   - Takes 0 or more INPUT parameters
**   - Does some work
**   - Returns 0 or 1 OUTPUT value
**
** In C, functions are the ONLY way to reuse code.
** Every program is just functions calling functions.
**
** THE STACK: When a function is called, its local variables
** are pushed onto the call stack. When it returns, they're popped.
** This is why locals don't survive after the function ends.
**
** PASS BY VALUE vs PASS BY POINTER:
**   C is ALWAYS pass-by-value. You pass a COPY of the argument.
**   To modify a variable in the caller, pass its ADDRESS (pointer).
*/

#include <stdio.h>
#include <unistd.h>

/* ============================================================ */
/*  UTILITY FUNCTIONS (what you'll build for 42 projects)       */
/* ============================================================ */

/*
** @desc   Returns the length of a null-terminated string.
** @param  s : the string to measure
** @return   : number of characters before '\0'
*/
int	ft_strlen(const char *s)
{
	int	len;

	len = 0;
	while (s[len] != '\0')
		len++;
	return (len);
}

/*
** @desc   Prints a string using write() — no printf.
** @param  s : null-terminated string to print
*/
void	ft_putstr(const char *s)
{
	write(1, s, ft_strlen(s));
}

/*
** @desc   Returns 1 if c is a letter (a-z or A-Z), 0 otherwise.
**         Implements without ctype.h.
** @param  c : character to test
** @return   : 1 if alpha, 0 if not
*/
int	ft_isalpha(char c)
{
	return ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'));
}

/*
** @desc   Returns the absolute value of n.
** @param  n : integer input
** @return   : n if positive, -n if negative
*/
int	ft_abs(int n)
{
	return (n < 0 ? -n : n);
}

/* ============================================================ */
/*  PASS BY VALUE vs PASS BY POINTER                            */
/* ============================================================ */

/*
** This CANNOT change x in main — it receives a COPY.
*/
void	try_double_val(int n)
{
	n = n * 2;
	printf("  Inside try_double_val: n = %d\n", n);
}

/*
** This CAN change x in main — it receives the ADDRESS.
*/
void	do_double_ref(int *n)
{
	*n = *n * 2;
	printf("  Inside do_double_ref: *n = %d\n", *n);
}

/* ============================================================ */
/*  RECURSION                                                    */
/* ============================================================ */

/*
** @desc   Computes factorial of n recursively.
**         factorial(5) = 5 * 4 * 3 * 2 * 1 = 120
** @param  n : non-negative integer
** @return   : n!
*/
int	ft_factorial(int n)
{
	if (n <= 1)        /* BASE CASE — stops the recursion */
		return (1);
	return (n * ft_factorial(n - 1)); /* RECURSIVE CASE */
}

/*
** @desc   Computes the nth Fibonacci number.
**         0, 1, 1, 2, 3, 5, 8, 13, 21...
*/
int	ft_fibonacci(int n)
{
	if (n <= 0)
		return (0);
	if (n == 1)
		return (1);
	return (ft_fibonacci(n - 1) + ft_fibonacci(n - 2));
}

/* ============================================================ */
/*  MAIN                                                         */
/* ============================================================ */

int	main(void)
{
	/* --- UTILITY FUNCTIONS --- */
	printf("=== Utility Functions ===\n");
	printf("ft_strlen(\"hello\") = %d\n", ft_strlen("hello"));
	ft_putstr("ft_putstr: Hello without printf!\n");
	printf("ft_isalpha('a') = %d\n", ft_isalpha('a'));
	printf("ft_isalpha('3') = %d\n", ft_isalpha('3'));
	printf("ft_abs(-42)     = %d\n\n", ft_abs(-42));

	/* --- PASS BY VALUE vs PASS BY POINTER --- */
	printf("=== Pass by Value vs Pointer ===\n");
	int	x = 5;
	printf("Before try_double_val: x = %d\n", x);
	try_double_val(x);
	printf("After  try_double_val: x = %d (UNCHANGED)\n\n", x);

	printf("Before do_double_ref: x = %d\n", x);
	do_double_ref(&x);
	printf("After  do_double_ref: x = %d (CHANGED!)\n\n", x);

	/* --- RECURSION --- */
	printf("=== Recursion ===\n");
	for (int i = 0; i <= 7; i++)
		printf("factorial(%d) = %d\n", i, ft_factorial(i));
	printf("\n");

	printf("First 10 Fibonacci numbers:\n");
	for (int i = 0; i < 10; i++)
		printf("%d ", ft_fibonacci(i));
	printf("\n");

	return (0);
}
