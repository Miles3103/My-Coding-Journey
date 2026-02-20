/* ************************************************************************** */
/*                                                                            */
/*   Project : Data Types & Limits                                            */
/*   Author  : Miles3103                                                      */
/*   Topic   : Data Types — sizes, limits, overflow, signed vs unsigned       */
/*                                                                            */
/* ************************************************************************** */

/*
** DATA TYPE INTERNALS
**
** C doesn't tell you the exact size of int — it's platform dependent.
** On modern 64-bit Linux: char=1, short=2, int=4, long=8, long long=8
**
** SIGNED vs UNSIGNED:
**   signed   char : -128          to  127
**   unsigned char :    0          to  255
**   signed   int  : -2,147,483,648 to  2,147,483,647
**   unsigned int  :    0          to  4,294,967,295
**
** OVERFLOW (signed): undefined behavior in C — can crash or corrupt data
** WRAPAROUND (unsigned): well-defined — wraps from MAX back to 0
**
** KEY RULE: Use the right type for the job.
**   - Counting, indexing   → size_t (unsigned)
**   - Characters           → char
**   - Precise math         → double not float
**   - Flags / truth values → int or bool
*/

#include <stdio.h>
#include <limits.h>   /* INT_MAX, INT_MIN, CHAR_MAX, etc. */
#include <stdint.h>   /* int8_t, uint32_t — exact-width types */
#include <stdbool.h>

int	main(void)
{
	/* --- SIZES ON THIS MACHINE --- */
	printf("=== Type Sizes (this machine) ===\n");
	printf("char:        %zu byte(s)\n", sizeof(char));
	printf("short:       %zu byte(s)\n", sizeof(short));
	printf("int:         %zu byte(s)\n", sizeof(int));
	printf("long:        %zu byte(s)\n", sizeof(long));
	printf("long long:   %zu byte(s)\n", sizeof(long long));
	printf("float:       %zu byte(s)\n", sizeof(float));
	printf("double:      %zu byte(s)\n", sizeof(double));
	printf("pointer:     %zu byte(s)\n\n", sizeof(void *));

	/* --- LIMITS FROM <limits.h> --- */
	printf("=== Integer Limits ===\n");
	printf("INT_MAX:   %d\n", INT_MAX);
	printf("INT_MIN:   %d\n", INT_MIN);
	printf("CHAR_MAX:  %d\n", CHAR_MAX);
	printf("CHAR_MIN:  %d\n\n", CHAR_MIN);

	/* --- OVERFLOW DEMO (signed — technically UB, educational only) --- */
	printf("=== Signed Overflow (do NOT rely on this in real code) ===\n");
	int	max = INT_MAX;
	printf("INT_MAX + 1 = %d  (wraps to INT_MIN!)\n\n", max + 1);

	/* --- UNSIGNED WRAPAROUND (well-defined behavior) --- */
	printf("=== Unsigned Wraparound (this IS well-defined) ===\n");
	unsigned int	u = 0;
	printf("0u - 1 = %u  (wraps to UINT_MAX)\n\n", u - 1);

	/* --- SIGNED vs UNSIGNED GOTCHA --- */
	printf("=== Signed vs Unsigned Gotcha ===\n");
	signed char		sc = -1;
	unsigned char	uc = (unsigned char)sc;
	printf("signed char -1   = %d\n", sc);
	printf("unsigned char -1 = %u  (reinterpreted as 255)\n\n", uc);

	/* --- EXACT WIDTH TYPES (from <stdint.h>) — portable & explicit --- */
	printf("=== Exact-Width Types (best practice for portability) ===\n");
	int8_t	 i8  = -128;
	uint8_t  u8  = 255;
	int32_t  i32 = -2147483648;
	uint64_t u64 = 18446744073709551615ULL;
	printf("int8_t:   %d\n", i8);
	printf("uint8_t:  %u\n", u8);
	printf("int32_t:  %d\n", i32);
	printf("uint64_t: %llu\n", (unsigned long long)u64);

	return (0);
}
