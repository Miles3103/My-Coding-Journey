/* ************************************************************************** */
/*                                                                            */
/*   Project : Variable Deep Dive                                             */
/*   Author  : Miles3103                                                      */
/*   Topic   : Variables — types, scope, lifetime, storage                    */
/*                                                                            */
/* ************************************************************************** */

/*
** VARIABLES IN C — WHAT YOU REALLY NEED TO KNOW
**
** A variable = a named region of memory.
** Every variable has:
**   1. TYPE     → how many bytes, how to interpret them
**   2. NAME     → how you refer to it in code
**   3. VALUE    → the bits stored at that address
**   4. ADDRESS  → where it lives in memory (&var gives this)
**   5. SCOPE    → where in the code it's visible
**   6. LIFETIME → how long the memory is kept alive
**
** STORAGE CLASSES:
**   auto     → default for locals, lives on the stack
**   static   → persists between function calls
**   register → hint to compiler to use CPU register (rarely used)
**   extern   → declared elsewhere, defined here or vice versa
*/

#include <stdio.h>
#include <stdbool.h>

/* GLOBAL variable — lives for the entire program in the data segment */
int	g_global_counter = 0;

/*
** @desc   Demonstrates static variables — they remember their value
**         between calls, unlike regular locals.
*/
void	demo_static(void)
{
	static int	call_count = 0; /* initialized ONCE, then persists */

	call_count++;
	printf("demo_static() called %d time(s)\n", call_count);
}

int	main(void)
{
	/* --- BASIC TYPES --- */
	char		letter     = 'M';    /* 1 byte  — stores ASCII value */
	int			count      = 2025;   /* 4 bytes  — standard integer  */
	float		ratio      = 3.14f;  /* 4 bytes  — ~7 decimal digits  */
	double		precise    = 2.718281828; /* 8 bytes — ~15 decimal digits */
	bool		is_active  = true;   /* 1 byte  — 0 or 1             */

	printf("=== Basic Types ===\n");
	printf("char:   %c  (stored as ASCII %d)\n", letter, letter);
	printf("int:    %d\n", count);
	printf("float:  %.2f\n", ratio);
	printf("double: %.9f\n", precise);
	printf("bool:   %d (true=1, false=0)\n\n", is_active);

	/* --- SIZES IN MEMORY --- */
	printf("=== Memory Sizes ===\n");
	printf("sizeof(char)   = %zu byte(s)\n", sizeof(char));
	printf("sizeof(int)    = %zu byte(s)\n", sizeof(int));
	printf("sizeof(float)  = %zu byte(s)\n", sizeof(float));
	printf("sizeof(double) = %zu byte(s)\n", sizeof(double));
	printf("sizeof(bool)   = %zu byte(s)\n\n", sizeof(bool));

	/* --- ADDRESSES — this is the bridge to pointers --- */
	printf("=== Memory Addresses ===\n");
	printf("Address of letter:  %p\n", (void *)&letter);
	printf("Address of count:   %p\n", (void *)&count);
	printf("Address of precise: %p\n\n", (void *)&precise);

	/* --- SCOPE & LIFETIME --- */
	printf("=== Scope & Static Demo ===\n");
	g_global_counter++;
	printf("Global counter: %d\n", g_global_counter);

	/* static persists between calls */
	demo_static();
	demo_static();
	demo_static();

	/* --- SWAP WITHOUT TEMP (XOR trick) --- */
	int a = 5;
	int b = 9;
	printf("\n=== XOR Swap (no temp variable) ===\n");
	printf("Before: a=%d, b=%d\n", a, b);
	a ^= b;
	b ^= a;
	a ^= b;
	printf("After:  a=%d, b=%d\n", a, b);

	return (0);
}
