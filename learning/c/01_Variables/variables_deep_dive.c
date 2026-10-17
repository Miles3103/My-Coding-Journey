/* ************************************************************************** */
/*                                                                            */
/*   Project : Variable Deep Dive                                             */
/*   Author  : Miles3103                                                      */
/*   Topic   : Variables — types, scope, lifetime, storage                    */
/*                                                                            */
/* ************************************************************************** */

/*
** WHAT IS A VARIABLE?
**
**   A variable is a named region of memory.
**   Every variable has six fundamental properties:
**     1. TYPE     → how many bytes, and how to interpret them
**     2. NAME     → how you refer to it in source code
**     3. VALUE    → the bits stored at that address
**     4. ADDRESS  → where it lives in memory  (&var gives you this)
**     5. SCOPE    → where in the code it is visible
**     6. LIFETIME → how long the memory is kept alive
**
** STORAGE CLASSES:
**   auto     → default for locals, lives on the stack, dies when scope ends
**   static   → persists between function calls, lives in the data segment
**   register → hint to the compiler to use a CPU register (rarely needed)
**   extern   → declared here, defined in another translation unit
**
** BASIC TYPE SIZES (typical 64-bit system):
**   char   →  1 byte   stores an ASCII character or small integer
**   int    →  4 bytes  standard signed integer
**   float  →  4 bytes  single-precision decimal (~7 significant digits)
**   double →  8 bytes  double-precision decimal (~15 significant digits)
**   bool   →  1 byte   0 = false, any non-zero = true  (needs stdbool.h)
**
** NOTE:
**   Sizes are PLATFORM-DEPENDENT. Always use sizeof() when the exact
**   byte count matters — never hardcode it. This is the bridge to
**   understanding pointers and memory management.
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
	static int	call_count = 0; /* initialized ONCE, then persists across calls */

	call_count++;
	printf("demo_static() called %d time(s)\n", call_count);
}

int	main(void)
{
	/* --- BASIC TYPES --- */
	char	letter    = 'M';         /* 1 byte  — stores ASCII value          */
	int		count     = 2025;        /* 4 bytes — standard integer             */
	float	ratio     = 3.14f;       /* 4 bytes — ~7 decimal digits            */
	double	precise   = 2.718281828; /* 8 bytes — ~15 decimal digits           */
	bool	is_active = true;        /* 1 byte  — 0 or 1                       */

	printf("=== Basic Types ===\n");
	printf("char:   %c  (stored as ASCII %d)\n", letter, letter);
	printf("int:    %d\n", count);
	printf("float:  %.2f\n", ratio);
	printf("double: %.9f\n", precise);
	printf("bool:   %d (true=1, false=0)\n\n", is_active);

	/* --- SIZES IN MEMORY — always use sizeof(), never assume --- */
	printf("=== Memory Sizes ===\n");
	printf("sizeof(char)   = %zu byte(s)\n", sizeof(char));
	printf("sizeof(int)    = %zu byte(s)\n", sizeof(int));
	printf("sizeof(float)  = %zu byte(s)\n", sizeof(float));
	printf("sizeof(double) = %zu byte(s)\n", sizeof(double));
	printf("sizeof(bool)   = %zu byte(s)\n\n", sizeof(bool));

	/* --- ADDRESSES — the direct bridge to pointers --- */
	printf("=== Memory Addresses ===\n");
	printf("Address of letter:  %p\n", (void *)&letter);
	printf("Address of count:   %p\n", (void *)&count);
	printf("Address of precise: %p\n\n", (void *)&precise);

	/* --- SCOPE & LIFETIME --- */
	printf("=== Scope & Static Demo ===\n");
	g_global_counter++;
	printf("Global counter: %d\n", g_global_counter);

	/* static call_count persists — notice it increments across all three calls */
	demo_static();
	demo_static();
	demo_static();

	/* --- XOR SWAP — swapping two ints without a temporary variable --- */
	int	a = 5;
	int	b = 9;
	printf("\n=== XOR Swap (no temp variable) ===\n");
	printf("Before: a=%d, b=%d\n", a, b);
	a ^= b; /* a now holds a ^ b                  */
	b ^= a; /* b now holds b ^ (a ^ b) = a        */
	a ^= b; /* a now holds (a ^ b) ^ a = b        */
	printf("After:  a=%d, b=%d\n", a, b);

	return (0);
}
