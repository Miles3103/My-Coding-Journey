/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_rev_params.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 02:24:29 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 02:25:11 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int main(int argc, char **argv)
{
    int i;
    int j;

    // Start from the last argument (argc - 1)
    // argv[0] is the program name, so we stop at index 1
    i = argc - 1;

    // Loop through arguments in reverse order
    while (i > 0)
    {
        j = 0;

        // Print each character of the current argument
        while (argv[i][j] != '\0')
        {
            write(1, &argv[i][j], 1);
            j++;
        }

        // Print a newline after each argument
        write(1, "\n", 1);
        i--;
    }

    return 0;
}

