/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strlcat.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 01:41:54 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 01:42:46 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

unsigned int ft_strlcat(char *dest, char *src, unsigned int size)
{
    unsigned int dest_len = 0;
    unsigned int src_len = 0;
    unsigned int i;

    // Find length of dest
    while (dest[dest_len] != '\0')
        dest_len++;

    // Find length of src
    while (src[src_len] != '\0')
        src_len++;

    // If size <= dest_len, no concatenation possible
    if (size <= dest_len)
        return size + src_len;

    // Copy from src to dest, but leave space for null terminator
    i = 0;
    while (src[i] != '\0' && dest_len + i < size - 1)
    {
        dest[dest_len + i] = src[i];
        i++;
    }

    dest[dest_len + i] = '\0'; // null-terminate

    return dest_len + src_len; // total length attempted
}

#include <stdio.h>

int main(void)
{
    char dest[20] = "Hello, ";
    char src[] = "World!";
    unsigned int ret;

    ret = ft_strlcat(dest, src, sizeof(dest));
    printf("dest: %s\n", dest); // Output: Hello, World!
    printf("return: %u\n", ret); // Output: 13 (length of Hello, + World!)

    return 0;
}

