/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_putstr.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/09 23:45:09 by miles23           #+#    #+#             */
/*   Updated: 2026/02/09 23:49:53 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

void ft_putstr(char *str)
{
    int i = 0;

    while (str[i] != '\0') // loop until end of string
    {
        write(1, &str[i], 1); // write one character at a time
        i++;
    }
}


int	main(void)
{
	ft_putstr("Hello World!");
	return 0;
}
