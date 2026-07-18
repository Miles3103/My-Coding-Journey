/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_spilt.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: iismail- <iismail-@student.42warsaw.pl>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/07/17 00:59:55 by iismail-          #+#    #+#             */
/*   Updated: 2026/07/17 01:01:28 by iismail-         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

static size_t	count_words(char const *s, char c)
{
	size_t	count;
	size_t	i;

	count = 0;
	i = 0;
	while (s[i] != '\0')
	{
		if (s[i] != c && (s[i + 1] == c || s[i + 1] == '\0'))
			count++;
		i++;
	}
	return (count);
}

static char	*alloc_word(char const *s, char c, size_t *index)
{
	size_t	len;
	size_t	i;
	char	*word;

	len = 0;
	while (s[*index] == c && s[*index] != '\0')
		(*index)++;
	while (s[*index + len] != c && s[*index + len] != '\0')
		len++;
	word = (char *)malloc(sizeof(char) * (len + 1));
	if (word == NULL)
		return (NULL);
	i = 0;
	while (i < len)
	{
		word[i] = s[*index];
		(*index)++;
		i++;
	}
	word[i] = '\0';
	return (word);
}

char	**ft_split(char const *s, char c)
{
	char	**result;
	size_t	words;
	size_t	i;
	size_t	s_idx;

	if (s == NULL)
		return (NULL);
	words = count_words(s, c);
	result = (char **)malloc(sizeof(char *) * (words + 1));
	if (result == NULL)
		return (NULL);
	i = 0;
	s_idx = 0;
	while (i < words)
	{
		result[i] = alloc_word(s, c, &s_idx);
		if (result[i] == NULL)
			return (NULL);
		i++;
	}
	result[i] = NULL;
	return (result);
}
