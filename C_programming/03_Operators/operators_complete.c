/* ************************************************************************** */
/*                                                                            */
/*   Project : Operators Complete Guide                                       */
/*   Author  : Miles3103                                                      */
/*   Topic   : Operators — arithmetic, bitwise, logical, ternary              */
/*                                                                            */
/* ************************************************************************** */

/*
** OPERATORS IN C — THE COMPLETE PICTURE
**
** 1. ARITHMETIC:  + - * / %
** 2. RELATIONAL:  == != > < >= <=    (return 0 or 1)
** 3. LOGICAL:     && || !            (short-circuit evaluation!)
** 4. BITWISE:     & | ^ ~ << >>     (operate on individual bits)
** 5. ASSIGNMENT:  = += -= *= /= %= <<= >>= &= |= ^=
** 6. TERNARY:     condition ? val_true : val_false
**
** CRITICAL GOTCHAS:
**   - Integer division TRUNCATES: 7 / 2 = 3, not 3.5
**   - % only works on integers
**   - && and || SHORT-CIRCUIT — right side may never run
**   - Bitwise & is NOT the same as logical &&
*/

#include <stdio.h>

int	main(void)
{
	int a = 10;
	int b = 3;

	/* --- ARITHMETIC --- */
	printf("=== Arithmetic ===\n");
	printf("%d + %d = %d\n", a, b, a + b);
	printf("%d - %d = %d\n", a, b, a - b);
	printf("%d * %d = %d\n", a, b, a * b);
	printf("%d / %d = %d  (truncates!)\n", a, b, a / b);
	printf("%d %% %d = %d (remainder)\n\n", a, b, a % b);

	/* --- DIVISION GOTCHA: cast BEFORE dividing --- */
	printf("=== Division Precision ===\n");
	printf("7 / 2       = %d     (int division)\n", 7 / 2);
	printf("(double)7/2 = %.4f (float division)\n\n", (double)7 / 2);

	/* --- BITWISE — used heavily in systems programming --- */
	printf("=== Bitwise Operators ===\n");
	int	ba = 10;
	int	bb = 12;
	printf("10 & 12  = %d   (AND)\n",  ba & bb);
	printf("10 | 12  = %d   (OR)\n",   ba | bb);
	printf("10 ^ 12  = %d   (XOR)\n",  ba ^ bb);
	printf("~10      = %d  (NOT)\n",   ~ba);
	printf("10 << 1  = %d   (x2)\n",   ba << 1);
	printf("10 >> 1  = %d   (/2)\n\n", ba >> 1);

	/* --- BIT FLAGS — real-world use of bitwise --- */
	printf("=== Bit Flags (real-world pattern) ===\n");
	int	flags = 0;
	flags |= (1 << 0);  /* set READ  bit */
	flags |= (1 << 1);  /* set WRITE bit */
	printf("flags after READ|WRITE: %d\n", flags);
	printf("READ bit set?  %s\n", (flags & (1 << 0)) ? "yes" : "no");
	printf("EXEC bit set?  %s\n", (flags & (1 << 2)) ? "yes" : "no");
	flags &= ~(1 << 1); /* clear WRITE bit */
	printf("After clearing WRITE:   %d\n\n", flags);

	/* --- LOGICAL SHORT-CIRCUIT --- */
	printf("=== Logical Short-Circuit ===\n");
	int	x = 0;
	/* x != 0 is false, so 10/x is NEVER evaluated -> no crash */
	if (x != 0 && (10 / x > 1))
		printf("division happened\n");
	else
		printf("&& short-circuited: division by zero avoided\n");

	/* --- TERNARY CHAINED --- */
	printf("\n=== Ternary ===\n");
	int score = 75;
	char *grade = (score >= 90) ? "A" :
	              (score >= 80) ? "B" :
	              (score >= 70) ? "C" : "F";
	printf("Score %d -> Grade: %s\n", score, grade);

	return (0);
}
