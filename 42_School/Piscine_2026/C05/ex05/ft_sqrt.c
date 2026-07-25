/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_sqrt.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 02:16:48 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 02:17:09 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

int ft_sqrt(int nb)
{
    int i;

    // If the number is negative, it has no real square root
    if (nb < 0)
        return 0;

    i = 0;

    // Try all possible integers i such that i * i <= nb
    while (i * i <= nb)
    {
        // If i squared is exactly nb, i is the square root
        if (i * i == nb)
            return i;
        i++;
    }

    // If no integer square root was found, return 0
    return 0;
}

/* Example main to test
int main(void)
{
    printf("%d\n", ft_sqrt(0));    // 0
    printf("%d\n", ft_sqrt(1));    // 1
    printf("%d\n", ft_sqrt(4));    // 2
    printf("%d\n", ft_sqrt(9));    // 3
    printf("%d\n", ft_sqrt(16));   // 4
    printf("%d\n", ft_sqrt(25));   // 5
    printf("%d\n", ft_sqrt(26));   // 0 (not a perfect square)
    printf("%d\n", ft_sqrt(-4));   // 0

    return 0;
}
*/
