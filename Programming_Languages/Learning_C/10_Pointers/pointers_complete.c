/* ************************************************************************** */
/*                                                                            */
/*   Project : Pointers — The Heart of C                                      */
/*   Author  : Miles3103                                                      */
/*   Topic   : Pointers — basics, arithmetic, double ptrs, func ptrs          */
/*                                                                            */
/* ************************************************************************** */

/*
** WHAT IS A POINTER?
**
**   A pointer is a variable that stores a MEMORY ADDRESS.
**   Every variable you declare lives somewhere in RAM. A pointer lets you
**   find that location and work with it directly — bypassing the copy
**   that C would otherwise make when passing to functions.
**
**   DECLARATION:  int *p;      p is a variable that holds the address of an int
**   GET ADDRESS:  p = &x;     & gives the address of x (x must exist first)
**   DEREFERENCE:  *p           * reads the value stored at the address in p
**
** THE THREE JOBS OF POINTERS:
**   1. Modify variables in other functions   (pass by reference)
**   2. Navigate arrays and strings           (pointer arithmetic)
**   3. Manage dynamic memory                 (malloc / free)
**
** THREE RULES TO NEVER BREAK:
**   1. Always initialize before use — uninitialized pointer = crash
**   2. Never dereference NULL — always check the pointer first
**   3. Free what you malloc — one malloc, one free, no exceptions
**
** POINTER ARITHMETIC:
**   When you add 1 to a pointer, it advances by sizeof(type) bytes.
**   int *p; p + 1 advances by 4 bytes (size of int on 64-bit).
**   This is exactly how array indexing works internally:
**   arr[i] compiles to *(arr + i) — they are identical.
**
** NOTE:
**   Set a pointer to NULL after freeing it. A freed pointer still holds
**   the old address — dereferencing it after free is undefined behavior
**   and one of the most dangerous bugs in C.
*/

#include <stdio.h>
#include <stdlib.h>

/* ============================================================ */
/*  1. POINTER BASICS                                           */
/* ============================================================ */

void	demo_basics(void)
{
	int	x  = 42;
	int	*p = &x;  /* p holds the address of x — NOT a copy of x */

	printf("=== 1. Pointer Basics ===\n");
	printf("x         = %d\n", x);
	printf("&x        = %p  (address of x)\n", (void *)&x);
	printf("p         = %p  (value in p = address of x)\n", (void *)p);
	printf("*p        = %d  (value AT the address p holds)\n", *p);

	/* Modifying x through the pointer — x itself changes */
	*p = 99;
	printf("After *p = 99 → x = %d\n\n", x);
}

/* ============================================================ */
/*  2. POINTER ARITHMETIC — navigating arrays                   */
/* ============================================================ */

void	demo_arithmetic(void)
{
	int	arr[] = {10, 20, 30, 40, 50};
	int	*p = arr;  /* array name decays to pointer to first element */

	printf("=== 2. Pointer Arithmetic ===\n");
	printf("p points to arr[0]\n");
	for (int i = 0; i < 5; i++)
	{
		/* *(p + i) and arr[i] are 100% identical — same machine code */
		printf("*(p+%d) = %d  (same as arr[%d] = %d)\n",
			i, *(p + i), i, arr[i]);
	}
	printf("\n");

	/* Address difference reveals the byte size of each element */
	printf("Addresses:\n");
	for (int i = 0; i < 5; i++)
		printf("  &arr[%d] = %p\n", i, (void *)&arr[i]);
	printf("Bytes between elements: %ld\n\n",
		(char *)&arr[1] - (char *)&arr[0]);
}

/* ============================================================ */
/*  3. DOUBLE POINTERS — pointer to pointer                     */
/*  Used when a function must modify a pointer in the caller,   */
/*  e.g. allocating memory or updating a string pointer.        */
/* ============================================================ */

void	demo_double_pointer(void)
{
	int		x   = 42;
	int		*p  = &x;   /* p  points to x        */
	int		**pp = &p;  /* pp points to p         */

	printf("=== 3. Double Pointer ===\n");
	printf("x    = %d\n", x);
	printf("*p   = %d\n", *p);
	printf("**pp = %d\n", **pp);

	/* Modify x through two levels of indirection */
	**pp = 100;
	printf("After **pp = 100 → x = %d\n\n", x);
}

/* ============================================================ */
/*  4. POINTERS AND STRINGS                                     */
/*  A char * pointer walks through a string byte by byte.       */
/*  Pointer subtraction gives string length — no counter needed */
/* ============================================================ */

int	ft_strlen_ptr(const char *s)
{
	const char	*start = s;

	while (*s != '\0')  /* walk until the null terminator */
		s++;
	return (s - start); /* pointer difference = number of chars walked */
}

void	demo_strings(void)
{
	char	str[] = "Hello";
	char	*p = str;

	printf("=== 4. Pointers & Strings ===\n");
	printf("Walking string char by char:\n");
	while (*p != '\0')
	{
		printf("  *p = '%c'  (ASCII %d)  address: %p\n",
			*p, *p, (void *)p);
		p++;
	}
	printf("ft_strlen_ptr(\"Hello\") = %d\n\n",
		ft_strlen_ptr("Hello"));
}

/* ============================================================ */
/*  5. FUNCTION POINTERS                                        */
/*  Stores the address of a function — enables callbacks,       */
/*  dispatch tables, and simple polymorphism in C.              */
/*  Syntax: return_type (*ptr_name)(param_types)                */
/* ============================================================ */

int	add(int a, int b) { return (a + b); }
int	sub(int a, int b) { return (a - b); }
int	mul(int a, int b) { return (a * b); }

void	demo_func_pointers(void)
{
	int		(*ops[3])(int, int) = {add, sub, mul}; /* array of func ptrs */
	char	*names[] = {"add", "sub", "mul"};

	printf("=== 5. Function Pointers ===\n");
	for (int i = 0; i < 3; i++)
		printf("%s(10, 3) = %d\n", names[i], ops[i](10, 3));
	printf("\n");
}

/* ============================================================ */
/*  6. DYNAMIC MEMORY — malloc and free                         */
/*  malloc allocates on the heap — survives past the function.  */
/*  You OWN that memory until you call free().                  */
/* ============================================================ */

void	demo_malloc(void)
{
	printf("=== 6. Dynamic Memory (malloc/free) ===\n");

	int	*arr = malloc(5 * sizeof(int)); /* allocate 5 ints on the heap */
	if (!arr)                           /* ALWAYS check for NULL */
	{
		printf("malloc failed!\n");
		return ;
	}

	for (int i = 0; i < 5; i++)
		arr[i] = (i + 1) * 10;

	for (int i = 0; i < 5; i++)
		printf("arr[%d] = %d\n", i, arr[i]);

	free(arr);   /* release the heap memory */
	arr = NULL;  /* prevent use-after-free — pointer is now safe */
	printf("Memory freed. arr set to NULL.\n\n");
}

int	main(void)
{
	demo_basics();
	demo_arithmetic();
	demo_double_pointer();
	demo_strings();
	demo_func_pointers();
	demo_malloc();

	return (0);
}
