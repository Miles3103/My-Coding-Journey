/* ************************************************************************** */
/*                                                                            */
/*   Project : Operators Complete Guide                                       */
/*   Author  : Miles3103                                                      */
/*   Topic   : Operators — arithmetic, bitwise, logical, ternary              */
/*                                                                            */
/* ************************************************************************** */

/*
** WHAT ARE OPERATORS AND WHY DO THE GOTCHAS MATTER?
**
**   Operators are symbols that tell the compiler to perform an operation
**   on one or more operands. C has six families:
**     1. ARITHMETIC  + - * / %
**     2. RELATIONAL  == != > < >= <=   (always return 0 or 1)
**     3. LOGICAL     && || !           (short-circuit evaluation)
**     4. BITWISE     & | ^ ~ << >>    (work on individual bits)
**     5. ASSIGNMENT  = += -= *= /= %= <<= >>= &= |= ^=
**     6. TERNARY     condition ? val_if_true : val_if_false
**
** CRITICAL GOTCHAS:
**   Integer division TRUNCATES → 7 / 2 = 3, not 3.5
**   % only works on integers — use fmod() for floats
**   && and || SHORT-CIRCUIT — the right side may never be evaluated
**   Bitwise & is NOT the same as logical && — completely different purpose
**
** BITWISE IN PRACTICE:
**   Bitwise operators are used heavily in systems programming for
**   bit flags, masks, permissions, hardware registers, and fast math:
**     x << 1  multiplies by 2   (shift bits left)
**     x >> 1  divides by 2      (shift bits right)
**
** NOTE:
**   When mixing integer and float arithmetic, cast BEFORE the operation:
**   (double)7 / 2 = 3.5, but 7 / 2 = 3 (the damage is already done).
*/

#include <stdio.h>

int	main(void)
{
	int	a = 10;
	int	b = 3;

	/* --- ARITHMETIC --- */
	printf("=== Arithmetic ===\n");
	printf("%d + %d = %d\n", a, b, a + b);
	printf("%d - %d = %d\n", a, b, a - b);
	printf("%d * %d = %d\n", a, b, a * b);
	printf("%d / %d = %d  (truncates!)\n", a, b, a / b);
	printf("%d %% %d = %d (remainder)\n\n", a, b, a % b);

	/* --- DIVISION GOTCHA: cast BEFORE dividing, not after --- */
	printf("=== Division Precision ===\n");
	printf("7 / 2       = %d     (int division — truncates)\n", 7 / 2);
	printf("(double)7/2 = %.4f (float division — correct)\n\n", (double)7 / 2);

	/* --- BITWISE — used heavily in systems and 42 projects --- */
	printf("=== Bitwise Operators ===\n");
	int	ba = 10;
	int	bb = 12;
	printf("10 & 12  = %d   (AND  — bits set in BOTH)\n",  ba & bb);
	printf("10 | 12  = %d   (OR   — bits set in EITHER)\n", ba | bb);
	printf("10 ^ 12  = %d   (XOR  — bits set in ONE, not both)\n", ba ^ bb);
	printf("~10      = %d  (NOT  — flip every bit)\n",   ~ba);
	printf("10 << 1  = %d   (LEFT SHIFT  = x2)\n",   ba << 1);
	printf("10 >> 1  = %d   (RIGHT SHIFT = /2)\n\n", ba >> 1);

	/* --- BIT FLAGS — real-world pattern for permissions/modes --- */
	printf("=== Bit Flags (real-world pattern) ===\n");
	int	flags = 0;
	flags |= (1 << 0);  /* set READ  bit */
	flags |= (1 << 1);  /* set WRITE bit */
	printf("flags after READ|WRITE: %d\n", flags);
	printf("READ bit set?  %s\n", (flags & (1 << 0)) ? "yes" : "no");
	printf("EXEC bit set?  %s\n", (flags & (1 << 2)) ? "yes" : "no");
	flags &= ~(1 << 1); /* clear WRITE bit */
	printf("After clearing WRITE:   %d\n\n", flags);

	/* --- LOGICAL SHORT-CIRCUIT — right side only runs if needed --- */
	printf("=== Logical Short-Circuit ===\n");
	int	x = 0;
	/* x != 0 is false, so (10 / x) is NEVER evaluated — no crash */
	if (x != 0 && (10 / x > 1))
		printf("division happened\n");
	else
		printf("&& short-circuited: division by zero avoided\n");

	/* --- TERNARY — compact if/else for single expressions --- */
	printf("\n=== Ternary ===\n");
	int		score = 75;
	char	*grade = (score >= 90) ? "A" :
	               (score >= 80) ? "B" :
	               (score >= 70) ? "C" : "F";
	printf("Score %d -> Grade: %s\n", score, grade);

	return (0);
}
