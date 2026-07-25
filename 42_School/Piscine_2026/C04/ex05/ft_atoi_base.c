/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_atoi_base.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 02:00:12 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 02:00:34 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

int is_whitespace(char c)
{
    return (c == ' ' || c == '\t' || c == '\n' ||
            c == '\v' || c == '\f' || c == '\r');
}

int is_valid_base(char *base)
{
    int i, j;
    int len = 0;

    while (base[len])
        len++;
    if (len < 2)
        return 0;

    for (i = 0; i < len; i++)
    {
        if (base[i] == '+' || base[i] == '-' || is_whitespace(base[i]))
            return 0;
        for (j = i + 1; j < len; j++)
        {
            if (base[i] == base[j])
                return 0;
        }
    }
    return 1;
}

int char_to_value(char c, char *base)
{
    int i = 0;
    while (base[i])
    {
        if (base[i] == c)
            return i;
        i++;
    }
    return -1; // character not in base
}

int ft_atoi_base(char *str, char *base)
{
    int i = 0;
    int sign = 1;
    int result = 0;
    int base_len;
    int val;

    if (!is_valid_base(base))
        return 0;

    // Find base length
    base_len = 0;
    while (base[base_len])
        base_len++;

    // Skip leading whitespace
    while (is_whitespace(str[i]))
        i++;

    // Handle signs
    while (str[i] == '+' || str[i] == '-')
    {
        if (str[i] == '-')
            sign = -sign;
        i++;
    }

    // Process digits
    while ((val = char_to_value(str[i], base)) != -1)
    {
        result = result * base_len + val;
        i++;
    }

    return result * sign;
}

#include <stdio.h>

int main(void)
{
    printf("%d\n", ft_atoi_base("101", "01"));           // binary → 5
    printf("%d\n", ft_atoi_base("-1A", "0123456789ABCDEF")); // hex → -26
    printf("%d\n", ft_atoi_base("zzz", "z"));            // invalid base → 0
    printf("%d\n", ft_atoi_base("   ---++123", "0123456789")); // decimal → -123
    printf("%d\n", ft_atoi_base("poney", "poneyvif"));   // custom octal → 142

    return 0;
}
