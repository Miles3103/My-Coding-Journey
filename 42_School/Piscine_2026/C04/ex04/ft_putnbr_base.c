/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_putnbr_base.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 01:57:59 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 01:58:42 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int is_valid_base(char *base)
{
    int i, j;

    // Base must have at least 2 characters
    i = 0;
    while (base[i])
        i++;
    if (i < 2)
        return 0;

    // Check for '+' or '-' and duplicates
    for (i = 0; base[i]; i++)
    {
        if (base[i] == '+' || base[i] == '-')
            return 0;
        for (j = i + 1; base[j]; j++)
        {
            if (base[i] == base[j])
                return 0;
        }
    }
    return 1;
}

void ft_putnbr_base(int nbr, char *base)
{
    int base_len = 0;
    char c;

    if (!is_valid_base(base))
        return;

    while (base[base_len])
        base_len++;

    if (nbr < 0)
    {
        write(1, "-", 1);
        if (nbr == -2147483648) // Handle INT_MIN
        {
            ft_putnbr_base(-(nbr / base_len), base);
            c = base[-(nbr % base_len)];
            write(1, &c, 1);
            return;
        }
        nbr = -nbr;
    }

    if (nbr >= base_len)
        ft_putnbr_base(nbr / base_len, base);

    c = base[nbr % base_len];
    write(1, &c, 1);
}

int main(void)
{
    ft_putnbr_base(255, "0123456789ABCDEF"); // Hexadecimal
    write(1, "\n", 1);

    ft_putnbr_base(-42, "01");               // Binary
    write(1, "\n", 1);

    ft_putnbr_base(123, "01234567");         // Octal
    write(1, "\n", 1);

    ft_putnbr_base(42, "poneyvif");          // Custom base
    write(1, "\n", 1);

    ft_putnbr_base(42, "");                   // Invalid base, prints nothing
    write(1, "\n", 1);

    return 0;
}
