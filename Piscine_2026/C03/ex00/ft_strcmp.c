/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strcmp.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 00:53:57 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 01:04:33 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>
#include <stdio.h>

int	ft_strcmp(char *s1, char *s2)
{
	int	i;

	i = 0;
	while (s1[i] != '\0' && s2[i] != '\0')
	{
		if (s1[i] != s2[i])
			{
				return (s1[i] - s2[i]);
			}
		i++;
	}
	return (s1[i] - s2[i]);
}

int	main(void)
{
	char	s1[] = "ismail";
	char	s2[] = "abdalla";

	printf("%d\n", ft_strcmp(s1, s2));
	return 0;
}

