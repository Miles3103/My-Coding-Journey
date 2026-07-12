/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   libft.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: iismail- <iismail-@student.42warsaw.pl>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/07/12 20:35:48 by iismail-          #+#    #+#             */
/*   Updated: 2026/07/12 22:55:35 by iismail-         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef LIBFT_H
# define LIBFT_H

# include <stddef.h> // size_t,Null
# include <stdlib.h> // malloc, free
# include <unistd.h> // write(used by the _fd functions)

typedef struct s_list
{
	void			*content;
	struct s_list	*next;
}	t_list;
/*Part 1 - Libc functions */
int		ft_isalpha(int c);
int		ft_isdigit(int c);
int		ft_isalnum(int c);
int		ft_isascii(int c);
int		ft_isprint(int c);
size_t	ft_strlen(const char *s);
void	*ft_memset(void *b, int c, size_t len);
#endif
