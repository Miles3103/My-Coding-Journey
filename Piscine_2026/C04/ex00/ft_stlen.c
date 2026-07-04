/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_stlen.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 01:49:50 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 01:50:41 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int ft_strlen(char *str)
{
    int count = 0;

    while (str[count] != '\0') // Loop until the end of the string
        count++;

    return count; // Return the number of characters
}

#include <stdio.h>

int main(void)
{
    char str[] = "Hello, World!";
    int len;

    len = ft_strlen(str);
    printf("Length: %d\n", len); // Output: 13

    return 0;
}
