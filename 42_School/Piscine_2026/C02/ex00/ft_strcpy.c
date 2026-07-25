/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strcpy.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/07 21:33:25 by miles23           #+#    #+#             */
/*   Updated: 2026/02/07 21:41:26 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>
#include <stdio.h>
char	*ft_strcpy(char *dest, char *src)
{
	int	i;

	i = 0;
	while (src[i] != '\0')
	{
		dest[i] = src[i];
	       i++;
	}
	dest[i] = '\0';
	return (dest);
}

int	main(void)
{
	char src[] = "ismail abdalla";
	char dest[30];

	printf("%s\n", ft_strcpy(dest, src));
	return (0);
}
