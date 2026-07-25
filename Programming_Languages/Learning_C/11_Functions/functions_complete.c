/* ************************************************************************** */
/*                                                                            */
/*   Project : Functions — The Core of C                                      */
/*   Author  : Miles3103                                                      */
/*   Topic   : Functions — prototypes, scope, recursion, pointers             */
/*                                                                            */
/* ************************************************************************** */

/*
** WHAT IS A FUNCTION IN C?
**
**   A function is a named, reusable block of code that:
**     - Takes 0 or more INPUT parameters
**     - Performs some work
**     - Returns exactly 0 or 1 OUTPUT value (use void for none)
**
**   In C, functions are the ONLY mechanism for code reuse.
**   Every program is a hierarchy of functions calling other functions.
**
** THE CALL STACK:
**   When a function is called, a stack frame is pushed onto the call stack.
**   That frame holds the local variables for that call.
**   When the function returns, the frame is popped — locals are destroyed.
**   This is why you can NEVER return a pointer to a local variable.
**
** PASS BY VALUE vs PASS BY POINTER:
**   C is ALWAYS pass-by-value. Every argument is COPIED.
**   To let a function modify the caller's variable, pass its ADDRESS.
**
**   void f(int n)   { n = 99; }  → caller's variable unchanged
**   void f(int *n)  { *n = 99; } → caller's variable IS changed
**
** RECURSION:
**   A function that calls itself. Every recursive function needs:
**     1. BASE CASE   → condition that stops the recursion
**     2. RECURSIVE CASE → call with a smaller/simpler input
**   Without a base case, recursion overflows the stack and crashes.
**
** NOTE:
**   Declare function prototypes above main when the definition comes after.
**   The compiler reads top-to-bottom — it needs to know the signature
**   before the first call site.
*/

#include <stdio.h>
#include <unistd.h>

/* ============================================================ */
/*  UTILITY FUNCTIONS (the kind you build for 42 projects)      */
/* ============================================================ */

/*
** @desc   Returns the length of a null-terminated string.
** @param  s   : the string to measure
** @return     : number of characters before '\0'
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
** @desc   Prints a string using write() — no printf dependency.
** @param  s   : null-terminated string to print to stdout
*/
void	ft_putstr(const char *s)
{
	write(1, s, ft_strlen(s));
}

/*
** @desc   Returns 1 if c is a letter (a-z or A-Z), 0 otherwise.
**         Implemented without ctype.h using ASCII ranges.
** @param  c   : character to test
** @return     : 1 if alphabetic, 0 if not
*/
int	ft_isalpha(char c)
{
	return ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'));
}

/*
** @desc   Returns the absolute value of n.
** @param  n   : integer input
** @return     : n if positive, -n if negative
*/
int	ft_abs(int n)
{
	return (n < 0 ? -n : n);
}

/* ============================================================ */
/*  PASS BY VALUE vs PASS BY POINTER                            */
/* ============================================================ */

/*
** Receives a COPY of x — any change stays local, caller unchanged.
*/
void	try_double_val(int n)
{
	n = n * 2;
	printf("  Inside try_double_val: n = %d\n", n);
}

/*
** Receives the ADDRESS of x — dereferencing modifies the original.
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
**         factorial(5) = 5 × 4 × 3 × 2 × 1 = 120
** @param  n   : non-negative integer
** @return     : n!  (returns 1 for n <= 1)
*/
int	ft_factorial(int n)
{
	if (n <= 1)                       /* BASE CASE — recursion stops here */
		return (1);
	return (n * ft_factorial(n - 1)); /* RECURSIVE CASE — shrinks toward base */
}

/*
** @desc   Returns the nth Fibonacci number (0-indexed).
**         Sequence: 0, 1, 1, 2, 3, 5, 8, 13, 21 ...
** @param  n   : position in the sequence
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
	printf("=== Recursion — Factorial ===\n");
	for (int i = 0; i <= 7; i++)
		printf("factorial(%d) = %d\n", i, ft_factorial(i));
	printf("\n");

	printf("=== Recursion — Fibonacci ===\n");
	printf("First 10 Fibonacci numbers:\n");
	for (int i = 0; i < 10; i++)
		printf("%d ", ft_fibonacci(i));
	printf("\n");

	return (0);
}
