/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_print_comb2.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/09 22:55:18 by miles23           #+#    #+#             */
/*   Updated: 2026/02/09 22:55:22 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

void	print_comb2(void)
{
	int	a;
	int	b;
	char	digit;

	a = 0;
	while (a <= 98)
	{
		b = a + 1;
		while (b <= 99)
		{
			digit = (a / 10) + '0';
			write(1, &digit, 1);
			digit = (a % 10) + '0';
			write(1, &digit, 1);
			write(1, " ", 1);
			digit = (b / 10) + '0';
			write(1, &digit, 1);
			digit = (b % 10) + '0';
			write(1, &digit, 1);
			if (!(a == 98 && b == 99))
				write(1, ", ", 2);
			b++;
		}
		a++;
	}
}

int	main(void)
{
	print_comb2();
	return (0);
}

