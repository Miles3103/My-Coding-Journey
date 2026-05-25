/* ************************************************************************** */
/*                                                                            */
/*   Project : Loops — Complete Guide                                         */
/*   Author  : Miles3103                                                      */
/*   Topic   : Loops — while, for, do-while, break, continue                  */
/*                                                                            */
/* ************************************************************************** */

/*
** LOOPS IN C — THREE TYPES, ONE PURPOSE
**
** while (condition) {}   → check BEFORE, may never run
** do {} while (cond);    → check AFTER, always runs at least once
** for (init; cond; step) → most compact, use when count is known
**
** BREAK:    exits the loop immediately
** CONTINUE: skips to next iteration
**
** RULE: Prefer 'for' when you know the count.
**       Prefer 'while' when you don't.
**       Use 'do-while' for menu/input loops (run at least once).
*/

#include <stdio.h>

/* ============================================================ */
/*  COLLATZ CONJECTURE — while loop showcase                    */
/*  n even → n/2 | n odd → 3n+1 | repeat until n=1            */
/* ============================================================ */

void	collatz(int n)
{
	int	steps;

	steps = 0;
	printf("Collatz(%d): %d", n, n);
	while (n != 1)
	{
		if (n % 2 == 0)
			n = n / 2;
		else
			n = 3 * n + 1;
		printf(" → %d", n);
		steps++;
	}
	printf(" | Steps: %d\n", steps);
}

/* ============================================================ */
/*  FIBONACCI — for loop                                         */
/* ============================================================ */

void	fibonacci(int count)
{
	int	prev;
	int	curr;
	int	next;

	prev = 0;
	curr = 1;
	printf("Fibonacci(%d): ", count);
	for (int i = 0; i < count; i++)
	{
		printf("%d ", prev);
		next = prev + curr;
		prev = curr;
		curr = next;
	}
	printf("\n");
}

/* ============================================================ */
/*  PRIME SIEVE — nested loops + break/continue                  */
/* ============================================================ */

int	is_prime(int n)
{
	if (n < 2)
		return (0);
	for (int i = 2; i * i <= n; i++)
		if (n % i == 0)
			return (0);
	return (1);
}

void	print_primes(int limit)
{
	int	count;

	count = 0;
	printf("Primes up to %d: ", limit);
	for (int i = 2; i <= limit; i++)
	{
		if (!is_prime(i))
			continue ;  /* skip non-primes */
		printf("%d ", i);
		count++;
	}
	printf("| Count: %d\n", count);
}

/* ============================================================ */
/*  TRIANGLE PATTERN — nested for loops                         */
/* ============================================================ */

void	print_triangle(int height)
{
	printf("Triangle (height %d):\n", height);
	for (int i = 1; i <= height; i++)
	{
		for (int j = 0; j < i; j++)
			printf("* ");
		printf("\n");
	}
}

/* ============================================================ */
/*  DO-WHILE — processes array as if validating input           */
/* ============================================================ */

void	validate_demo(void)
{
	int	inputs[] = {-1, 0, 200, 50, -5, 42};
	int	n = 6;
	int	i = 0;

	printf("Input validation with do-while:\n");
	do
	{
		int val = inputs[i];
		if (val < 1 || val > 100)
			printf("  [%d] Invalid: %d\n", i, val);
		else
			printf("  [%d] Valid:   %d\n", i, val);
		i++;
	} while (i < n);
}

/* ============================================================ */
/*  MAIN                                                         */
/* ============================================================ */

int	main(void)
{
	printf("=== Collatz Conjecture ===\n");
	collatz(6);
	collatz(27);
	printf("\n");

	printf("=== Fibonacci Sequence ===\n");
	fibonacci(12);
	printf("\n");

	printf("=== Prime Numbers ===\n");
	print_primes(50);
	printf("\n");

	printf("=== Triangle Pattern ===\n");
	print_triangle(5);
	printf("\n");

	printf("=== do-while Validation ===\n");
	validate_demo();

	return (0);
}
