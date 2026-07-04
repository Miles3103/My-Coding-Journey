/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strstr.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: miles23 <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/02/10 01:38:56 by miles23           #+#    #+#             */
/*   Updated: 2026/02/10 01:40:47 by miles23          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>
#include <stdio.h>

char	*ft_strstr(char *str, char *to_find)	char *ft_strstr(char *str, char *to_find)
{
    int i;
    int j;

    // Empty string to_find always matches at start
    if (to_find[0] == '\0')
        return str;

    i = 0;
    while (str[i] != '\0')
    {
        j = 0;
        while (str[i + j] == to_find[j] && to_find[j] != '\0')
        {
            j++;
        }
        if (to_find[j] == '\0') // found the full string
            return &str[i];
        i++;
    }
    return 0; // not found
}


#include <stdio.h>

int main(void)
{
    char str[] = "Hello, World!";
    char to_find1[] = "World";
    char to_find2[] = "abc";

    printf("%s\n", ft_strstr(str, to_find1)); // Output: World!
    printf("%p\n", ft_strstr(str, to_find2)); // Output: 0 (NULL)
    printf("%s\n", ft_strstr(str, ""));       // Output: Hello, World! (empty string matches at start)

    return 0;
}
