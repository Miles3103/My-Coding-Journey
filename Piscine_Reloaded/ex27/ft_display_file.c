/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_display_file.c                                  :+:      :+:    :+:   */
/*                                                     +:+ +:+         +:+    */
/*   By: student <student@student.42.fr>              +#+  +:+       +#+      */
/*                                                  +#+#+#+#+#+   +#+         */
/*   Created: 2026/06/21 00:00:00 by student           #+#    #+#             */
/*   Updated: 2026/06/21 00:00:00 by student           ###   ########.fr      */
/*                                                                            */
/* ************************************************************************** */

#include <fcntl.h>
#include <unistd.h>

#define BUFFER_SIZE 1024

static void	ft_error(char *msg)
{
	int	i;

	i = 0;
	while (msg[i] != '\0')
		i++;
	write(2, msg, i);
}

static int	ft_check_args(int argc)
{
	if (argc < 2)
	{
		ft_error("File name missing.\n");
		return (1);
	}
	if (argc > 2)
	{
		ft_error("Too many arguments.\n");
		return (1);
	}
	return (0);
}

static void	ft_cat(int fd)
{
	char	buf[BUFFER_SIZE];
	int		nb_read;

	nb_read = read(fd, buf, BUFFER_SIZE);
	while (nb_read > 0)
	{
		write(1, buf, nb_read);
		nb_read = read(fd, buf, BUFFER_SIZE);
	}
}

int	main(int argc, char **argv)
{
	int	fd;

	if (ft_check_args(argc) != 0)
		return (1);
	fd = open(argv[1], O_RDONLY);
	if (fd < 0)
	{
		ft_error("Cannot read file.\n");
		return (1);
	}
	ft_cat(fd);
	close(fd);
	return (0);
}
