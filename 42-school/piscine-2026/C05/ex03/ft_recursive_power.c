/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_recursive_power.c                               :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 02:14:04 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 02:14:36 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>
#include <stdio.h>

int ft_recursive_power(int nb, int power)
{
    // If the power is negative, return 0 as per the exercise rules
    if (power < 0)
        return 0;

    // By definition, 0^0 = 1
    if (nb == 0 && power == 0)
        return 1;

    // Base case: any number to the power of 0 is 1
    if (power == 0)
        return 1;

    // Recursive case: nb^power = nb * nb^(power - 1)
    return nb * ft_recursive_power(nb, power - 1);
}

// Example main to test the function
int main(void)
{
    printf("2^3 = %d\n", ft_recursive_power(2, 3));   // 2*2*2 = 8
    printf("5^4 = %d\n", ft_recursive_power(5, 4));   // 5*5*5*5 = 625
    printf("0^0 = %d\n", ft_recursive_power(0, 0));   // By definition = 1
    printf("3^-2 = %d\n", ft_recursive_power(3, -2)); // Negative power → 0
    printf("10^0 = %d\n", ft_recursive_power(10, 0)); // 10^0 = 1

    return 0;
}

