/* ************************************************************************** */
/*                                                                            */
/*   Project : Pointers — The Heart of C                                      */
/*   Author  : Miles3103                                                      */
/*   Topic   : Pointers — basics, arithmetic, double ptrs, func ptrs          */
/*                                                                            */
/* ************************************************************************** */

/*
** POINTERS — WHY C IS DIFFERENT FROM EVERYTHING ELSE
**
** A pointer is a variable that stores a MEMORY ADDRESS.
**
** Every variable you declare lives somewhere in RAM.
** A pointer lets you find that place and work with it directly.
**
** DECLARATION:  int *p;     ← p is a pointer to an int
** GET ADDRESS:  p = &x;     ← & gives the address of x
** DEREFERENCE:  *p          ← * reads the value at the address
**
** THREE RULES TO NEVER FORGET:
**   1. Always initialize a pointer before using it.
**      Uninitialized pointer = undefined behavior = crashes.
**   2. Never dereference NULL. Check before accessing.
**   3. Free what you malloc. One malloc = one free.
**
** THE THREE JOBS OF POINTERS:
**   1. Modify variables in other functions (pass by reference)
**   2. Navigate arrays and strings efficiently
**   3. Manage dynamic memory (malloc/free)
*/

#include <stdio.h>
#include <stdlib.h>

/* ============================================================ */
/*  1. POINTER BASICS                                           */
/* ============================================================ */

void	demo_basics(void)
{
	int	x = 42;
	int	*p = &x;  /* p holds the address of x */

	printf("=== 1. Pointer Basics ===\n");
	printf("x         = %d\n", x);
	printf("&x        = %p  (address of x)\n", (void *)&x);
	printf("p         = %p  (value stored in p = address of x)\n", (void *)p);
	printf("*p        = %d  (value AT the address p holds)\n", *p);

	/* Modifying x through the pointer */
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
		/*
		** *(p + i) is exactly the same as arr[i]
		** The compiler converts arr[i] → *(arr + i) anyway!
		*/
		printf("*(p+%d) = %d  (same as arr[%d] = %d)\n",
			i, *(p + i), i, arr[i]);
	}
	printf("\n");

	/* Address difference shows how many bytes apart elements are */
	printf("Addresses:\n");
	for (int i = 0; i < 5; i++)
		printf("  &arr[%d] = %p\n", i, (void *)&arr[i]);
	printf("Bytes between elements: %ld\n\n",
		(char *)&arr[1] - (char *)&arr[0]);
}

/* ============================================================ */
/*  3. DOUBLE POINTERS — pointer to pointer                     */
/* ============================================================ */

/*
** Used when a function needs to modify a POINTER in the caller.
** Example: allocating memory inside a function,
**          or modifying a string pointer.
*/
void	demo_double_pointer(void)
{
	int		x   = 42;
	int		*p  = &x;
	int		**pp = &p;

	printf("=== 3. Double Pointer ===\n");
	printf("x    = %d\n", x);
	printf("*p   = %d\n", *p);
	printf("**pp = %d\n", **pp);

	/* Modifying x through double pointer */
	**pp = 100;
	printf("After **pp = 100 → x = %d\n\n", x);
}

/* ============================================================ */
/*  4. POINTERS AND STRINGS                                     */
/* ============================================================ */

/*
** A string in C is just a char array.
** A char * pointer to a string lets you walk through it char by char.
*/
int	ft_strlen_ptr(const char *s)
{
	const char	*start = s;

	while (*s != '\0')  /* walk until null terminator */
		s++;
	return (s - start);  /* pointer difference = length */
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
/* ============================================================ */

/*
** A function pointer stores the address of a function.
** Syntax: return_type (*ptr_name)(param_types)
**
** Used for: callbacks, dispatch tables, implementing polymorphism.
*/
int	add(int a, int b) { return (a + b); }
int	sub(int a, int b) { return (a - b); }
int	mul(int a, int b) { return (a * b); }

void	demo_func_pointers(void)
{
	/* Array of function pointers */
	int		(*ops[3])(int, int) = {add, sub, mul};
	char	*names[] = {"add", "sub", "mul"};

	printf("=== 5. Function Pointers ===\n");
	for (int i = 0; i < 3; i++)
		printf("%s(10, 3) = %d\n", names[i], ops[i](10, 3));
	printf("\n");
}

/* ============================================================ */
/*  6. DYNAMIC MEMORY — malloc and free                         */
/* ============================================================ */

void	demo_malloc(void)
{
	printf("=== 6. Dynamic Memory (malloc/free) ===\n");

	/* Allocate array of 5 ints on the heap */
	int	*arr = malloc(5 * sizeof(int));
	if (!arr)  /* ALWAYS check malloc return value */
	{
		printf("malloc failed!\n");
		return ;
	}

	/* Fill and print */
	for (int i = 0; i < 5; i++)
		arr[i] = (i + 1) * 10;

	for (int i = 0; i < 5; i++)
		printf("arr[%d] = %d\n", i, arr[i]);

	free(arr);  /* ALWAYS free what you malloc */
	arr = NULL; /* Set to NULL after free to prevent use-after-free */
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
