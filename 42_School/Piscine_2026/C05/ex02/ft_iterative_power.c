/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_iterative_power.c                               :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 02:08:01 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 02:12:39 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unisd.h>
#include <stdio.h>

int ft_iterative_power(int nb, int power)
{
    int result = 1; // Initialize result to 1, since any number^0 = 1
    int i = 0;      // Loop counter

    // If the power is negative, return 0 as per the exercise rules
    if (power < 0)
        return 0;

    // By definition, 0^0 = 1
    if (nb == 0 && power == 0)
        return 1;

    // Loop 'power' times to multiply nb by itself iteratively
    while (i < power)
    {
        result *= nb; // Multiply the current result by nb
        i++;          // Move to the next iteration
    }

    // After the loop, result contains nb raised to the power
    return result;
}

// Example main to test the function
int main(void)
{
    // 2^3 = 2*2*2 = 8
    printf("2^3 = %d\n", ft_iterative_power(2, 3));

    // 5^4 = 5*5*5*5 = 625
    printf("5^4 = %d\n", ft_iterative_power(5, 4));

    // 0^0 is defined as 1
    printf("0^0 = %d\n", ft_iterative_power(0, 0));

    // Negative power returns 0
    printf("3^-2 = %d\n", ft_iterative_power(3, -2));

    return 0;
}
