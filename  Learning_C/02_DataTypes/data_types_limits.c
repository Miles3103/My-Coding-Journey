/* ************************************************************************** */
/*                                                                            */
/*   Project : Data Types & Limits                                            */
/*   Author  : Miles3103                                                      */
/*   Topic   : Data Types — sizes, limits, overflow, signed vs unsigned       */
/*                                                                            */
/* ************************************************************************** */

/*
** WHAT ARE DATA TYPES AND WHY DO THEIR LIMITS MATTER?
**
**   C does not guarantee the exact byte size of most types — it is
**   platform dependent. On a modern 64-bit Linux system:
**     char=1  short=2  int=4  long=8  long long=8  (bytes)
**
**   Every type has a range determined by how many bits it holds:
**     signed   char :          -128  to           127
**     unsigned char :             0  to           255
**     signed   int  : -2,147,483,648  to 2,147,483,647
**     unsigned int  :             0  to 4,294,967,295
**
** SIGNED OVERFLOW vs UNSIGNED WRAPAROUND:
**   Signed overflow   → undefined behavior in C — never rely on it
**   Unsigned overflow → well-defined wraparound back to 0
**
** EXACT-WIDTH TYPES (from <stdint.h>):
**   When the exact byte count matters, use these instead:
**     int8_t   uint8_t    →  exactly  1 byte
**     int16_t  uint16_t   →  exactly  2 bytes
**     int32_t  uint32_t   →  exactly  4 bytes
**     int64_t  uint64_t   →  exactly  8 bytes
**
** KEY RULE: Use the right type for the job.
**   Counting / indexing   → size_t  (unsigned, pointer-sized)
**   Characters            → char
**   Precise decimals      → double, not float
**   Flags / truth values  → int or bool
**
** NOTE:
**   Always use sizeof() to check sizes at runtime — never assume.
**   Use <limits.h> constants (INT_MAX, CHAR_MIN …) instead of
**   hardcoding magic numbers like 2147483647.
*/

#include <stdio.h>
#include <limits.h>   /* INT_MAX, INT_MIN, CHAR_MAX, CHAR_MIN, etc. */
#include <stdint.h>   /* int8_t, uint32_t — exact-width types        */
#include <stdbool.h>

int	main(void)
{
	/* --- SIZES ON THIS MACHINE — always use sizeof(), never assume --- */
	printf("=== Type Sizes (this machine) ===\n");
	printf("char:      %zu byte(s)\n", sizeof(char));
	printf("short:     %zu byte(s)\n", sizeof(short));
	printf("int:       %zu byte(s)\n", sizeof(int));
	printf("long:      %zu byte(s)\n", sizeof(long));
	printf("long long: %zu byte(s)\n", sizeof(long long));
	printf("float:     %zu byte(s)\n", sizeof(float));
	printf("double:    %zu byte(s)\n", sizeof(double));
	printf("pointer:   %zu byte(s)\n\n", sizeof(void *));

	/* --- LIMITS — pulled from <limits.h>, not hardcoded --- */
	printf("=== Integer Limits ===\n");
	printf("INT_MAX:  %d\n", INT_MAX);
	printf("INT_MIN:  %d\n", INT_MIN);
	printf("CHAR_MAX: %d\n", CHAR_MAX);
	printf("CHAR_MIN: %d\n\n", CHAR_MIN);

	/* --- SIGNED OVERFLOW — undefined behavior, shown for education only --- */
	printf("=== Signed Overflow (do NOT rely on this in real code) ===\n");
	int	max = INT_MAX;
	printf("INT_MAX + 1 = %d  (wraps to INT_MIN on most compilers)\n\n", max + 1);

	/* --- UNSIGNED WRAPAROUND — this is well-defined by the C standard --- */
	printf("=== Unsigned Wraparound (well-defined behavior) ===\n");
	unsigned int	u = 0;
	printf("0u - 1 = %u  (wraps to UINT_MAX)\n\n", u - 1);

	/* --- SIGNED vs UNSIGNED GOTCHA — same bits, different interpretation --- */
	printf("=== Signed vs Unsigned Gotcha ===\n");
	signed char		sc = -1;
	unsigned char	uc = (unsigned char)sc; /* reinterprets the same byte */
	printf("signed char   -1 = %d\n", sc);
	printf("unsigned char -1 = %u  (same bits, read as 255)\n\n", uc);

	/* --- EXACT-WIDTH TYPES — portable and explicit, prefer these --- */
	printf("=== Exact-Width Types (best practice for portability) ===\n");
	int8_t   i8  = -128;
	uint8_t  u8  = 255;
	int32_t  i32 = -2147483648;
	uint64_t u64 = 18446744073709551615ULL;
	printf("int8_t:   %d\n", i8);
	printf("uint8_t:  %u\n", u8);
	printf("int32_t:  %d\n", i32);
	printf("uint64_t: %llu\n", (unsigned long long)u64);

	return (0);
}
