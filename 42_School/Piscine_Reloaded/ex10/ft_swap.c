/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_swap.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: iismail- <iismail-@student.42warsaw.pl>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/06/20 17:48:43 by iismail-          #+#    #+#             */
/*   Updated: 2026/06/20 18:01:40 by iismail-         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

void	ft_putchar(char c)
{
	write (1, &c, 1);
}

void	ft_sawp(int *a, int *b)
{
	int	temp;

	temp = *a;
	*a = *b;
	*b = temp;
}

int	main(void)
{
	int	x;
	int	y;

	x = 4;
	y = 9;
	ft_putchar(x + '0');
	ft_putchar(':');
	ft_putchar(y + '0');
	ft_sawp(&x, &y);
	ft_putchar('\n');
	ft_putchar(x + '0');
	ft_putchar(':');
	ft_putchar(y + '0');
	ft_putchar('\n');
	return (0);
}
