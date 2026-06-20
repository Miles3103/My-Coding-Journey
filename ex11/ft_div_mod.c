/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_div_mod.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: iismail- <iismail-@student.42warsaw.pl>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/06/20 18:13:44 by iismail-          #+#    #+#             */
/*   Updated: 2026/06/20 18:28:37 by iismail-         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

void	ft_putchar(char c)
{
	write (1, &c, 1);
}

void	ft_div_mod(int a, int b, int *div, int *mod)
{
	*div = a / b;
	*mod = a % b;
}

int	main(void)
{
	int	a;
	int	b;
	int	div_res;
	int	mod_res;

	a = 8;
	b = 2;
	div_res = 0;
	mod_res = 0;
	ft_putchar(a + '0');
	ft_putchar(':');
	ft_putchar(b + '0');
	ft_div_mod(a, b, &div_res, &mod_res);
	ft_putchar('\n');
	ft_putchar(div_res + '0');
	ft_putchar('\n');
	ft_putchar(mod_res + '0');
	ft_putcahr('\n');
	return (0);
}
