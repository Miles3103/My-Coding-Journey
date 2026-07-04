/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_putchar.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 01:51:48 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 01:52:08 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

void ft_putstr(char *str)
{
    int i = 0;

    while (str[i] != '\0') // loop until end of string
    {
        write(1, &str[i], 1); // write one character
        i++;
    }
}

int main(void)
{
    ft_putstr("Hello, World!");
    write(1, "\n", 1); // newline for clarity
    return 0;
}
