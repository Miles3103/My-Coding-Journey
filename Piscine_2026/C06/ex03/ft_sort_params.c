/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_sort_params.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 02:26:07 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 02:26:26 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

/* Compare two strings in ASCII order
   Returns:
   < 0 if s1 < s2
   = 0 if s1 == s2
   > 0 if s1 > s2 */
int ft_strcmp(char *s1, char *s2)
{
    int i;

    i = 0;
    while (s1[i] && s2[i] && s1[i] == s2[i])
        i++;
    return (s1[i] - s2[i]);
}

/* Swap two string pointers */
void ft_swap(char **a, char **b)
{
    char *tmp;

    tmp = *a;
    *a = *b;
    *b = tmp;
}

int main(int argc, char **argv)
{
    int i;
    int j;

    // Bubble sort on argv, starting from index 1
    i = 1;
    while (i < argc - 1)
    {
        j = 1;
        while (j < argc - i)
        {
            // If the current argument is greater than the next one, swap them
            if (ft_strcmp(argv[j], argv[j + 1]) > 0)
                ft_swap(&argv[j], &argv[j + 1]);
            j++;
        }
        i++;
    }

    // Print sorted arguments (skip argv[0])
    i = 1;
    while (i < argc)
    {
        j = 0;
        while (argv[i][j])
        {
            write(1, &argv[i][j], 1);
            j++;
        }
        write(1, "\n", 1);
        i++;
    }

    return 0;
}
