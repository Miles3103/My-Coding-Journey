/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_putnbr.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 01:53:23 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 01:53:44 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

void ft_putnbr(int nb)
{
    char c;

    if (nb == -2147483648) // handle INT_MIN
    {
        write(1, "-2147483648", 11);
        return;
    }
    if (nb < 0)
    {
        write(1, "-", 1);
        nb = -nb;
    }
    if (nb >= 10)
        ft_putnbr(nb / 10); // print all but last digit

    c = (nb % 10) + '0'; // get last digit as character
    write(1, &c, 1);
}

int main(void)
{
    ft_putnbr(12345);
    write(1, "\n", 1);
    ft_putnbr(-9876);
    write(1, "\n", 1);
    ft_putnbr(-2147483648);
    write(1, "\n", 1);
    ft_putnbr(0);
    write(1, "\n", 1);
    return 0;
}
