/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_fibonacci.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 02:15:43 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 02:15:59 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

int ft_fibonacci(int index)
{
    // If index is negative, return -1 as required
    if (index < 0)
        return -1;

    // Base case:
    // Fibonacci(0) = 0
    if (index == 0)
        return 0;

    // Base case:
    // Fibonacci(1) = 1
    if (index == 1)
        return 1;

    // Recursive case:
    // Fibonacci(n) = Fibonacci(n - 1) + Fibonacci(n - 2)
    return ft_fibonacci(index - 1) + ft_fibonacci(index - 2);
}

/* Example main to test
int main(void)
{
    printf("%d\n", ft_fibonacci(0)); // 0
    printf("%d\n", ft_fibonacci(1)); // 1
    printf("%d\n", ft_fibonacci(2)); // 1
    printf("%d\n", ft_fibonacci(3)); // 2
    printf("%d\n", ft_fibonacci(7)); // 13
    printf("%d\n", ft_fibonacci(-1)); // -1
    return 0;
}
*/
