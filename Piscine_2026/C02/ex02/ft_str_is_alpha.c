/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_str_is_alpha.c                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/07 21:52:44 by miles23           #+#    #+#             */
/*   Updated: 2026/02/07 22:48:32 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>
#include <stdio.h>

int	ft_str_is_alpha(char *str)
{
	int	i;

	i = 0;
	while (str[i] != '\0')
	{
		if(! ( str[i] >= 'a' && str[i] <= 'z' || str[i] >= 'A' && str[i] <= 'Z'))
			return (0);
		i++;
	}
	return (1);
}


int	main(int argc, char **argv)
{
	int	i;

	i = 0;
	while (i < argc)
	{
		printf("Arg[%d] (%s) :%d\n", i, argv[i], ft_str_is_alpha(argv[i]));
		i++;
	}
	return (0);
}
