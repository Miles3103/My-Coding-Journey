/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_sort_int_tab.c                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 00:24:44 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 00:33:55 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

void ft_sort_int_tab(int *tab, int size)
{
	int	i;
	int	j;
	int	temp;

	i = 0;
	while (i < size - 1)
	{
		j = 0;
		while (j < size - 1 - i)
		{
			if (tab[j] > tab[j + 1])
			{
                		// Swap tab[j] and tab[j + 1]
				temp = tab[j];
				tab[j] = tab[j + 1];
				tab[j + 1] = temp;
			}
			j++;
		}
		i++;
	}
}

#include <stdio.h>

int	main(void)
{
	int	arr[] = {5, 2, 9, 1, 6, 3, 7, 4, 8};
	int	size = sizeof(arr) / sizeof(arr[0]);
	int	i;
	ft_sort_int_tab(arr, size);
	while (i < size)
	{
	       printf("%d ", arr[i]); // Output: 1 2 3 4 5 6 7 8 9
		i++;
	}
	return 0;
}
