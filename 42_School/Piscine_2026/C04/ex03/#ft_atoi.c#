/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_atoi.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 01:55:03 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 01:56:27 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

int ft_atoi(char *str)
{
    int i = 0;
    int sign = 1;
    int result = 0;

    // Skip whitespace
    while (str[i] == ' ' || str[i] == '\t' || str[i] == '\n'
        || str[i] == '\v' || str[i] == '\f' || str[i] == '\r')
        i++;

    // Handle + and - signs
    while (str[i] == '+' || str[i] == '-')
    {
        if (str[i] == '-')
            sign = -sign; // flip sign for each '-'
        i++;
    }

    // Process digits
    while (str[i] >= '0' && str[i] <= '9')
    {
        result = result * 10 + (str[i] - '0');
        i++;
    }

    return result * sign;
}

#include <stdio.h>

int main(void)
{
    char str1[] = "   ---+--+1234ab567";
    char str2[] = "\t\n  -42";
    char str3[] = "+123";
    char str4[] = "42abc";

    printf("%d\n", ft_atoi(str1)); // Output: -1234
    printf("%d\n", ft_atoi(str2)); // Output: -42
    printf("%d\n", ft_atoi(str3)); // Output: 123
    printf("%d\n", ft_atoi(str4)); // Output: 42

    return 0;
}
