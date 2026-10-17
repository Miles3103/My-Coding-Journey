/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_print_combn.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/09 23:12:34 by miles23           #+#    #+#             */
/*   Updated: 2026/02/09 23:17:23 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

/*
** This function prints the current combination stored in the array "tab".
** If it is not the last combination, it also prints ", ".
*/
void	print_comb(int *tab, int n)
{
	int		i;
	char	c;

	i = 0;
	while (i < n)
	{
		/* Convert digit to character and print it */
		c = tab[i] + '0';
		write(1, &c, 1);
		i++;
	}
	/* Check if this is the last combination */
	if (tab[0] != 10 - n)
		write(1, ", ", 2);
}

/*
** This recursive function generates all combinations.
** - tab: array that stores the current combination
** - n: number of digits to print
** - index: current position in the array
*/
void	backtrack(int *tab, int n, int index)
{
	int	i;

	/* If we filled all positions, print the combination */
	if (index == n)
	{
		print_comb(tab, n);
		return ;
	}
	/*
	** Start digit:
	** - if index == 0 → start from 0
	** - otherwise → start from previous digit + 1
	*/
	if (index == 0)
		i = 0;
	else
		i = tab[index - 1] + 1;
	/*
	** Limit ensures ascending order and no repetition
	*/
	while (i <= 9 - (n - 1 - index))
	{
		tab[index] = i;
		backtrack(tab, n, index + 1);
		i++;
	}
}

/*
** Main function required by the subject.
** It initializes the array and starts recursion.
*/
void	ft_print_combn(int n)
{
	int	tab[10];

	/* n must be between 1 and 9 */
	if (n < 1 || n > 9)
		return ;
	backtrack(tab, n, 0);
}

int	main(void)
{
	ft_print_combn(3);
	write (1, "\n", 1);
	return 0;
}
