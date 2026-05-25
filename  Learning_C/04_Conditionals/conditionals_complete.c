/* ************************************************************************** */
/*                                                                            */
/*   Project : Conditionals — Complete Guide                                  */
/*   Author  : Miles3103                                                      */
/*   Topic   : Conditionals — if/else, switch, ternary, guard clauses         */
/*                                                                            */
/* ************************************************************************** */

/*
** WHAT ARE CONDITIONALS AND WHY DO THEY MATTER?
**
**   Conditionals let your program make decisions at runtime.
**   Without them, every program would run the same way every time.
**
**   C has three conditional constructs:
**
**   if / else if / else
**     → the most general form — handles any boolean condition
**     → chains with else if for multiple exclusive branches
**     → the else catches everything that didn't match above
**
**   switch (expression)
**     → cleaner than a long if/else if chain when testing ONE variable
**       against multiple constant values
**     → requires break at the end of each case to prevent FALLTHROUGH
**     → default: acts like the final else
**
**   ternary: condition ? value_if_true : value_if_false
**     → a compact single-expression if/else
**     → best for simple assignments — avoid nesting them deeply
**
** GUARD CLAUSES (early return pattern):
**   Instead of deeply nested if/else blocks, return early when a
**   condition fails. This keeps functions flat and readable.
**
**   BAD (deeply nested):          GOOD (guard clause):
**   if (x > 0) {                  if (x <= 0)
**       if (y > 0) {                  return ;
**           do_work();            if (y <= 0)
**       }                             return ;
**   }                             do_work();
**
** NOTE:
**   In C, there is no boolean type by default — any non-zero value is
**   true, and 0 is false. #include <stdbool.h> gives you true/false
**   keywords as aliases for 1 and 0.
**   Common mistake: writing = instead of == in a condition.
**   if (x = 5) assigns 5 to x and is always true — not a comparison.
*/

#include <stdio.h>
#include <stdbool.h>

/* ============================================================ */
/*  IF / ELSE IF / ELSE                                          */
/* ============================================================ */

/*
** @desc   Classifies a temperature into a human-readable description.
** @param  celsius : temperature in degrees Celsius
*/
void	describe_temperature(int celsius)
{
	printf("Temperature %d°C is: ", celsius);
	if (celsius < 0)
		printf("freezing\n");
	else if (celsius < 10)
		printf("cold\n");
	else if (celsius < 20)
		printf("cool\n");
	else if (celsius < 30)
		printf("warm\n");
	else
		printf("hot\n");
}

/* ============================================================ */
/*  SWITCH — cleaner for testing one variable against constants  */
/* ============================================================ */

/*
** @desc   Prints the name of a day given its number (1=Monday).
** @param  day : integer 1–7
**
** IMPORTANT: without break, execution FALLS THROUGH to the next case.
** Fallthrough is occasionally useful but almost always a bug.
*/
void	print_day(int day)
{
	printf("Day %d: ", day);
	switch (day)
	{
		case 1:  printf("Monday\n");    break ;
		case 2:  printf("Tuesday\n");   break ;
		case 3:  printf("Wednesday\n"); break ;
		case 4:  printf("Thursday\n");  break ;
		case 5:  printf("Friday\n");    break ;
		case 6:  printf("Saturday\n");  break ;
		case 7:  printf("Sunday\n");    break ;
		default: printf("Invalid day\n");       /* no break needed at the end */
	}
}

/*
** @desc   Demonstrates intentional fallthrough — grouping cases together.
** @param  day : integer 1–7
*/
void	is_weekend(int day)
{
	printf("Day %d is a: ", day);
	switch (day)
	{
		case 6:
		case 7:
			printf("weekend\n");  /* both 6 and 7 fall into this block */
			break ;
		default:
			printf("weekday\n");
	}
}

/* ============================================================ */
/*  TERNARY — compact conditional expression                     */
/* ============================================================ */

/*
** @desc   Returns the larger of two integers.
**         Ternary is perfect here — one clear condition, two values.
** @param  a, b : integers to compare
** @return      : the larger value
*/
int	ft_max(int a, int b)
{
	return (a > b ? a : b); /* if a > b return a, else return b */
}

/*
** @desc   Returns a string describing whether n is even or odd.
** @param  n : integer to test
*/
char	*even_or_odd(int n)
{
	return (n % 2 == 0 ? "even" : "odd");
}

/* ============================================================ */
/*  GUARD CLAUSES — the flat, readable alternative to nesting   */
/* ============================================================ */

/*
** @desc   Divides a by b safely, using guard clauses to handle errors.
**         Each bad condition is rejected at the top — no deep nesting.
** @param  a, b : operands
** @return      : result of a / b, or 0 on error
*/
double	safe_divide(int a, int b)
{
	if (b == 0)
	{
		printf("  [error] division by zero\n");
		return (0);
	}
	return ((double)a / b); /* only reached if b != 0 */
}

/*
** @desc   Validates a score and assigns a grade, using guard clauses.
** @param  score : expected to be 0–100
** @return       : letter grade character, or '?' on invalid input
*/
char	grade_from_score(int score)
{
	if (score < 0 || score > 100) /* guard: reject invalid input first */
		return ('?');
	if (score >= 90) return ('A');
	if (score >= 80) return ('B');
	if (score >= 70) return ('C');
	if (score >= 60) return ('D');
	return ('F');
}

/* ============================================================ */
/*  MAIN                                                         */
/* ============================================================ */

int	main(void)
{
	/* --- IF / ELSE IF / ELSE --- */
	printf("=== Temperature Classifier ===\n");
	describe_temperature(-5);
	describe_temperature(5);
	describe_temperature(15);
	describe_temperature(25);
	describe_temperature(35);
	printf("\n");

	/* --- SWITCH --- */
	printf("=== Days of the Week ===\n");
	for (int d = 1; d <= 7; d++)
		print_day(d);
	print_day(9);  /* triggers default */
	printf("\n");

	printf("=== Weekend Check (fallthrough) ===\n");
	for (int d = 5; d <= 7; d++)
		is_weekend(d);
	printf("\n");

	/* --- TERNARY --- */
	printf("=== Ternary Operator ===\n");
	printf("ft_max(7, 12)   = %d\n", ft_max(7, 12));
	printf("ft_max(99, 3)   = %d\n", ft_max(99, 3));
	printf("42 is %s\n", even_or_odd(42));
	printf("17 is %s\n\n", even_or_odd(17));

	/* --- GUARD CLAUSES --- */
	printf("=== Safe Division (guard clauses) ===\n");
	printf("10 / 2 = %.2f\n", safe_divide(10, 2));
	printf("10 / 0 = ");
	safe_divide(10, 0);
	printf("\n");

	printf("=== Grade from Score ===\n");
	int	scores[] = {-1, 55, 65, 75, 85, 95, 101};
	int	n = sizeof(scores) / sizeof(scores[0]);
	for (int i = 0; i < n; i++)
		printf("score %4d → grade: %c\n", scores[i], grade_from_score(scores[i]));

	return (0);
}
