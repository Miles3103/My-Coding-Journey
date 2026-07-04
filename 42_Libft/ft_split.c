/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_spilt.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: iismail- <iismail-@student.42warsaw.pl>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/07/04 23:31:50 by iismail-          #+#    #+#             */
/*   Updated: 2026/07/04 23:32:04 by iismail-         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

// 1. دالة مساعدة لعد الكلمات بدقة
static size_t	count_words(char const *s, char c)
{
	size_t	count;
	int		in_word;

	count = 0;
	in_word = 0;
	while (*s)
	{
		if (*s != c && in_word == 0)
		{
			in_word = 1;
			count++;
		}
		else if (*s == c)
		{
			in_word = 0;
		}
		s++;
	}
	return (count);
}

// 2. دالة مساعدة لتحرير كل شيء في حال حدوث فشل في المنتصف
static char	**free_all(char **result, size_t allocated_words)
{
	while (allocated_words > 0)
	{
		allocated_words--;
		free(result[allocated_words]);
	}
	free(result);
	return (NULL);
}

// 3. الدالة الأساسية لتقسيم وحجز الكلمات
char	**ft_split(char const *s, char c)
{
	char	**result;
	size_t	words;
	size_t	i;
	size_t	len;

	if (!s)
		return (NULL);
	words = count_words(s, c);
	result = (char **)malloc(sizeof(char *) * (words + 1));
	if (!result)
		return (NULL);
	i = 0;
	while (i < words)
	{
		while (*s && *s == c)
			s++;
		len = 0;
		while (s[len] && s[len] != c)
			len++;
		result[i] = ft_substr(s, 0, len);
		if (!result[i])
			return (free_all(result, i));
		s += len;
		i++;
	}
	result[i] = NULL;
	return (result);
}
