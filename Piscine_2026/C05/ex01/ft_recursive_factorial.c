/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_recursive_factorial.c                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 02:05:55 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 02:06:34 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unisd.h>

int ft_recursive_factorial(int nb)
{
    if (nb < 0)
        return 0;           // factorial undefined for negative numbers
    if (nb == 0 || nb == 1)
        return 1;           // base case: 0! = 1, 1! = 1
    return nb * ft_recursive_factorial(nb - 1); // recursive call
}

#include <stdio.h>

int main(void)
{
    printf("%d\n", ft_recursive_factorial(0));  // Output: 1
    printf("%d\n", ft_recursive_factorial(1));  // Output: 1
    printf("%d\n", ft_recursive_factorial(5));  // Output: 120
    printf("%d\n", ft_recursive_factorial(-3)); // Output: 0
    printf("%d\n", ft_recursive_factorial(10)); // Output: 3628800

    return 0;
}
