/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strncar.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 01:28:43 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 01:37:38 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>
#include <stdio.h>

char	*ft_strncat(char *dest, char *src, unsigned int nb)
{
	unsigned int	i;
	unsigned int	j;

	i = 0;
	j = 0;
	/* to find the end of dest */
	while (dest[i] != '\0')
		i++;
	/* Copy at most nb character from src */ 
	while (src[j] != '\0' && j < nb)
	{
		dest[i] = src[j];
		i++;
		j++;
	}

	dest[i] = '\0'; /* null- terminate dest*/
	return (dest);
}

int	main(void)
{
	char dest[50] = "Hello, ";
    	char src[] = "World!";

    	ft_strncat(dest, src, 3); // only append first 3 chars of src
   	printf("%s\n", dest); // Output: Hello, Wor

    	return 0;
}
