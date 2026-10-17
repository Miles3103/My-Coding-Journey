/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_rev_int_tab.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 00:05:41 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 00:23:07 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>
#include <stdio.h>

void	ft_rev_int_tab(int *tab, int size)
{
	int	temp;
	int	i;

	i = 0;
	while (i < size / 2)
	{
		// Swap tab[i] and tab[size - 1 - i]
		temp = tab[i];
		tab[i] = tab[size - 1 -i];
		tab[size - 1 - i] = temp;
		i++;
	}
}

int	main(void)
{
	int	arr[] = {1, 2, 3, 4, 5, 6, 7, 8, 9,10};
	int	size = sizeof(arr)/sizeof(arr[0]);
int	i;
	ft_rev_int_tab(arr, size);

	while (i < size)
	{
		printf("%d", arr[i]);
		i++;
	}
	write (1, "\n", 1);
	return 0;
}

