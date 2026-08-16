/* ************************************************************************** */
/*                                                                            */
/*   ft_structure.c                                     ###     #   #         */
/*   By: IM <ismailmahgoubismailabdalla@gmail.com>       #      ## ##         */
/*   Github: Miles3103                                   #      # # #         */
/*   Created: 2026/08/16 02:45:26 by IM                  #      #   #         */
/*   Updated: 2026/08/16 02:45:26 by IM                 ###     #   #         */
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>

void	ft_print(char *s)
{
	int	i;

	i = 0;
	if (!s)
		return ;
	while (s[i] != '\0')
	{
		write (1, &s[i], 1);
		i++;
	}
	write (1, "\n", 1);
}
int	main(void)
{
	ft_print("Syntax is power");
	return (0);
}
