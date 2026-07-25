/* ************************************************************************** */
/*                                                                            */
/*   Project : Functions — Introduction                                       */
/*   Author  : Miles3103                                                      */
/*   Topic   : Functions — syntax, prototypes, return values, void            */
/*                                                                            */
/* ************************************************************************** */

/*
** WHAT IS A FUNCTION AND WHY DO WE USE THEM?
**
**   A function is a named, reusable block of code. Instead of writing the
**   same logic over and over, you write it once and call it by name.
**
**   Every C program is built from functions. main() itself is a function —
**   it is simply the one the operating system calls to start your program.
**
** ANATOMY OF A FUNCTION:
**
**   return_type  function_name  (parameter_type parameter_name, ...)
**   {
**       /* body */
**       return (value);
**   }
**
**   return_type  → the type of value the function sends back (void = nothing)
**   function_name → any valid identifier; use snake_case by convention
**   parameters   → inputs the caller provides; each needs a type and a name
**   return       → sends a value back and exits the function immediately
**
** PROTOTYPES:
**   C reads top-to-bottom. If you call a function before its definition,
**   the compiler doesn't know its signature and will error.
**   A prototype declares the signature above the first call site:
**
**     int ft_square(int n);  ← prototype (semicolon, no body)
**
**   In 42 style, prototypes go at the top of the file or in a .h header.
**
** VOID FUNCTIONS:
**   If a function does not return a value, declare its type as void.
**   void functions use return; (no value) or omit it entirely.
**
** NOTE:
**   A function should do ONE thing and do it well.
**   If you find yourself writing a 100-line function, it is doing too much.
**   Split it into smaller functions with clear, descriptive names.
*/

#include <stdio.h>
#include <unistd.h>

/* --- PROTOTYPES — declared here so main() can call them below --- */
int		ft_square(int n);
int		ft_is_even(int n);
int		ft_clamp(int value, int min, int max);
void	ft_print_line(char c, int length);
void	ft_print_box(int width, int height);

/* ============================================================ */
/*  FUNCTIONS THAT RETURN A VALUE                               */
/* ============================================================ */

/*
** @desc   Returns the square of n.
** @param  n      : integer to square
** @return        : n * n
*/
int	ft_square(int n)
{
	return (n * n);
}

/*
** @desc   Returns 1 if n is even, 0 if odd.
**         Uses the modulo operator — remainder of n / 2.
** @param  n      : integer to test
** @return        : 1 if even, 0 if odd
*/
int	ft_is_even(int n)
{
	return (n % 2 == 0);
}

/*
** @desc   Clamps value into the range [min, max].
**         If value is below min, returns min.
**         If value is above max, returns max.
**         Otherwise returns value unchanged.
** @param  value  : the number to clamp
** @param  min    : lower bound (inclusive)
** @param  max    : upper bound (inclusive)
** @return        : clamped value
*/
int	ft_clamp(int value, int min, int max)
{
	if (value < min)
		return (min);
	if (value > max)
		return (max);
	return (value);
}

/* ============================================================ */
/*  VOID FUNCTIONS — perform an action, return nothing          */
/* ============================================================ */

/*
** @desc   Prints a horizontal line of 'length' copies of character c.
** @param  c      : character to repeat
** @param  length : how many characters to print
*/
void	ft_print_line(char c, int length)
{
	int	i;

	i = 0;
	while (i < length)
	{
		write(1, &c, 1);
		i++;
	}
	write(1, "\n", 1);
}

/*
** @desc   Prints a hollow rectangle of '*' characters.
**         Top and bottom rows are solid; middle rows are border only.
** @param  width  : number of characters per row
** @param  height : number of rows
*/
void	ft_print_box(int width, int height)
{
	int	row;
	int	col;

	row = 0;
	while (row < height)
	{
		col = 0;
		while (col < width)
		{
			/* print '*' on borders, ' ' in the interior */
			if (row == 0 || row == height - 1 || col == 0 || col == width - 1)
				write(1, "*", 1);
			else
				write(1, " ", 1);
			col++;
		}
		write(1, "\n", 1);
		row++;
	}
}

/* ============================================================ */
/*  FUNCTIONS CALLING FUNCTIONS                                  */
/* ============================================================ */

/*
** @desc   Prints a table of squares for numbers 1 to n.
**         Calls ft_square() and ft_is_even() internally.
** @param  n : upper limit of the table
*/
void	print_squares_table(int n)
{
	printf("%-6s %-10s %-6s\n", "Number", "Square", "Even?");
	ft_print_line('-', 24);
	for (int i = 1; i <= n; i++)
		printf("%-6d %-10d %-6s\n",
			i,
			ft_square(i),
			ft_is_even(i) ? "yes" : "no");
}

/* ============================================================ */
/*  MAIN                                                         */
/* ============================================================ */

int	main(void)
{
	/* --- RETURN VALUE FUNCTIONS --- */
	printf("=== ft_square ===\n");
	printf("ft_square(5)  = %d\n", ft_square(5));
	printf("ft_square(12) = %d\n\n", ft_square(12));

	printf("=== ft_is_even ===\n");
	printf("ft_is_even(4) = %d (1 = true)\n", ft_is_even(4));
	printf("ft_is_even(7) = %d (0 = false)\n\n", ft_is_even(7));

	printf("=== ft_clamp ===\n");
	printf("ft_clamp(50, 0, 100)   = %d\n", ft_clamp(50, 0, 100));
	printf("ft_clamp(-10, 0, 100)  = %d (clamped to min)\n", ft_clamp(-10, 0, 100));
	printf("ft_clamp(200, 0, 100)  = %d (clamped to max)\n\n", ft_clamp(200, 0, 100));

	/* --- VOID FUNCTIONS --- */
	printf("=== ft_print_line ===\n");
	ft_print_line('=', 30);
	ft_print_line('-', 20);
	ft_print_line('*', 10);
	printf("\n");

	printf("=== ft_print_box (5x4) ===\n");
	ft_print_box(5, 4);
	printf("\n");

	printf("=== ft_print_box (10x6) ===\n");
	ft_print_box(10, 6);
	printf("\n");

	/* --- FUNCTIONS CALLING FUNCTIONS --- */
	printf("=== Squares Table (1 to 8) ===\n");
	print_squares_table(8);

	return (0);
}
