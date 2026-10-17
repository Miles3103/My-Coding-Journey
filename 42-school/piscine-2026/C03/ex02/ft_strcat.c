/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strcat.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 01:17:46 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 01:27:06 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

char	*ft_strcat(char *dest, char *src)
{
	int	i;
	int	j;

	i = 0;
	j = 0;
    	// Find the end of dest
    	while (dest[i] != '\0')
	i++;
	// Copy src to the end of dest		
	while (src[j] != '\0')
    	{
		dest[i] = src[j];
        	i++;
       		j++;
	}
	dest[i] = '\0'; // null-terminate dest
	return dest;
}

#include <stdio.h>

int	main(void)
{
	char	dest[50] = "Hello, ";
	char	src[] = "World!";
	ft_strcat(dest, src);
	printf("%s\n", dest); // Output: Hello, World!
	return 0;
}
