/* ************************************************************************** */
/*                                                                            */
/*   Project : ft_putnbr                                                      */
/*   Author  : Miles3103                                                      */
/*   Topic   : C Intro — output without printf                                */
/*                                                                            */
/* ************************************************************************** */

/*
** CHALLENGE: Print an integer using ONLY write().
**
** This is a critical skill. You can't use printf in many contexts.
** This function teaches you:
**   - How integers are made of individual digits
**   - Recursion basics
**   - ASCII arithmetic: adding '0' (48) converts digit to char
**
** ALGORITHM:
**   1. Handle negative: print '-', negate n
**   2. If n has more than 1 digit, recurse with n / 10
**   3. Print last digit: n % 10 + '0'
*/

#include <unistd.h>

/*
** @desc   Prints one character to stdout using write()
** @param  c : the character to print
*/
void	ft_putchar(char c)
{
	write(1, &c, 1);
}

/*
** @desc   Prints an integer to stdout using only write()
** @param  n : the integer to print (handles negatives and INT_MIN)
*/
void	ft_putnbr(int n)
{
	/* Handle the most negative int separately to avoid overflow */
	if (n == -2147483648)
	{
		write(1, "-2147483648", 11);
		return ;
	}
	/* Print minus sign and negate for negatives */
	if (n < 0)
	{
		ft_putchar('-');
		n = -n;
	}
	/* Recurse to print leading digits first */
	if (n >= 10)
		ft_putnbr(n / 10);
	/* Print current last digit as a character */
	ft_putchar((n % 10) + '0');
}

int	main(void)
{
	ft_putnbr(0);
	ft_putchar('\n');
	ft_putnbr(42);
	ft_putchar('\n');
	ft_putnbr(-7);
	ft_putchar('\n');
	ft_putnbr(2147483647);   /* INT_MAX */
	ft_putchar('\n');
	ft_putnbr(-2147483648);  /* INT_MIN */
	ft_putchar('\n');

	return (0);
}
