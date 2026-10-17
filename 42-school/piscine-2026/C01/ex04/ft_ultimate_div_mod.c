/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_ultimate_div_mod.c                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/09 23:40:42 by miles23           #+#    #+#             */
/*   Updated: 2026/02/09 23:42:57 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

void ft_ultimate_div_mod(int *a, int *b)
{
    int div;
    int mod;

    div = *a / *b;  // get the division of the values pointed to
    mod = *a % *b;  // get the remainder

    *a = div;  // store the division result back in *a
    *b = mod;  // store the remainder back in *b
}
