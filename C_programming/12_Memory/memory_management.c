/* ************************************************************************** */
/*                                                                            */
/*   Project : Memory Management                                              */
/*   Author  : Miles3103                                                      */
/*   Topic   : Memory — stack, heap, malloc, free, leaks                      */
/*                                                                            */
/* ************************************************************************** */

/*
** MEMORY IN C — THE FULL PICTURE
**
** Your program's memory is divided into regions:
**
**   ┌─────────────────────┐  high addresses
**   │       STACK         │  ← local variables, function calls
**   │   (grows down ↓)    │    fast, automatic, limited (~8MB)
**   ├─────────────────────┤
**   │       HEAP          │  ← malloc/free, dynamic allocation
**   │   (grows up ↑)      │    slow(er), manual, large
**   ├─────────────────────┤
**   │   BSS (globals=0)   │  ← uninitialized globals
**   │   DATA (globals≠0)  │  ← initialized globals
**   │   TEXT (code)       │  ← your compiled instructions
**   └─────────────────────┘  low addresses
**
** RULES OF DYNAMIC MEMORY:
**   1. Every malloc() must have exactly one free()
**   2. Never free() the same pointer twice (double-free = crash)
**   3. Never use a pointer after free() (use-after-free = undefined)
**   4. Always check if malloc() returned NULL
**   5. Set pointer to NULL after freeing
**
** CHECK FOR LEAKS: valgrind --leak-check=full ./your_program
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ============================================================ */
/*  BASIC MALLOC / FREE                                         */
/* ============================================================ */

void	demo_basic_malloc(void)
{
	printf("=== Basic Malloc ===\n");

	/* Allocate space for 5 integers */
	int	*arr = malloc(5 * sizeof(int));
	if (!arr)  /* ALWAYS check! malloc returns NULL on failure */
	{
		printf("malloc failed!\n");
		return ;
	}

	/* Use the memory */
	for (int i = 0; i < 5; i++)
		arr[i] = (i + 1) * 10;

	for (int i = 0; i < 5; i++)
		printf("arr[%d] = %d\n", i, arr[i]);

	/* Free and nullify */
	free(arr);
	arr = NULL;  /* prevents use-after-free bugs */
	printf("Memory freed.\n\n");
}

/* ============================================================ */
/*  ft_strdup — duplicate a string on the heap                  */
/*  This is a real function you'll write in 42 projects.        */
/* ============================================================ */

char	*ft_strdup(const char *src)
{
	int		len;
	char	*dup;
	int		i;

	len = 0;
	while (src[len])
		len++;
	dup = malloc((len + 1) * sizeof(char));  /* +1 for '\0' */
	if (!dup)
		return (NULL);
	i = 0;
	while (i < len)
	{
		dup[i] = src[i];
		i++;
	}
	dup[i] = '\0';
	return (dup);
}

void	demo_strdup(void)
{
	printf("=== ft_strdup (heap-allocated string copy) ===\n");

	char	*original = "Hello, Miles3103!";
	char	*copy = ft_strdup(original);

	if (!copy)
	{
		printf("ft_strdup failed!\n");
		return ;
	}

	printf("Original: %s  (address: %p)\n", original, (void *)original);
	printf("Copy:     %s  (address: %p)\n", copy, (void *)copy);
	printf("Same address? %s\n", original == copy ? "yes (BAD)" : "no (GOOD)");

	/* Modify copy — original is unaffected */
	copy[0] = 'X';
	printf("After modifying copy[0]='X':\n");
	printf("  original: %s\n", original);
	printf("  copy:     %s\n", copy);

	free(copy);
	copy = NULL;
	printf("\n");
}

/* ============================================================ */
/*  STACK vs HEAP — where does each variable live?             */
/* ============================================================ */

int	g_global = 42;  /* DATA segment — lives forever */

void	demo_memory_locations(void)
{
	int		stack_var   = 10;       /* STACK */
	int		*heap_var   = malloc(sizeof(int)); /* HEAP */

	if (!heap_var)
		return ;
	*heap_var = 99;

	printf("=== Memory Locations ===\n");
	printf("global (&g_global):   %p  ← data segment\n", (void *)&g_global);
	printf("stack  (&stack_var):  %p  ← stack\n", (void *)&stack_var);
	printf("heap   (heap_var):    %p  ← heap\n", (void *)heap_var);
	printf("\n");
	printf("Stack address HIGHER than heap? %s\n\n",
		(void *)&stack_var > (void *)heap_var ? "yes (typical)" : "no");

	free(heap_var);
	heap_var = NULL;
}

/* ============================================================ */
/*  COMMON MEMORY MISTAKES — know these to avoid them           */
/* ============================================================ */

void	demo_common_mistakes(void)
{
	printf("=== Common Memory Mistakes (showing safe versions) ===\n");

	/* MISTAKE 1: Forgetting to check malloc return */
	int *p = malloc(sizeof(int));
	if (!p)  /* ALWAYS do this */
	{
		printf("malloc returned NULL — handle it!\n");
		return ;
	}
	*p = 42;
	printf("Safe malloc: *p = %d\n", *p);
	free(p);
	p = NULL;

	/* MISTAKE 2: Buffer overflow — reading past array bounds */
	int arr[3] = {1, 2, 3};
	printf("Safe access: arr[0]=%d arr[1]=%d arr[2]=%d\n",
		arr[0], arr[1], arr[2]);
	/* arr[3] would be out of bounds — NEVER do this */

	/* MISTAKE 3: Returning pointer to local variable */
	/* NEVER do: int *bad_func() { int x = 5; return &x; } */
	/* x is on the stack and destroyed when function returns */

	printf("All safe!\n\n");
}

/* ============================================================ */
/*  MAIN                                                         */
/* ============================================================ */

int	main(void)
{
	demo_basic_malloc();
	demo_strdup();
	demo_memory_locations();
	demo_common_mistakes();

	printf("=== Run with valgrind to verify zero leaks ===\n");
	printf("valgrind --leak-check=full ./memory_management\n");

	return (0);
}
