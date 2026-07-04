/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_iterative_factorial.c                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 02:03:43 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 02:04:26 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int ft_iterative_factorial(int nb)
{
    int result = 1;
    int i;

    if (nb < 0)
        return 0; // factorial undefined for negative numbers

    for (i = 1; i <= nb; i++)
        result *= i;

    return result;
}

#include <stdio.h>

int main(void)
{
    printf("%d\n", ft_iterative_factorial(0));  // Output: 1
    printf("%d\n", ft_iterative_factorial(1));  // Output: 1
    printf("%d\n", ft_iterative_factorial(5));  // Output: 120
    printf("%d\n", ft_iterative_factorial(-3)); // Output: 0
    printf("%d\n", ft_iterative_factorial(10)); // Output: 3628800

    return 0;
}
