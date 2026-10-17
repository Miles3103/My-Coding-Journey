/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_ft.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/01/27 11:09:36 by miles23           #+#    #+#             */
/*   Updated: 2026/02/09 23:20:49 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

/*
** This function takes a pointer to int
** and changes the value stored at that address to 42
*/
void	ft_ft(int *nbr)
{
	*nbr = 42;
}

/*
** write prints characters, not numbers.
** We must convert the number to characters.
*/
void	ft_putchar(char c)
{
	write(1, &c, 1);
}

/*
** Print an integer using only write
*/
void	ft_putnbr(int n)
{
	if (n >= 10)
		ft_putnbr(n / 10);
	ft_putchar((n % 10) + '0');
}

int	main(void)
{
	int	n;

	n = 12;
	ft_ft(&n);      /* n becomes 42 */
	ft_putnbr(n);   /* prints 42 */
	return (0);
}

