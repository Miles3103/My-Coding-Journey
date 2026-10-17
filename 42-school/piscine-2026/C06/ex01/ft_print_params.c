/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_print_params.c                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 02:21:36 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 02:21:46 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int main(int argc, char **argv)
{
    int i;
    int j;

    i = 1; // Start from 1 to skip argv[0] (program name)

    // Loop through all arguments passed to the program
    while (i < argc)
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
        i++;
    }

    return 0;
}
