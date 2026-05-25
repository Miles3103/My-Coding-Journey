/* ************************************************************************** */
/*                                                                            */
/*   Project : Memory Management                                              */
/*   Author  : Miles3103                                                      */
/*   Topic   : Memory — stack, heap, malloc, free, leaks                      */
/*                                                                            */
/* ************************************************************************** */

/*
** HOW IS A C PROGRAM'S MEMORY LAID OUT?
**
**   Your program's virtual memory is divided into distinct regions:
**
**   ┌─────────────────────┐  high addresses
**   │       STACK         │  ← local variables, function frames
**   │   (grows down ↓)    │    fast, automatic, limited (~8 MB)
**   ├─────────────────────┤
**   │       HEAP          │  ← malloc / free, dynamic allocation
**   │   (grows up ↑)      │    slower, manual, essentially unlimited
**   ├─────────────────────┤
**   │   BSS  (globals=0)  │  ← zero-initialized global/static variables
**   │   DATA (globals≠0)  │  ← explicitly initialized globals/statics
**   │   TEXT (code)       │  ← compiled machine instructions (read-only)
**   └─────────────────────┘  low addresses
**
** RULES OF DYNAMIC MEMORY (break these and your program breaks):
**   1. Every malloc() must have exactly one free()
**   2. Never free() the same pointer twice     → double-free crash
**   3. Never use a pointer after free()        → use-after-free (UB)
**   4. Always check if malloc() returned NULL  → it can fail
**   5. Set the pointer to NULL after freeing   → prevents accidents
**
** NOTE:
**   Memory leaks — heap memory that is never freed — do not crash your
**   program immediately but accumulate over time. Use valgrind to detect:
**     valgrind --leak-check=full ./your_program
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int	g_global = 42;  /* DATA segment — initialized global, lives forever */

/* ============================================================ */
/*  BASIC MALLOC / FREE                                         */
/* ============================================================ */

void	demo_basic_malloc(void)
{
	printf("=== Basic Malloc ===\n");

	int	*arr = malloc(5 * sizeof(int)); /* allocate 5 ints on the heap */
	if (!arr)                           /* ALWAYS check — malloc can return NULL */
	{
		printf("malloc failed!\n");
		return ;
	}

	for (int i = 0; i < 5; i++)
		arr[i] = (i + 1) * 10;

	for (int i = 0; i < 5; i++)
		printf("arr[%d] = %d\n", i, arr[i]);

	free(arr);   /* release heap memory */
	arr = NULL;  /* nullify to prevent use-after-free bugs */
	printf("Memory freed.\n\n");
}

/* ============================================================ */
/*  ft_strdup — duplicate a string on the heap                  */
/*  A real function required in many 42 projects.               */
/* ============================================================ */

char	*ft_strdup(const char *src)
{
	int		len;
	char	*dup;
	int		i;

	len = 0;
	while (src[len])
		len++;
	dup = malloc((len + 1) * sizeof(char)); /* +1 for the null terminator */
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

	char	*original = "Hello, Miles3103!"; /* read-only string literal */
	char	*copy = ft_strdup(original);      /* writable heap copy       */

	if (!copy)
	{
		printf("ft_strdup failed!\n");
		return ;
	}

	printf("Original: %s  (address: %p)\n", original, (void *)original);
	printf("Copy:     %s  (address: %p)\n", copy,     (void *)copy);
	printf("Same address? %s\n", original == copy ? "yes (BAD)" : "no (GOOD)");

	/* Modifying copy does not touch the original */
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

void	demo_memory_locations(void)
{
	int		stack_var = 10;               /* STACK — automatic lifetime  */
	int		*heap_var = malloc(sizeof(int)); /* HEAP  — manual lifetime  */

	if (!heap_var)
		return ;
	*heap_var = 99;

	printf("=== Memory Locations ===\n");
	printf("global (&g_global):  %p  ← data segment\n", (void *)&g_global);
	printf("stack  (&stack_var): %p  ← stack\n",        (void *)&stack_var);
	printf("heap   (heap_var):   %p  ← heap\n",         (void *)heap_var);
	printf("\n");
	printf("Stack address higher than heap? %s\n\n",
		(void *)&stack_var > (void *)heap_var ? "yes (typical)" : "no");

	free(heap_var);
	heap_var = NULL;
}

/* ============================================================ */
/*  COMMON MEMORY MISTAKES — know them so you never make them   */
/* ============================================================ */

void	demo_common_mistakes(void)
{
	printf("=== Common Memory Mistakes (showing safe versions) ===\n");

	/* MISTAKE 1: not checking malloc return value */
	int *p = malloc(sizeof(int));
	if (!p)  /* this check is not optional */
	{
		printf("malloc returned NULL — handle it!\n");
		return ;
	}
	*p = 42;
	printf("Safe malloc: *p = %d\n", *p);
	free(p);
	p = NULL;

	/* MISTAKE 2: out-of-bounds access — C never checks for you */
	int arr[3] = {1, 2, 3};
	printf("Safe access: arr[0]=%d arr[1]=%d arr[2]=%d\n",
		arr[0], arr[1], arr[2]);
	/* arr[3] is out of bounds — it reads someone else's memory */

	/* MISTAKE 3: returning a pointer to a local variable
	**   NEVER do: int *bad(void) { int x = 5; return &x; }
	**   x is on the stack and destroyed when the function returns.
	**   The returned pointer points to garbage. */

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
