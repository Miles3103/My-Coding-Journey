/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_print_program_name.c                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 02:20:10 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 02:20:22 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

int main(int argc, char **argv)
{
    int i;

    // argc is unused here, but we include it to respect the main prototype
    (void)argc;

    i = 0;

    // argv[0] contains the name used to run the program
    while (argv[0][i] != '\0')
    {
        // Write each character of the program name to standard output
        write(1, &argv[0][i], 1);
        i++;
    }

    // Print a newline at the end
    write(1, "\n", 1);

    return 0;
}
